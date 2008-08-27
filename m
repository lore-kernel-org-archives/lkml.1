Return-Path: <linux-kernel-owner+w=401wt.eu-S1753885AbYH0GcV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753885AbYH0GcV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 02:32:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752560AbYH0GcN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 02:32:13 -0400
Received: from rv-out-0506.google.com ([209.85.198.232]:8192 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752286AbYH0GcM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 02:32:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=JOV7trZBTrOIB+h1zpytw34pMvgbtKeDmfZAhB4cOFvRZLAYKQ1HZVXsK2JsD/JYCu
         6ZAQmOXANaFU34eW0M0bCUAVnFDKsOur1Id4OYJt1pcswp4Ohs1jR9o81zFxJb5Czovq
         +esV5tyUwDsGErXk4dgRnsYUsrdWrFKw/tJ4I=
Message-ID: <804dabb00808262332l4fb0a4d6i8adee9c809c65901@mail.gmail.com>
Date: Wed, 27 Aug 2008 14:32:11 +0800
From: "Peter Teoh" <htmldeveloper@gmail.com>
To: "Peter Zijlstra" <peterz@infradead.org>
Subject: Re: Locking API testsuite: Failures
Cc: LKML <linux-kernel@vger.kernel.org>, "Ingo Molnar" <mingo@elte.hu>
In-Reply-To: <1219802311.6462.26.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <804dabb00808261727o3ba1f3c0xc25d27ad0694aab4@mail.gmail.com>
	 <1219802311.6462.26.camel@twins>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for the reply.

On Wed, Aug 27, 2008 at 9:58 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Wed, 2008-08-27 at 08:27 +0800, Peter Teoh wrote:
>> [    0.000999] | Locking API testsuite:
>> [    0.000999] ----------------------------------------------------------------------------
>> [    0.000999]                                  | spin |wlock |rlock
>> |mutex | wsem | rsem |
>> [    0.000999]
>> --------------------------------------------------------------------------
>> [    0.000999]                      A-A deadlock:failed|failed|  ok
>> |failed|failed|failed|
>> [    0.000999]                  A-B-B-A deadlock:failed|failed|  ok
>> |failed|failed|failed|
>> [    0.000999]              A-B-B-C-C-A deadlock:failed|failed|  ok
>> |failed|failed|failed|
>> [    0.000999]              A-B-C-A-B-C deadlock:failed|failed|  ok
>> |failed|failed|failed|
>> [    0.000999]          A-B-B-C-C-D-D-A deadlock:failed|failed|  ok
>> |failed|failed|failed|
>> [    0.000999]          A-B-C-D-B-D-D-A deadlock:failed|failed|  ok
>> |failed|failed|failed|
>> [    0.000999]          A-B-C-D-B-C-D-A deadlock:failed|failed|  ok
>> |failed|failed|failed|
>> [    0.000999]                     double
>> unlock:failed|failed|failed|failed|failed|failed|
>> [    0.000999]                   initialize
>> held:failed|failed|failed|failed|failed|failed|
>> [    0.000999]                  bad unlock order:  ok  |  ok  |  ok  |
>>  ok  |  ok  |  ok  |
>> [    0.000999]
>> --------------------------------------------------------------------------
>> [    0.000999]               recursive read-lock:             |  ok  |
>>             |failed|
>> [    0.000999]            recursive read-lock #2:             |  ok  |
>>             |failed|
>> [    0.000999]             mixed read-write-lock:             |failed|
>>             |failed|
>> [    0.000999]             mixed write-read-lock:             |failed|
>>             |failed|
>> [    0.000999]
>> --------------------------------------------------------------------------
>> [    0.000999]      hard-irqs-on + irq-safe-A/12:failed|failed|  ok  |
>> [    0.000999]      soft-irqs-on + irq-safe-A/12:failed|failed|  ok  |
>> [    0.000999]      hard-irqs-on + irq-safe-A/21:failed|failed|  ok  |
>> [    0.000999]      soft-irqs-on + irq-safe-A/21:failed|failed|  ok  |
>> [    0.000999]        sirq-safe-A => hirqs-on/12:failed|failed|  ok  |
>> [    0.000999]        sirq-safe-A => hirqs-on/21:failed|failed|  ok  |
>> [    0.000999]          hard-safe-A + irqs-on/12:failed|failed|  ok  |
>> [    0.000999]          soft-safe-A + irqs-on/12:failed|failed|  ok  |
>> [    0.000999]          hard-safe-A + irqs-on/21:failed|failed|  ok  |
>> [    0.000999]          soft-safe-A + irqs-on/21:failed|failed|  ok  |
>> [    0.000999]     hard-safe-A + unsafe-B #1/123:failed|failed|  ok  |
>> [    0.000999]     soft-safe-A + unsafe-B #1/123:failed|failed|  ok  |
>>
>> truncated....
>>
>> I am just curious what does all these failures imply?
>
> Probably that you forgot to enable lockdep ;-)
>

Several questions:

1.   I noticed there is a Kconfig.debug with this entry:

config DEBUG_LOCKING_API_SELFTESTS
        bool "Locking API boot-time self-tests"
        depends on DEBUG_KERNEL
        help
          Say Y here if you want the kernel to run a short self-test during
          bootup. The self-test checks whether common types of locking bugs
          are detected by debugging mechanisms or not. (if you disable
          lock debugging then those bugs wont be detected of course.)
          The following locking APIs are covered: spinlocks, rwlocks,
          mutexes and rwsems.

How do I use this Kconfig.debug, just overwriting the standard
lib/Kconfig?   I overwrote it and got the following errors:

scripts/kconfig/conf -o arch/x86/Kconfig
file kernel/trace/Kconfig already scanned?
make[1]: *** [oldconfig] Error 1
make: *** [oldconfig] Error 2

2.   So does it make sense to  compile with
CONFIG_DEBUG_LOCKING_API_SELFTESTS without CONFIG_LOCKDEP?
Should the lib/Kconfig indicate such a dependency?

3.   My current .config (which gave rise to the failure errors) has
CONFIG_LOCKDEP_SUPPORT=y, and CONFIG_DEBUG_LOCKING_API_SELFTESTS=y.
Question is what is the different between LOCKDEP_SUPPORT and LOCKDEP
alone?

Thanks.

> In which case the error cases fail to produce an error, and the test
> fails, but its an expected error, otherwise it would have shouted much
> more verbose.
>
>
>
>



-- 
Regards,
Peter Teoh
