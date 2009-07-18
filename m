Return-Path: <linux-kernel-owner+w=401wt.eu-S1752962AbZGRQKL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752962AbZGRQKL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jul 2009 12:10:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752462AbZGRQKJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Jul 2009 12:10:09 -0400
Received: from main.gmane.org ([80.91.229.2]:35671 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752279AbZGRQKH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jul 2009 12:10:07 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Piotr Kaczuba <piotr@attika.ath.cx>
Subject: [ALSA] emu10k1: hw_ptr skipping when unpausing mplayer
Date: Sat, 18 Jul 2009 16:07:07 +0000 (UTC)
Message-ID: <h3srvb$71b$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: 83.142.198.206
User-Agent: Pan/0.132 (Waxed in Black)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since 2.6.30 I'm experiencing sound and video stuttering when unpausing 
mplayer. The soundcard is an Audigy 1, driver is emu10k1. Kernel is 
x86_64, userspace is 32-bit. I doesn't happen always, but regularly 
enough.


Below is the ouput of mplayer:

[AO_ALSA] alsa-lib: pcm.c:6482:(snd_pcm_mmap_commit) commit offset (8886) 
doesn't match with appl_ptr (139955) % buf_size (16384)
[AO_ALSA] Write error: Broken pipe
[AO_ALSA] Trying to reset soundcard.
[AO_ALSA] alsa-lib: pcm_hw.c:578:(snd_pcm_hw_prepare) 
SNDRV_PCM_IOCTL_PREPARE failed: Device or resource busy
[AO_ALSA] alsa-lib: pcm_hw.c:578:(snd_pcm_hw_prepare) 
SNDRV_PCM_IOCTL_PREPARE failed: Device or resource busy
[AO_ALSA] alsa-lib: pcm_hw.c:578:(snd_pcm_hw_prepare) 
SNDRV_PCM_IOCTL_PREPARE failed: Device or resource busy
[AO_ALSA] pcm prepare error: Device or resource busy


After setting xrun_debug to 5 I get the following in the log:

PCM: hw_ptr skipping! [Q] (pos=3071, delta=17225, period=1024, 
jdelta=18/358/0)
Pid: 0, comm: swapper Not tainted 2.6.30.1-orbiter.x86-64.1 #1
Call Trace:
 <IRQ>  [<ffffffffa02d7c7f>] ? snd_pcm_period_elapsed+0x4df/0x520 
[snd_pcm]
 [<ffffffffa031f15f>] ? snd_emu10k1_interrupt+0x25f/0x550 [snd_emu10k1]
 [<ffffffff8023a9ba>] ? run_timer_softirq+0x1a/0x250
 [<ffffffff80268e99>] ? handle_IRQ_event+0x39/0xe0
 [<ffffffff8026ad19>] ? handle_fasteoi_irq+0x79/0x110
 [<ffffffff8020dd17>] ? handle_irq+0x17/0x20
 [<ffffffff8020d7c1>] ? do_IRQ+0x51/0xd0
 [<ffffffff8020bd13>] ? ret_from_intr+0x0/0x9
 <EOI>  [<ffffffff8021bea0>] ? lapic_next_event+0x0/0x20
 [<ffffffff802127aa>] ? default_idle+0x3a/0x40
 [<ffffffff8020a017>] ? cpu_idle+0x47/0xa0
 [<ffffffff805a5aba>] ? start_kernel+0x2c3/0x384
 [<ffffffff805a5373>] ? x86_64_start_kernel+0xe1/0xf2
PCM: hw_ptr skipping! (pos=5482, delta=3434, period=1024, jdelta=50/71)
Pid: 2870, comm: mplayer Not tainted 2.6.30.1-orbiter.x86-64.1 #1
Call Trace:
 [<ffffffffa02d6bd3>] ? snd_pcm_update_hw_ptr+0x1d3/0x220 [snd_pcm]
 [<ffffffffa02d211d>] ? snd_pcm_hwsync+0x9d/0xe0 [snd_pcm]
 [<ffffffffa02d54e3>] ? snd_pcm_ioctl_compat+0x753/0x980 [snd_pcm]
 [<ffffffff80209b36>] ? __switch_to+0x226/0x270
 [<ffffffff80475407>] ? thread_return+0x30/0x1f9
 [<ffffffff8024a032>] ? hrtimer_cancel+0x12/0x20
 [<ffffffff80476710>] ? do_nanosleep+0x30/0xb0
 [<ffffffff8024a0e0>] ? hrtimer_nanosleep+0xa0/0x130
 [<ffffffff802ddd8b>] ? compat_sys_ioctl+0x19b/0x3e0
 [<ffffffff8024d3bb>] ? getnstimeofday+0x5b/0xe0
 [<ffffffff80266b56>] ? audit_syscall_entry+0x166/0x190
 [<ffffffff80227266>] ? cstar_dispatch+0x7/0x26
PCM: hw_ptr skipping! [Q] (pos=7443, delta=5395, period=1024, 
jdelta=91/112/2)
Pid: 2870, comm: mplayer Not tainted 2.6.30.1-orbiter.x86-64.1 #1
Call Trace:
 <IRQ>  [<ffffffffa02d7c7f>] ? snd_pcm_period_elapsed+0x4df/0x520 
[snd_pcm]
 [<ffffffffa031f15f>] ? snd_emu10k1_interrupt+0x25f/0x550 [snd_emu10k1]
 [<ffffffff80268e99>] ? handle_IRQ_event+0x39/0xe0
 [<ffffffff8022cd9d>] ? try_to_wake_up+0x14d/0x160
 [<ffffffff8026ad19>] ? handle_fasteoi_irq+0x79/0x110
 [<ffffffff8020dd17>] ? handle_irq+0x17/0x20
 [<ffffffff8020d7c1>] ? do_IRQ+0x51/0xd0
 [<ffffffff8020bd13>] ? ret_from_intr+0x0/0x9
 [<ffffffff8021bea0>] ? lapic_next_event+0x0/0x20
 [<ffffffff802354bd>] ? __do_softirq+0x3d/0xf0
 [<ffffffff8020c2ea>] ? call_softirq+0x1a/0x30
 [<ffffffff8020dcbd>] ? do_softirq+0x2d/0x70
 [<ffffffff802352a5>] ? irq_exit+0x85/0xa0
 [<ffffffff8021c74e>] ? smp_apic_timer_interrupt+0x4e/0x80
 [<ffffffff8020be63>] ? apic_timer_interrupt+0x13/0x20
 <EOI>  [<ffffffffa02d20d9>] ? snd_pcm_hwsync+0x59/0xe0 [snd_pcm]
 [<ffffffffa02d211d>] ? snd_pcm_hwsync+0x9d/0xe0 [snd_pcm]
 [<ffffffffa02d54e3>] ? snd_pcm_ioctl_compat+0x753/0x980 [snd_pcm]
 [<ffffffff80209b36>] ? __switch_to+0x226/0x270
 [<ffffffff80475407>] ? thread_return+0x30/0x1f9
 [<ffffffff8024a032>] ? hrtimer_cancel+0x12/0x20
 [<ffffffff80476710>] ? do_nanosleep+0x30/0xb0
 [<ffffffff8024a0e0>] ? hrtimer_nanosleep+0xa0/0x130
 [<ffffffff802ddd8b>] ? compat_sys_ioctl+0x19b/0x3e0
 [<ffffffff8024d3bb>] ? getnstimeofday+0x5b/0xe0
 [<ffffffff80266b56>] ? audit_syscall_entry+0x166/0x190
 [<ffffffff80227266>] ? cstar_dispatch+0x7/0x26

The log is virtually flooded with these messages until I interrupt 
mplayer.

I'd be graceful for any help.

Greetings,
Piotr

