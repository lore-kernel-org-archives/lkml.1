Return-Path: <linux-kernel-owner+w=401wt.eu-S1759017AbYHNROT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759017AbYHNROT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 13:14:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753219AbYHNROF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 13:14:05 -0400
Received: from Powered.by.Root24.eu ([81.169.180.23]:38620 "EHLO Root24.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751575AbYHNROE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 13:14:04 -0400
X-Greylist: delayed 440 seconds by postgrey-1.27 at vger.kernel.org; Thu, 14 Aug 2008 13:14:03 EDT
Message-ID: <48A46618.4060306@ionic.de>
Date: Thu, 14 Aug 2008 19:06:32 +0200
From: Mihai Moldovan <ionic@ionic.de>
User-Agent: Thunderbird 2.0.0.16 (X11/20080728)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: [PROBLEM] Kernel crashes with 2.6.25-rc1 and above
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Kernel Hackers,

as indicated in the Subject line, I've got some sort of problem. All 
Kernel above (and equal) 2.6.25-rc1 are crashing on my Notebook after a 
*random* time, thus preventing me of using them.

When I first noticed that problem, I tried to get some usable result by 
bisecting the Kernel, but after 2 weeks of bisecting only, I've given up.

My machine locks up after a random amount of uptime, and this is a real 
problem. Before bisecting, I thought that this time would be at most 30 
minutes (and in fact, newer Kernels seem to crash more rapid than older 
ones), but while bisecting, I've come across the phenomena, that it 
might take as well 2 or 4 hours for the box to crash. This in fact 
means, that all my bisecting efforts are for the nuts, because I might 
have marked versions as good, while they indeed were "bad" (I've marked 
all Kernels "good" which still worked after 1 hour uptime, later I 
changed to 2 hours, but I still...)

All in all, the problem is that I cannot really say whether a version is 
good or bad, but after letting the box run for x hours... and x is 
undefined. It might be a safe thing to let  the box run 24 hours for 
each Kernel  and then mark the version as good or bad, but given that I 
will have to test 13 or more Kernels this will make 2 weeks of testing 
Kernels only, and I hope you can bear with me, this is really a lot of time.

Now, describing what happens is simple: the machine will totally lock 
itself. No input or output is working anymore, the Kernel will not 
respond to SysRq presses and also not respond to ping anymore. Due to 
this fact, also no panic message is logged and honestly, I have not seen 
any this whole time either.

I really am confused about this.

The only messages I could get were "Hangcheck: hangcheck value past 
margin!", "rtc: lost y interrupts" (y is quite random as well) and this 
one, when running hwclock:

------------[ cut here ]------------
WARNING: at kernel/lockdep.c:2033 trace_hardirqs_on+0x9b/0x10d()
Modules linked in: irtty_sir sir_dev ipw2200 yenta_socket rsrc_nonstatic 
pcmcia_core tifm_7xx1 tifm_core sky2
Pid: 2704, comm: hwclock Not tainted 
2.6.24-uvesafb-tuxonice-squashFS3.2-04814-gd2e626f #1
 [<c01205ec>] warn_on_slowpath+0x41/0x51
 [<c010b376>] ? save_stack_address+0x0/0x28
 [<c013a2e1>] ? check_usage_forwards+0x19/0x3b
 [<c013b726>] ? __lock_acquire+0xac2/0xb0a
 [<c03942db>] ? ata_qc_complete+0x115/0x128
 [<c0108c60>] ? native_sched_clock+0x8b/0x9f
 [<c0138b89>] ? put_lock_stats+0xd/0x21
 [<c05362ec>] ? _spin_unlock_irq+0x22/0x42
 [<c013a83f>] trace_hardirqs_on+0x9b/0x10d
 [<c05362ec>] _spin_unlock_irq+0x22/0x42
 [<c0114829>] hpet_rtc_interrupt+0xdf/0x290
 [<c01509d8>] handle_IRQ_event+0x1a/0x46
 [<c0151832>] handle_edge_irq+0xbe/0xff
 [<c0151774>] ? handle_edge_irq+0x0/0xff
 [<c0106f09>] do_IRQ+0xab/0xd4
 [<c010555a>] common_interrupt+0x2e/0x34
 =======================
---[ end trace 3f0a8d3fa0ba549b ]---


I *suspect* that the RTC subsystem _might_ be related to my problem, 
because all those warning messages came up with at some point of 2.6.24 
first, but I cannot really state that they are the evil making my 
machine crash.

At this point, I am out of ideas and hope that some experienced person 
can help me.

Best regards,


Mihai
