Return-Path: <linux-kernel-owner+w=401wt.eu-S1757428AbXGLFnT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757428AbXGLFnT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 01:43:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751494AbXGLFnL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 01:43:11 -0400
Received: from il.qumranet.com ([82.166.9.18]:47239 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750971AbXGLFnK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 01:43:10 -0400
Message-ID: <4695BF6C.9000501@qumranet.com>
Date: Thu, 12 Jul 2007 08:43:08 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: Luca <kronos.it@gmail.com>
CC: kvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [kvm-devel] [PATCH 2/2] KVM: Use the scheduler preemption hooks
 to make kvm preemptible
References: <11841693332609-git-send-email-avi@qumranet.com>	 <1184169333786-git-send-email-avi@qumranet.com> <68676e00707111310v4862974am37dc7c723486b96c@mail.gmail.com>
In-Reply-To: <68676e00707111310v4862974am37dc7c723486b96c@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (firebolt.argo.co.il [0.0.0.0]); Thu, 12 Jul 2007 08:43:09 +0300 (IDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Luca wrote:
> On 7/11/07, Avi Kivity <avi@qumranet.com> wrote:
>> Current kvm disables preemption while the new virtualization
>> registers are
>> in use.  This of course is not very good for latency sensitive
>> workloads (one
>> use of virtualization is to offload user interface and other latency
>> insensitive stuff to a container, so that it is easier to analyze the
>> remaining workload).  This patch re-enables preemption for kvm;
>> preemption
>> is now only disabled when switching the registers in and out, and during
>> the switch to guest mode and back.
> [...]
>> diff --git a/drivers/kvm/Kconfig b/drivers/kvm/Kconfig
>> index 33fa28a..92644b5 100644
>> --- a/drivers/kvm/Kconfig
>> +++ b/drivers/kvm/Kconfig
>> @@ -10,7 +10,7 @@ if VIRTUALIZATION
>>
>>  config KVM
>>         tristate "Kernel-based Virtual Machine (KVM) support"
>> -       depends on X86 && EXPERIMENTAL
>> +       depends on X86 && EXPERIMENTAL && PREEMPT_HOOKS
>>         depends on X86_CMPXCHG64 || 64BIT
>
> select PREEMPT_HOOKS maybe?
>

Yes.  And default PREEMPT_HOOKS to n in the first patch.  I'll make both
these changes.


-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

