Return-Path: <linux-kernel-owner+w=401wt.eu-S1759895AbYGACdc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759895AbYGACdc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 22:33:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753369AbYGACdW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 22:33:22 -0400
Received: from wf-out-1314.google.com ([209.85.200.170]:43469 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753400AbYGACdV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 22:33:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=occrlYvjE35ic6vYAsTV7yN3bUQLJdA9kiXpHTztW7V55wyuP8LHasALH0Pbns2z6p
         qeM7V5/WMQxdCUxFsSPCwg6G6eP9s00pAzXo4x5M6XUyLW8EV+kLrdTSMR+JDlvwO9kO
         4d/GaKXfFavdtET+sVMKoAWIjnFEXeuq7FbPc=
Message-ID: <505766fa0806301933w65924ce0x3195f9e2dd82e7bb@mail.gmail.com>
Date: Tue, 1 Jul 2008 10:33:16 +0800
From: hyl <heyongli@gmail.com>
To: "John Blackwood" <john.blackwood@ccur.com>
Subject: Re: [patch][RFC] an early patch for x86_64 preempt-rt kernel cause more __might_sleep warnings
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <4868D792.6020205@ccur.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4868D792.6020205@ccur.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/6/30 John Blackwood <john.blackwood@ccur.com>:
>> Subject: Re: [patch][RFC] an early patch for x86_64 preempt-rt kernel
>> cause more __might_sleep warnings
>> From: hyl <heyongli@gmail.com>
>> Date: Wed, 25 Jun 2008 22:38:50 -0400
>> To: "Blackwood, John" <john.blackwood@ccur.com>
>>
>> > > ------------------------------ ------------------------------
>> > >
>> > > Subject: Re: your x86_64 IST stack preempt rt patch
>> > > From: Andi Kleen <andi@firstfloor.org>
>> > > Date: Wed, 25 Jun 2008 03:36:33 -0400
>> > > To: "Blackwood, John" <john.blackwood@ccur.com>
>> > >
>> > >
>> > > This patch changes these traps instead to always switch
>> > > to the process stack when the trap originated from user mode.
>> > > For kernel traps it keeps running non preemptive on the IST stack
>> > > because that is much safer (e.g. to still get nmi watchdog events
>> > > out even when the process stack is corrupted)
>> > >
>> > > Strictly the change would have been only needed for debug
>> > > and int3, but since they share this code as macros it was
>> > > cleanest to just change all.
>> > >
>> > > Additional (small) benefit is less preemption latency in these
>> > > exception cases. This will also likely help preempt-RT kernels a bit
>> > > because those are more likely to take sleeping locks even in these
>> > > cases.
>> > >
>>
>> But with this fix, we still run do_debug/.. on IST when the 'interrupt'
>> occur from kernel space, so the warning message will come out again,
>> right?
>
> that seems correct to me.
>
>> but i don't have a scenario  to proof this.
>
> i think that using something like kgdb or kdb kernel debuggers
> would end up causing this situation.
>
> or using ptrace from user space to set up a debug register to point
> to some kernel address as a breakpoint or watchpoint (this wouldn't be
> something that people would usually want to do though).
  yeah, but there is no patch try to fix it, do you found one ?
>
>
>
>
>
