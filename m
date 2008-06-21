Return-Path: <linux-kernel-owner+w=401wt.eu-S1752447AbYFURWu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752447AbYFURWu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2008 13:22:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751462AbYFURWk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jun 2008 13:22:40 -0400
Received: from fk-out-0910.google.com ([209.85.128.188]:60008 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751037AbYFURWj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2008 13:22:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=PL0earq4sZmDfz67ZcPv3Y1aYm7zCSC72P2eArI+m3FFfLLMpZo1c5dvzhhxI4Ue4y
         1vJhVEmB+5W5Lw3gLznLqKdorwBTdTyvwn4UdSoLDo7PnpBP8FZeRQ+YaVQcHQDBTsyC
         Jhr/hlk8G0akjYKLrr/e4mpeb1M+7CZh7GaSM=
Message-ID: <5a4c581d0806211022w58648606g65089598524721db@mail.gmail.com>
Date: Sat, 21 Jun 2008 19:22:38 +0200
From: "Alessandro Suardi" <alessandro.suardi@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [2.6.26-rc5-git2] WARNING: at kernel/lockdep.c:2658 check_flags+0x4c/0x128()
Cc: "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Vegard Nossum" <vegard.nossum@gmail.com>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <5a4c581d0806120356x3e933967od7ce0e109037306f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <5a4c581d0806111506m31412b21lee7bb851dabe6576@mail.gmail.com>
	 <19f34abd0806112355v7330ccd4x41e66151f333c144@mail.gmail.com>
	 <1213254306.31518.84.camel@twins> <20080612073014.GA9402@elte.hu>
	 <5a4c581d0806120356x3e933967od7ce0e109037306f@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 12, 2008 at 12:56 PM, Alessandro Suardi
<alessandro.suardi@gmail.com> wrote:
> On Thu, Jun 12, 2008 at 9:30 AM, Ingo Molnar <mingo@elte.hu> wrote:
>>
>> * Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
>>
>>> On Thu, 2008-06-12 at 08:55 +0200, Vegard Nossum wrote:
>>>
>>>
>>> > From: Vegard Nossum <vegard.nossum@gmail.com>
>>> > Date: Thu, 12 Jun 2008 08:49:18 +0200
>>> > Subject: [PATCH] x86: more hardirq annotations for notify_die()
>>> >
>>> > Reported-by: Alessandro Suardi <alessandro.suardi@gmail.com>
>>> > Signed-off-by: Vegard Nossum <vegard.nossum@gmail.com>
>>> > ---
>>> >  arch/x86/kernel/traps_32.c |    1 +
>>> >  1 files changed, 1 insertions(+), 0 deletions(-)
>>> >
>>> > diff --git a/arch/x86/kernel/traps_32.c b/arch/x86/kernel/traps_32.c
>>> > index bde6f63..be9ecae 100644
>>> > --- a/arch/x86/kernel/traps_32.c
>>> > +++ b/arch/x86/kernel/traps_32.c
>>> > @@ -569,6 +569,7 @@ void do_##name(struct pt_regs *regs, long error_code)                   \
>>> >  #define DO_VM86_ERROR(trapnr, signr, str, name)                            \
>>> >  void do_##name(struct pt_regs *regs, long error_code)                      \
>>> >  {                                                                  \
>>> > +   trace_hardirqs_fixup();                                         \
>>> >     if (notify_die(DIE_TRAP, str, regs, error_code, trapnr, signr)  \
>>> >                                             == NOTIFY_STOP)         \
>>> >             return;                                                 \
>>>
>>> Yeah, I think this is ok, actual traps don't have any way of knowing the
>>> actual IRQ state afaik. So
>>>
>>> Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
>>
>> applied to tip/x86/urgent - thanks.
>>
>> Alessandro, does the patch from Vegard fix the ltrace warning for you?
>>
>>        Ingo
>>
>
> I don't  know whether the issue is reproducable at will.
>
> I'll give the patch a go when I come home from work
>  later, trying to put back the rogue nautilus RPM and
>  putting it under ltrace, then report back.
>
> Thanks for the quick turnaround, hope to be able to
>  provide feedback later. Ciao,

All right, finally had time to try this one, and it's good for
 me - patch on top of 2.6.26-rc7, the WARNING does not
 appear in over three minutes of ltracing nautilus even
 with load climbing up to 6 while just two gnome-terminals
 (one running 'top' and the other running 'ltrace') and a
 firefox with two tabs are opened under XVnc. Hence,

Tested-by: <alessandro.suardi@gmail.com>

BTW, both the old and the new nautilus package have
 horrible performance under VNC, I guess I noticed the
 new one simply due to a fresh-start effect...

Thanks !

--alessandro

 "Give me love / Or give me hate
 Give me anything that's not just ok"

 (Sophia, 'Weightless')
