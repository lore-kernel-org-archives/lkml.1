Return-Path: <linux-kernel-owner+w=401wt.eu-S965194AbXCCMHK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965194AbXCCMHK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2007 07:07:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965211AbXCCMHK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Mar 2007 07:07:10 -0500
Received: from smtp.osdl.org ([65.172.181.24]:35091 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965194AbXCCMHI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2007 07:07:08 -0500
Date: Sat, 3 Mar 2007 04:06:59 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.21-rc2-mm1
Message-Id: <20070303040659.76765ad1.akpm@linux-foundation.org>
In-Reply-To: <45E94933.4010206@googlemail.com>
References: <20070302030026.5eef0c92.akpm@linux-foundation.org>
	<6bffcb0e0703021542k4f882531r21807c7efdbd0ebc@mail.gmail.com>
	<20070302164009.a2aa6cbc.akpm@linux-foundation.org>
	<45E8CDF3.7010406@googlemail.com>
	<20070302174110.5740b09e.akpm@linux-foundation.org>
	<45E94933.4010206@googlemail.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 03 Mar 2007 11:08:51 +0100 Michal Piotrowski <michal.k.k.piotrowski@gmail.com> wrote:

> Andrew Morton napisał(a):
> > On Sat, 03 Mar 2007 02:22:59 +0100
> > Michal Piotrowski <michal.k.k.piotrowski@gmail.com> wrote:
> > 
> >> Andrew Morton napisa__(a):
> >>> On Sat, 3 Mar 2007 00:42:33 +0100
> >>> "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com> wrote:
> >>>
> >>>> On 02/03/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> >>>>> Temporarily at
> >>>>>
> >>>>>   http://userweb.kernel.org/~akpm/2.6.21-rc2-mm1/
> >>>>>
> >>>> I have noticed some strange system behavior. When i try to build a
> >>>> kernel (medium load) - X, keyboard, mouse and sound hangs.
> >>>>
> >>>> I can ping machine and I can use magic SysRq key, but that's all.
> >>>>
> >>>> 2.6.20-mm2 was fine, 2.6.21-rc2 works well (over 800 patches since
> >>>> 2.6.20-mm2 - great...)
> >>>>
> >>>> NIL (Nothing Interesting in Logs)
> >>>>
> >>> Can we see the sysrq-T output please?
> >>>
> >> http://www.stardust.webpages.pl/files/tbf/bitis-gabonica/2.6.21-rc2-mm1/sys.log
> >>
> > 
> > Well that's all very dull - everything's just sitting there asleep.
> > 
> > If it was just X then I'd suspect the psmouse changes (are you PS2 or USB?)
> > 
> > Or I'd suspect that the entire interrupt system has gone bust, but you're
> > still able to do sysrq.
> > 
> > How are you doing sysrq, btw?   Serial console?  alt-F7 into a vgaconsole?
> 
> alt + sysrq + key, but alt + fX doesn't work
> 
> > Are you able to log in from another machine via ssh?
> 
> Yes.

I mean - after the system has failed, you are still able to log in, get a
shell, run commands?

If so, that's strange, because sshd is still running.

What does `top' say in that case, when you re-run it.

Generally, have a poke around, see if you can work out what the system it
doing.

> > 
> > Is the CPU idle when it hangs, or is it busy?  If busy, what does sysrq-P
> > say?
> > 
> > 
> 
> Pid: 3716, comm:          firefox-bin
> EIP: 0073:[<b23bb9d1>] CPU: 0
> EIP is at 0xb23bb9d1
>  ESP: 007b:afdfd1d0 EFLAGS: 00000202    Not tainted  (2.6.21-rc2-mm1 #23)
> EAX: 00000001 EBX: b25ee12c ECX: 00000018 EDX: 00000018
> ESI: 0944e91c EDI: 0944e900 EBP: afdfd398 DS: 007b ES: 007b FS: 0000
> CR0: 8005003b CR2: 40954000 CR3: 32bdc000 CR4: 000006d0
>  [<c0105256>] show_trace_log_lvl+0x1a/0x2f
>  [<c010597b>] show_trace+0x12/0x14
>  [<c0102acf>] show_regs+0x181/0x188
>  [<c0261010>] sysrq_handle_showregs+0x12/0x14
>  [<c0260f47>] __handle_sysrq+0x8c/0x109
>  [<c0261122>] handle_sysrq+0x1f/0x21
>  [<c025bd6e>] kbd_event+0x2d8/0x4ee
>  [<c02bcae2>] input_event+0x420/0x442
>  [<c02c01b0>] atkbd_interrupt+0x448/0x514
>  [<c02b986e>] serio_interrupt+0x49/0x7f
>  [<c02ba6a8>] i8042_interrupt+0x226/0x239
>  [<c0155642>] handle_IRQ_event+0x1a/0x46
>  [<c015675a>] handle_edge_irq+0x10a/0x14e
>  [<c0106c22>] do_IRQ+0xa3/0xbd
>  [<c0104c52>] common_interrupt+0x2e/0x34

That indicates that firefox is running in userspace
