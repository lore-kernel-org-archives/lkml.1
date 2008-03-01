Return-Path: <linux-kernel-owner+w=401wt.eu-S1761666AbYCAOLS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761666AbYCAOLS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2008 09:11:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756455AbYCAOLJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Mar 2008 09:11:09 -0500
Received: from mail001.aei.ca ([206.123.6.130]:54185 "EHLO mail001.aei.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755760AbYCAOLI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2008 09:11:08 -0500
/m: spam: 3.2.1
From: Ed Tomlinson <edt@aei.ca>
To: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Panic 2.6.24-3 NMI Watchdog detected LOCKUP on CPU 0
Date: Sat, 1 Mar 2008 09:11:04 -0500
User-Agent: KMail/1.9.7
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803010911.04569.edt@aei.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have been seeing these since I installed .24 kernels.  It does not seem to matter if I change the clocksource from tsc
to apci_pm.  Its happened with all .24 kernels I have tried starting with stock 2.6.24 upto 2.6.24-gentoo-r2 + 2.6.24-3

Ideas?
Ed Tomlinson

(2.6.24-gentoo-r2-crc)
grover login: [   71.811823] NMI Watchdog detected LOCKUP on CPU 0
[   71.830323] CPU 0 
[   71.840764] Modules linked in: ipv6 af_packet rfcomm l2cap snd_pcm_oss snd_mixer_oss snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device xfs hci_usb bluetooth usbhid pl2303 usbserial usbmouse ohci_hcd ehci_hcd video1394 w83627hf hwmon_vid i2c_nforce2 forcedeth sr_mod cdrom sbp2 ohci1394 ieee1394 radeonfb fb_ddc i2c_algo_bit i2c_core snd_intel8x0 snd_ac97_codec ac97_bus snd_pcm snd_timer snd soundcore snd_page_alloc thermal processor parport_pc parport button pcspkr evdev floppy k8temp hwmon rtc psmouse unix
[   72.005597] Pid: 0, comm: swapper Not tainted 2.6.24-gentoo-r2-crc #1
[   72.029826] RIP: 0010:[<ffffffff80248af8>]  [<ffffffff80248af8>] getnstimeofday+0x28/0x90
[   72.059351] RSP: 0018:ffffffff805f7e08  EFLAGS: 00000086
[   72.080224] RAX: 0000000014dde7a1 RBX: 000000000001210a RCX: 0000000000000001
[   72.106591] RDX: ffffffff805b66b0 RSI: 0000000000000001 RDI: ffffffff805f7e48
[   72.132920] RBP: ffffffff805f7e18 R08: 00000000fffc3831 R09: 0000000000000000
[   72.159227] R10: 0000000000000001 R11: 0000000000000001 R12: ffffffff805f7e48
[   72.185560] R13: ffffffff80635b20 R14: 0000000000000000 R15: 0000000000000000
[   72.211913] FS:  00002ae6fd4ad6f0(0000) GS:ffffffff805ed000(0000) knlGS:0000000000000000
[   72.241235] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
[   72.263499] CR2: 00002ac4e8a8dc30 CR3: 000000004a804000 CR4: 00000000000006e0
[   72.290045] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   72.316538] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   72.342966] Process swapper (pid: 0, threadinfo ffffffff805f6000, task ffffffff805ac360)
[   72.372281] Stack:  000000000001210a ffffffff805f7e48 ffffffff805f7e38 ffffffff8024667e
[   72.401579]  0000000000000001 0000000cda5b82ba ffffffff805f7e58 ffffffff802466d1
[   72.429030]  0000000047c3769a 0000000c2fb50500 ffffffff805f7e88 ffffffff8024c15e
[   72.450943] Call Trace:
[   72.468674]  [<ffffffff8024667e>] ktime_get_ts+0x1e/0x60
[   72.489640]  [<ffffffff802466d1>] ktime_get+0x11/0x50
[   72.509763]  [<ffffffff8024c15e>] tick_program_event+0x1e/0x60
[   72.532221]  [<ffffffff80245add>] hrtimer_force_reprogram+0x6d/0x90
[   72.555978]  [<ffffffff80245b98>] __remove_hrtimer+0x98/0xa0
[   72.577839]  [<ffffffff80246442>] hrtimer_start+0xd2/0x110
[   72.599091]  [<ffffffff8024c975>] tick_nohz_stop_sched_tick+0x205/0x2b0
[   72.623781]  [<ffffffff8020a7e0>] poll_idle+0x0/0x10
[   72.643528]  [<ffffffff8020a8aa>] cpu_idle+0x2a/0x90
[   72.663258]  [<ffffffff8047e889>] rest_init+0x69/0x70
[   72.683201]  [<ffffffff805f9aaa>] start_kernel+0x25a/0x2a0
[   72.704447]  [<ffffffff805f9107>] _sinittext+0x107/0x110
[   72.725113] 
[   72.734259] 
[   72.734260] Code: 49 89 44 24 08 48 8b 05 2c 60 40 00 ff 50 20 48 89 c6 48 8b 
[   72.770670] ---[ end trace 8ada33f8e18f93e2 ]---
[   72.789212] Kernel panic - not syncing: Attempted to kill the idle task!

(2.6.24-gentoo-r2-crc)
[  116.784632] NMI Watchdog detected LOCKUP on CPU 0
[  116.803081] CPU 0 
[  116.813458] Modules linked in: ipv6 af_packet rfcomm l2cap snd_pcm_oss snd_mixer_oss snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device xfs hci_usb bluetooth usbhid pl2303 usbserial usbmouse ohci_hcd ehci_hcd video1394 w83627hf hwmon_vid i2c_nforce2 forcedeth sr_mod cdrom sbp2 ohci1394 ieee1394 radeonfb fb_ddc i2c_algo_bit i2c_core snd_intel8x0 snd_ac97_codec ac97_bus snd_pcm snd_timer snd thermal soundcore snd_page_alloc processor button parport_pc parport evdev floppy rtc psmouse pcspkr k8temp hwmon unix
[  116.977866] Pid: 0, comm: swapper Not tainted 2.6.24-gentoo-r2-crc #1
[  117.002012] RIP: 0010:[<ffffffff80236d40>]  [<ffffffff80236d40>] get_next_timer_interrupt+0x50/0x230
[  117.034375] RSP: 0018:ffffffff805f7ea8  EFLAGS: 00000012
[  117.055165] RAX: 0000000000000610 RBX: 00000000fffce460 RCX: ffffffff8064c8e0
[  117.081499] RDX: ffffffff8064c8e0 RSI: 0000000000000061 RDI: 0000000000000046
[  117.107854] RBP: ffffffff805f7f08 R08: 00000000fffce446 R09: 0000000000000000
[  117.134188] R10: 0000000000000001 R11: 0000000000000001 R12: ffffffff8064c2c0
[  117.160595] R13: 00000000fffce460 R14: 000000166d9ef978 R15: 0000000000000296
[  117.186971] FS:  00002b7bbc0c26f0(0000) GS:ffffffff805ed000(0000) knlGS:0000000000000000
[  117.216303] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
[  117.238595] CR2: 00002aac88684c30 CR3: 0000000027e0d000 CR4: 00000000000006e0
[  117.265074] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  117.291493] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  117.317832] Process swapper (pid: 0, threadinfo ffffffff805f6000, task ffffffff805ac360)
[  117.347102] Stack:  ffffffff805f7ec8 ffffffff80248b07 0000000000021538 ffffffff805f7ef8
[  117.376328]  ffffffff805f7ee8 ffffffff802466ac ffffffff8020a7e0 00000000fffce460
[  117.403674]  000000166d1e9000 0000000000000000 000000166d9ef978 0000000000000296
[  117.425583] Call Trace:
[  117.443477]  [<ffffffff80248b07>] getnstimeofday+0x37/0x90
[  117.465007]  [<ffffffff802466ac>] ktime_get_ts+0x4c/0x60
[  117.485982]  [<ffffffff8020a7e0>] poll_idle+0x0/0x10
[  117.505840]  [<ffffffff8024c82b>] tick_nohz_stop_sched_tick+0xbb/0x2b0
[  117.530342]  [<ffffffff8020a7e0>] poll_idle+0x0/0x10
[  117.550166]  [<ffffffff8020a8aa>] cpu_idle+0x2a/0x90
[  117.569956]  [<ffffffff8047e889>] rest_init+0x69/0x70
[  117.590040]  [<ffffffff805f9aaa>] start_kernel+0x25a/0x2a0
[  117.611377]  [<ffffffff805f9107>] _sinittext+0x107/0x110
[  117.632167] 
[  117.641427] 
[  117.641428] Code: 48 8b 02 48 39 ca 0f 18 08 75 e8 8d 46 01 0f b6 f0 39 f7 75 
[  117.678059] ---[ end trace ea33ddd4bd145a0c ]---
[  117.697024] eth0: no IPv6 routers present
[  117.713916] Kernel panic - not syncing: Attempted to kill the idle task!

(2.6.24-gentoo-1-crc)
[  120.685097] NMI Watchdog detected LOCKUP on CPU 0
[  120.703598] CPU 0 
[  120.714011] Modules linked in: ipv6 af_packet rfcomm l2cap snd_pcm_oss snd_mixer_oss snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device xfs hci_usb bluetooth usbhid pl2303 usbserial usbmouse ohci_hcd ehci_hcd video1394 w83627hf hwmon_vid i2c_nforce2 forcedeth sr_mod cdrom sbp2 radeonfb fb_ddc i2c_algo_bit i2c_core ohci1394 ieee1394 floppy parport_pc parport evdev psmouse rtc k8temp hwmon pcspkr thermal snd_intel8x0 snd_ac97_codec ac97_bus processor button snd_pcm snd_timer snd soundcore snd_page_alloc unix
[  120.878815] Pid: 0, comm: swapper Not tainted 2.6.24-gentoo-1-crc #3
[  120.902782] RIP: 0010:[<ffffffff80212543>]  [<ffffffff80212543>] read_tsc+0x23/0x40
[  120.930734] RSP: 0018:ffffffff805f7df0  EFLAGS: 00000046
[  120.951582] RAX: 0000000000000f4a RBX: 0000000000000800 RCX: 0000000000000000
[  120.977921] RDX: 00000000078bfbff RSI: 0000000000000000 RDI: ffffffff805f7e48
[  121.004200] RBP: ffffffff805f7df8 R08: 00000000fffef910 R09: 0000000000000008
[  121.030476] R10: 0000000000000000 R11: 0000000000000001 R12: ffffffff805f7e48
[  121.056784] R13: ffffffff80635b20 R14: 0000000000000000 R15: 0000000000000000
[  121.083084] FS:  00002ac53e0d06f0(0000) GS:ffffffff805ed000(0000) knlGS:0000000000000000
[  121.112372] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
[  121.134613] CR2: 0000555555612bc0 CR3: 000000004f976000 CR4: 00000000000006e0
[  121.161110] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  121.187573] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  121.213979] Process swapper (pid: 0, threadinfo ffffffff805f6000, task ffffffff805ac360)
[  121.243267] Stack:  0000000000015e22 ffffffff805f7e18 ffffffff802493a7 0000000000015e22
[  121.272528]  ffffffff805f7e48 ffffffff805f7e38 ffffffff80246f1e 0000000000000001
[  121.299950]  0000001237354ad6 ffffffff805f7e58 ffffffff80246f71 0000000047af8d6a
[  121.321860] Call Trace:
[  121.339555]  [<ffffffff802493a7>] getnstimeofday+0x37/0x90
[  121.361018]  [<ffffffff80246f1e>] ktime_get_ts+0x1e/0x60
[  121.381943]  [<ffffffff80246f71>] ktime_get+0x11/0x50
[  121.402039]  [<ffffffff8024c9fe>] tick_program_event+0x1e/0x60
[  121.424481]  [<ffffffff8024637d>] hrtimer_force_reprogram+0x6d/0x90
[  121.448174]  [<ffffffff80246438>] __remove_hrtimer+0x98/0xa0
[  121.469950]  [<ffffffff80246ce2>] hrtimer_start+0xd2/0x110
[  121.491212]  [<ffffffff8024d215>] tick_nohz_stop_sched_tick+0x205/0x2b0
[  121.515898]  [<ffffffff8020a7c0>] poll_idle+0x0/0x10
[  121.535638]  [<ffffffff8020a88a>] cpu_idle+0x2a/0x90
[  121.555336]  [<ffffffff8047f049>] rest_init+0x69/0x70
[  121.575242]  [<ffffffff805f9aaa>] start_kernel+0x25a/0x2a0
[  121.596420]  [<ffffffff805f9107>] _sinittext+0x107/0x110
[  121.617052] 
[  121.626185] 
[  121.626186] Code: 0f 31 89 c0 48 c1 e2 20 48 09 d0 5b c9 c3 90 90 90 90 90 90 
[  121.662535] ---[ end trace 5b19a10a623f08de ]---
[  121.681038] Kernel panic - not syncing: Attempted to kill the idle task!

I have more trackbacks if they will help.
