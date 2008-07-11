Return-Path: <linux-kernel-owner+w=401wt.eu-S1756744AbYGKCIL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756744AbYGKCIL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 22:08:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753636AbYGKCH5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 22:07:57 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37733 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753054AbYGKCH4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 22:07:56 -0400
Date: Thu, 10 Jul 2008 19:02:06 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mihai Moldovan <ionic@ionic.de>
Cc: linux-kernel@vger.kernel.org, linux-fbdev-devel@lists.sourceforge.net
Subject: Re: PROBLEM: uvesafb broken as of Linux 2.6.24.x
Message-Id: <20080710190206.8908b80a.akpm@linux-foundation.org>
In-Reply-To: <48724FA9.6020306@ionic.de>
References: <48724FA9.6020306@ionic.de>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(cc linux-fbdev-devel)

On Mon, 07 Jul 2008 19:17:29 +0200 Mihai Moldovan <ionic@ionic.de> wrote:

> Hello,
> 
> I see a weird problem with uvesafb and any recent Kernel. It seems like 
> the problem was introduced in some higher 2.6.24 version. I have more 
> information regarding this, but I will first explain the problem(s) I 
> experience.
> 
> After booting a faulty Kernel, these messages appear in my Kernel log 
> ring buffer ("dmesg"):
> 
> 
> [  112.816609] uvesafb: mode switch failed (eax=0x2104, err=0). Trying 
> again with default timings.
> [  112.819540] uvesafb: mode switch failed (eax=0x2104, err=0)
> 
> Please note, that these messages are the first ones after having booted 
> the box. (Due to the init scripts, the VT was automatically switched to 
> VT7 where X resides, after that I switched back to VT1.)
> 
> Switching to other VT's does *not* reproduce the warning/error messages.
> 
> Now to the interesting part.
> 
> When starting any program that needs framebuffer support (which is why 
> we use uvesafb, isn't it?), there messages re-appear. I have tested 
> mplayer with -vo fbdev or fbdev2 for example, on VT2. Starting it, 
> playing a (video) file for some seconds and looking at dmesg again, 
> these are the results:
> 
> [  564.757398] uvesafb: mode switch failed (eax=0x338, err=0). Trying 
> again with default timings.
> [  564.758358] uvesafb: mode switch failed (eax=0x2104, err=0)
> [  564.838390] uvesafb: mode switch failed (eax=0x344, err=0). Trying 
> again with default timings.
> [  564.844749] uvesafb: mode switch failed (eax=0x2104, err=0)
> [  564.929364] uvesafb: mode switch failed (eax=0x104c, err=0). Trying 
> again with default timings.
> [  564.937509] uvesafb: mode switch failed (eax=0x2105, err=0)
> [  565.021358] uvesafb: mode switch failed (eax=0x42b, err=0). Trying 
> again with default timings.
> [  565.027047] uvesafb: mode switch failed (eax=0x2105, err=0)
> [  565.109331] uvesafb: mode switch failed (eax=0x32b, err=0). Trying 
> again with default timings.
> [  565.111679] uvesafb: mode switch failed (eax=0x2105, err=0)
> [  565.194323] uvesafb: mode switch failed (eax=0x2104, err=0). Trying 
> again with default timings.
> [  565.195379] uvesafb: mode switch failed (eax=0x2104, err=0)
> [  565.278306] uvesafb: mode switch failed (eax=0x2104, err=0). Trying 
> again with default timings.
> [  565.280417] uvesafb: mode switch failed (eax=0x2104, err=0)
> [  571.548365] uvesafb: mode switch failed (eax=0x2104, err=0). Trying 
> again with default timings.
> [  571.555713] uvesafb: mode switch failed (eax=0x10032b, err=0)
> 
> Additionally, the console does not work anymore and is totally 
> blank/black (and I did not even see a video. However, this last point is 
> not a "symptom" one can experience anytime, the video playback might or 
> might not work, it is indeed some sort of luck.)
> "Recovering" from this situation is a little bit complicated. I have 
> found following solutions:
> 
>   - Switch to the first VT (or any other, but it seems to be important, 
> that this VT has not been used in the means of framebuffer) and then to 
> the "old" VT again. Doing so you might get eventually any text again, 
> but again, it is a piece of luck. Especially on high CPU and IO load 
> this might not work and leave all your consoles blank. Also, you *must 
> not* move too quick from one console to another or the problem might not 
> disappear as well. However, I have spent several minutes doing this 
> method and it just... s*cks.
>   - Switch to the VT where X is running (this is working almost every 
> time, for details see below) and after that to your desired "old" VT. 
> This method has higher success chances than the other one, but depending 
> on the load of the box, you really might need several minutes to get any 
> text again.
>   - It happened now and then to me, that I was not able to switch back 
> to the X-VT or any other. The box was still running, no Kernel Panic or 
> Ooopses happened, but there was no way to get it back to work (on any 
> VT, including the one with Xorg.) Even restarting Xorg did not help 
> anymore and the last and only measure to take was rebooting the box.
> 
> Okay, that is the situation when using any framebuffer content.
> 
> But also without framebuffer usage, the "blank console" problem can hit 
> you and you have to do one of the steps listed above in order of being 
> able to use the box again graphically. (Not mentioning SSH and the like, 
> those work without any problems, of course.)
> 
> I cannot stress this too much, please keep in mind, that all the 
> problems aggravate on high load. I think this is important, you will now 
> see why.
> 
> 
> I have got a copy of Linus' Linux-git tree and ran the bisect routine. I 
> knew that the problem was introduced between 2.6.24.2 and 2.6.25, so I 
> build and tested like 13 different kernels in this range.
> Finally, I have been able to find the faulty patch... and was quite 
> astonished. This is git's result:
> 
> 8f4d37ec073c17e2d4aa8851df5837d798606d6f is first bad commit
> commit 8f4d37ec073c17e2d4aa8851df5837d798606d6f
> Author: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Date:   Fri Jan 25 21:08:29 2008 +0100
> 
>     sched: high-res preemption tick
> 
>     Use HR-timers (when available) to deliver an accurate preemption tick.
> 
>     The regular scheduler tick that runs at 1/HZ can be too coarse when nice
>     level are used. The fairness system will still keep the cpu 
> utilisation 'fair'
>     by then delaying the task that got an excessive amount of CPU time 
> but try to
>     minimize this by delivering preemption points spot-on.
> 
>     The average frequency of this extra interrupt is sched_latency / 
> nr_latency.
>     Which need not be higher than 1/HZ, its just that the distribution 
> within the
>     sched_latency period is important.
> 
>     Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
>     Signed-off-by: Ingo Molnar <mingo@elte.hu>
> 
> :040000 040000 ab225228500f7a19d5ad20ca12ca3fc8ff5f5ad1 
> f1742e1d225a72aecea9d6961ed989b5943d31d8 M      arch
> :040000 040000 25d85e4ef7a71b0cc76801a2526ebeb4dce180fe 
> ae61510186b4fad708ef0211ac169decba16d4e5 M      include
> :040000 040000 9247cec7dd506c648ac027c17e5a07145aa41b26 
> 950832cc1dc4d30923f593ecec883a06b45d62e9 M      kernel
> 
> Do you see, what I mean? Obviously it is no bug in uvesafb itself (at 
> least no uvesafb code has been changed, that is) but introduced by this 
> Preemption patch. This might explain the problems concentrating on high 
> load (but not only in this status, though.)
> 
> Now, to be honest, I am a little bit puzzled about whom to contact. It 
> might be a bug in uvesafb and I should have contacted Michal Januszewski 
> ("spock") directly, because he is the original writer of uvesafb. By the 
> way - he is not listed in the MAINTAINERS file - is this driver 
> currently not maintained by anyone?
> On the other hand, my problem has been introduced by this somewhat lower 
> level HR timer patch, so maybe Peter would have been the right person to 
> hit on.
> 
> I have decided to let you decide however. :P
> 
> 
> Here is some other information which could be useful:
> 
> [    0.292261] uvesafb: NVIDIA Corporation, NV34 Board - p164-2n , Chip 
> Rev   , OEM: NVIDIA, VBE v3.0
> [    0.301472] uvesafb: protected mode interface info at c000:e340
> [    0.301544] uvesafb: pmi: set display start = c00ce376, set palette = 
> c00ce3e0
> [    0.301641] uvesafb: pmi: ports = 3b4 3b5 3ba 3c0 3c1 3c4 3c5 3c6 3c7 
> 3c8 3c9 3cc 3ce 3cf 3d0 3d1 3d2 3d3 3d4 3d5 3da
> [    0.304337] uvesafb: VBIOS/hardware supports DDC2 transfers
> [    0.344795]       Display is GTF capable
> [    0.344895] uvesafb: monitor limits: vf = 200 Hz, hf = 132 kHz, clk = 
> 350 MHz
> [    0.345249] uvesafb: scrolling: ywrap using protected mode interface, 
> yres_virtual=4915
> [    0.744920] Switched to high resolution mode on CPU 0
> [    0.847204] Console: switching to colour frame buffer device 160x64
> [    0.893878] uvesafb: framebuffer at 0xd0000000, mapped to 0xf8880000, 
> using 24576k, total 262144k
> [    0.894386] fb0: VESA VGA frame buffer device
> 
> The first bad Kernel version I have in use is:
> 
> Linux version 2.6.24-OSS4-GIT-Regress-Test-g8f4d37ec-dirty (root@deff) 
> (gcc version 4.1.2 20070214 ( (gdc 0.24, using dmd 1.020)) (Gentoo 4.1.2 
> p1.0.2)) #2 PREEMPT Sat Jul 5 10:42:18 CEST 2008
> 
> I have applied a custom patch as well - BadRAM. But I think this ought 
> not interfere with uvesafb.
> 
> Relevant sections of my config file are:
> 
> CONFIG_PREEMPT_NOTIFIERS=y
> # CONFIG_PREEMPT_RCU is not set
> # CONFIG_PREEMPT_NONE is not set
> # CONFIG_PREEMPT_VOLUNTARY is not set
> CONFIG_PREEMPT=y
> CONFIG_PREEMPT_BKL=y
> # CONFIG_DEBUG_PREEMPT is not set
> CONFIG_FB_UVESA=y
> CONFIG_SCHED_HRTICK=y
> CONFIG_NO_HZ=y
> # CONFIG_HZ_100 is not set
> # CONFIG_HZ_250 is not set
> # CONFIG_HZ_300 is not set
> CONFIG_HZ_1000=y
> CONFIG_HZ=1000
> CONFIG_HIGH_RES_TIMERS=y
> 
> If you need any other information, please to *not* hesitate to ask. The 
> information I have provided now are only those I thought they could be 
> usable.
> 
> 
> Also, I want to ask any other uvesafb user to test this and confirm the 
> bug (if it can be confirmed, of course...)
> 
> I have also tested the newest RC kernel (2.6.26-rc9) which faces the 
> same problems.
> 
> 
> 
> I hope this was all correctly and I have not broken any rule or missed 
> anything.
> 
> 
> At the last thing, I want to personally thank Linus and all the other 
> Kernel Hackers for the so far good work. Keep going! :)
> 
> 
> Have a nice afternoon (in Europe),
> 
> 
> Best regards,
> 
> 
> 
> Mihai "Ionic" Moldovan
> 
> 
> 
> 
> 
> 
> P.S.: what is the status about BadRAM? Will it get into Mainline soon? 
> AFAIK it is pending since Feb 08 and I would really like to see it 
> included. :)

