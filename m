Return-Path: <linux-kernel-owner+w=401wt.eu-S1754664AbZLWJBb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754664AbZLWJBb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 04:01:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754172AbZLWJB3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 04:01:29 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:35755 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754512AbZLWJB2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 04:01:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=fnGbfe6TR9Ar7qz/QzH0SSPaYr1i+kgGsLXvZ/IYZYFd1sdjQOQQywl/j+93mAy+qM
         EniSNMcoNsvJu11iNBGpTjF0OxjwOyQ1rdfitSqyb7NX8JG4KMvWoGFUwC8CBSw/i3ln
         jeCVejWi+dfTvvfXFG9/m3HoZhlq+eNaelOu4=
MIME-Version: 1.0
In-Reply-To: <1261557812.4937.118.camel@laptop>
References: <20091221091754.GG4489@kernel.dk> <4B2F768C.1040704@kernel.org>
	 <4B2F7DD2.2080902@linux.intel.com> <4B2F83F6.2040705@kernel.org>
	 <4B2F9212.3000407@linux.intel.com> <4B300C01.8080904@kernel.org>
	 <1261504042.4937.59.camel@laptop>
	 <20091222180703.GI10314@basil.fritz.box>
	 <c76f371a0912230017n7d3f5c89h849aa23efa6f75e5@mail.gmail.com>
	 <1261557812.4937.118.camel@laptop>
Date: Wed, 23 Dec 2009 10:01:26 +0100
Message-ID: <c76f371a0912230101s7930a437h9c9582be34fc934e@mail.gmail.com>
Subject: Re: workqueue thing
From: Stijn Devriendt <highguy@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andi Kleen <andi@firstfloor.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Tejun Heo <tj@kernel.org>, Arjan van de Ven <arjan@linux.intel.com>,
       Jens Axboe <jens.axboe@oracle.com>, awalls@radix.net,
       linux-kernel@vger.kernel.org, jeff@garzik.org, mi@jasper.es
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 23, 2009 at 9:43 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Wed, 2009-12-23 at 09:17 +0100, Stijn Devriendt wrote:
>> On Tue, Dec 22, 2009 at 7:07 PM, Andi Kleen <andi@firstfloor.org> wrote:
>> > One reason I liked a more dynamic frame work for this is that it
>> > has the potential to be exposed to user space and allow automatic
>> > work partitioning there based on available cores.  User space
>> > has a lot more CPU consumption than the kernel.
>> >
>> Basically, this is exactly what I was trying to solve with my
>> sched_wait_block patch. It was broken in all ways, but the ultimate
>> goal was to have concurrency managed workqueues (to nick the term)
>> in userspace and have a way out when I/O hits the workqueue.
>
> Don't we have the problem of wakeup concurrency here?
>
> Forking on blocking is only half the problem (and imho the easy half).
>
>

The original design was to always have 1 spare thread handy that would
wait until the worker-thread blocked. At that point it would wakeup and
continue trying to keep the CPU busy.
The current perf-event approach is to have threads poll based upon the
concurrency as measured in the kernel by the perf-event. When too many
threads are on the runqueue, the poll() blocks. When threads go to sleep/block
another thread falls out of poll()to continue work.

Stijn
