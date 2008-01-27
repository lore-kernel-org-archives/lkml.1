Return-Path: <linux-kernel-owner+w=401wt.eu-S1755904AbYA0RoL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755904AbYA0RoL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 12:44:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751831AbYA0Rn5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 12:43:57 -0500
Received: from mail001.aei.ca ([206.123.6.130]:36575 "EHLO mail001.aei.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750936AbYA0Rn4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 12:43:56 -0500
From: Ed Tomlinson <edt@aei.ca>
To: linux-kernel@vger.kernel.org
Subject: 2.6.24 Panic
Date: Sun, 27 Jan 2008 12:58:43 -0500
User-Agent: KMail/1.9.7
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801271258.43430.edt@aei.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here is a trace back:

This is grover.unknown_domain (Linux x86_64 2.6.24-gentoo-crc) 12:47:13

Booted with: 
kernel /boot/2.6.24-gentoo-crc root=/dev/sda3 vga=0x318 video=vesafb:ywrap,mtrr:3 console=tty0 console=ttyS0,38400 nmi_watchdog=2 idle=poll

grover login: [   75.987618] NMI Watchdog detected LOCKUP on CPU 0
[   76.006096] CPU 0
[   76.016515] Modules linked in: ipv6 af_packet rfcomm l2cap bluetooth snd_pcm_oss snd_mixer_oss snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device xfs usbhid pl2303 usbserial usbmouse ohci_hcd ehci_hcd video1394 w83627hf hwmon_vid i2c_nforce2 forcedeth sr_mod cdrom sbp2 parport_pc parport floppy rtc evdev ohci1394 radeonfb ieee1394 fb_ddc i2c_algo_bit i2c_core snd_intel8x0 snd_ac97_codec ac97_bus snd_pcm thermal processor button snd_timer snd soundcore snd_page_alloc psmouse k8temp hwmon pcspkr unix
[   76.179223] Pid: 0, comm: swapper Not tainted 2.6.24-gentoo-crc #1
[   76.202663] RIP: 0010:[<ffffffff802462c0>]  [<ffffffff802462c0>] hrtimer_reprogram+0x0/0x50
[   76.232721] RSP: 0018:ffffffff805f7e90  EFLAGS: 00000002
[   76.253592] RAX: ffffffff805b6760 RBX: ffff81004efc5e98 RCX: 0000000000000001
[   76.279968] RDX: 0000000000000001 RSI: ffffffff805b67b0 RDI: ffffffff8064ee80
[   76.306300] RBP: ffffffff805f7ec8 R08: 00000000ffffffff R09: 0000000000000000
[   76.332666] R10: 0000000000000001 R11: 0000000000000001 R12: ffffffff8064ee80
[   76.359053] R13: ffff81004efc5e88 R14: ffffffff805b67b0 R15: ffffffff805b67c0
[   76.385438] FS:  00002b69384386f0(0000) GS:ffffffff805ed000(0000) knlGS:0000000000000000
[   76.414815] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
[   76.437133] CR2: 00002abdf10a8370 CR3: 000000004f9dd000 CR4: 00000000000006e0
[   76.463733] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   76.490267] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   76.516749] Process swapper (pid: 0, threadinfo ffffffff805f6000, task ffffffff805ac360)
[   76.546119] Stack:  ffffffff802464e7 ffffffff805f7ec8 ffffffff8064ee80 ffffffff805b67b0
[   76.575463]  0000000000000086 0000000c83273e02 00000000ffffffff ffffffff805f7f08
[   76.602941]  ffffffff80246c85 000000018020a7c0 00000000fffedf4c 0000000c7d315d0c
[   76.624835] Call Trace:
[   76.642724]  [<ffffffff802464e7>] enqueue_hrtimer+0xa7/0x110
[   76.664832]  [<ffffffff80246c85>] hrtimer_start+0x75/0x110
[   76.686378]  [<ffffffff8024d215>] tick_nohz_stop_sched_tick+0x205/0x2b0
[   76.711324]  [<ffffffff8020a7c0>] poll_idle+0x0/0x10
[   76.731313]  [<ffffffff8020a88a>] cpu_idle+0x2a/0x90
[   76.751204]  [<ffffffff8047ef79>] rest_init+0x69/0x70
[   76.771262]  [<ffffffff805f9aaa>] start_kernel+0x25a/0x2a0
[   76.792637]  [<ffffffff805f9107>] _sinittext+0x107/0x110
[   76.813478]
[   76.822851]
[   76.822851] Code: 55 48 89 e5 53 48 83 ec 08 48 8b 5f 18 48 2b 5e 40 f6 47 30
[   76.859658] ---[ end trace bbed4a3078ba58f5 ]---
[   76.878661] Kernel panic - not syncing: Attempted to kill the idle task!

If this is timer related, the kernel uses 'tsc' as a the clocksource 'acpi_pm' is also available.

What else will help track this down to fix it?

TIA,
Ed Tomlinson
