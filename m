Return-Path: <linux-kernel-owner+w=401wt.eu-S1759209AbYFLK5J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759209AbYFLK5J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 06:57:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755715AbYFLK4z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 06:56:55 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:24185 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754931AbYFLK4y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 06:56:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=JeNl4gaUOE+6OoUoQbvkCtsySXw5Y3+bJu9c8jhSPPxltmLe7/0lpfHdJzD5IXs91j
         6HVm9FIhTt8aQf3IcqYPPsaj7OVp5hw69aqe67Asqs34kd4gzj4aHZBcjcxPE40Rnyx6
         Jekqs651Mi1VTmAriitPMaTicGxM66Wn3/PbE=
Message-ID: <5a4c581d0806120356x3e933967od7ce0e109037306f@mail.gmail.com>
Date: Thu, 12 Jun 2008 12:56:46 +0200
From: "Alessandro Suardi" <alessandro.suardi@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [2.6.26-rc5-git2] WARNING: at kernel/lockdep.c:2658 check_flags+0x4c/0x128()
Cc: "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Vegard Nossum" <vegard.nossum@gmail.com>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20080612073014.GA9402@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <5a4c581d0806111506m31412b21lee7bb851dabe6576@mail.gmail.com>
	 <19f34abd0806112355v7330ccd4x41e66151f333c144@mail.gmail.com>
	 <1213254306.31518.84.camel@twins> <20080612073014.GA9402@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 12, 2008 at 9:30 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
>
>> On Thu, 2008-06-12 at 08:55 +0200, Vegard Nossum wrote:
>>
>>
>> > From: Vegard Nossum <vegard.nossum@gmail.com>
>> > Date: Thu, 12 Jun 2008 08:49:18 +0200
>> > Subject: [PATCH] x86: more hardirq annotations for notify_die()
>> >
>> > Reported-by: Alessandro Suardi <alessandro.suardi@gmail.com>
>> > Signed-off-by: Vegard Nossum <vegard.nossum@gmail.com>
>> > ---
>> >  arch/x86/kernel/traps_32.c |    1 +
>> >  1 files changed, 1 insertions(+), 0 deletions(-)
>> >
>> > diff --git a/arch/x86/kernel/traps_32.c b/arch/x86/kernel/traps_32.c
>> > index bde6f63..be9ecae 100644
>> > --- a/arch/x86/kernel/traps_32.c
>> > +++ b/arch/x86/kernel/traps_32.c
>> > @@ -569,6 +569,7 @@ void do_##name(struct pt_regs *regs, long error_code)                   \
>> >  #define DO_VM86_ERROR(trapnr, signr, str, name)                            \
>> >  void do_##name(struct pt_regs *regs, long error_code)                      \
>> >  {                                                                  \
>> > +   trace_hardirqs_fixup();                                         \
>> >     if (notify_die(DIE_TRAP, str, regs, error_code, trapnr, signr)  \
>> >                                             == NOTIFY_STOP)         \
>> >             return;                                                 \
>>
>> Yeah, I think this is ok, actual traps don't have any way of knowing the
>> actual IRQ state afaik. So
>>
>> Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
>
> applied to tip/x86/urgent - thanks.
>
> Alessandro, does the patch from Vegard fix the ltrace warning for you?
>
>        Ingo
>

I don't  know whether the issue is reproducable at will.

I'll give the patch a go when I come home from work
 later, trying to put back the rogue nautilus RPM and
 putting it under ltrace, then report back.

Thanks for the quick turnaround, hope to be able to
 provide feedback later. Ciao,

--alessandro

 "Give me love / Or give me hate
 Give me anything that's not just ok"

 (Sophia, 'Weightless')
