Return-Path: <linux-kernel-owner+w=401wt.eu-S933236AbZHVF7k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933236AbZHVF7k (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Aug 2009 01:59:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933166AbZHVF7k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Aug 2009 01:59:40 -0400
Received: from isilmar.linta.de ([213.133.102.198]:38781 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933162AbZHVF7j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Aug 2009 01:59:39 -0400
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Sat, 22 Aug 2009 01:59:38 EDT
Date: Sat, 22 Aug 2009 07:48:31 +0200
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: linux-kernel@vger.kernel.org
Subject: oops: sysfs_remove_link, i915 and 2.6.31-rc7
Message-ID: <20090822054831.GA5627@comet.dominikbrodowski.net>
Mail-Followup-To: Dominik Brodowski <linux@dominikbrodowski.net>,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey all,

First stopping gdm/xdm and then issuing "rmmod i915" in quite short order
causes the following oops on 2.6.31-rc7:

[    0.000000] Linux version 2.6.31-rc7 (brodo@comet) (gcc version 4.3.3 (Ubuntu 4.3.3-5ubuntu4) ) #63 SMP PREEMPT Sat Aug 22 07:25:01 CEST 2009
...
[  100.373751] pci 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[  100.373757] pci 0000:00:02.0: setting latency timer to 64
[  100.387797] pci 0000:00:02.0: irq 28 for MSI/MSI-X
[  100.389969] input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A08:00/device:08/input/input9
[  100.390047] ACPI: Video Device [GFX0] (multi-head: yes  rom: no  post: no)
...
[  165.045883] mtrr: MTRR 4 not used
[  165.046035] BUG: unable to handle kernel NULL pointer dereference at 00000000000000b8
[  165.047009] IP: [<ffffffff81149e93>] sysfs_remove_link+0x13/0x20
[  165.047009] PGD 968f0067 PUD 87cc7067 PMD 0 
[  165.047009] Oops: 0000 [#1] PREEMPT SMP 
[  165.047009] last sysfs file: /sys/devices/pci0000:00/0000:00:1c.0/0000:02:00.0/ieee80211/phy0/rfkill0/state
[  165.047009] CPU 0 
[  165.047009] Modules linked in: af_packet i915(-) drm video output binfmt_misc rfcomm bnep sco l2cap cpufreq_powersave cpufreq_stats cpufreq_conservative cpufreq_userspace xt_tcpudp nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack ipt_LOG iptable_filter ip_tables x_tables coretemp sbp2 snd_hda_codec_realtek snd_hda_intel snd_hda_codec pcmcia snd_hwdep btusb snd_pcm bluetooth uvcvideo yenta_socket rsrc_nonstatic snd_timer iwl3945 ohci1394 snd pcspkr uhci_hcd iwlcore videodev v4l2_compat_ioctl32 ieee1394 pcmcia_core sg evdev snd_page_alloc joydev
[  165.107078] Pid: 5204, comm: rmmod Not tainted 2.6.31-rc7 #63 SQ45S70S
[  165.107078] RIP: 0010:[<ffffffff81149e93>]  [<ffffffff81149e93>] sysfs_remove_link+0x13/0x20
[  165.107078] RSP: 0018:ffff8800885e9cc8  EFLAGS: 00010206
[  165.107078] RAX: 0000000000000088 RBX: ffff880090441180 RCX: ffffffff814e73ed
[  165.107078] RDX: 0000000000000002 RSI: ffffffffa02a1030 RDI: ffffffff81702540
[  165.107078] RBP: ffff8800885e9cc8 R08: 0000000000000000 R09: ffffffff814fd048
[  165.107078] R10: 0000000000000000 R11: 0000000000000004 R12: ffff88009e071de0
[  165.107078] R13: ffff88009e071de0 R14: ffff88009f0f3000 R15: ffff88009e071e40
[  165.107078] FS:  00007f1ea39966f0(0000) GS:ffff880001879000(0000) knlGS:0000000000000000
[  165.107078] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  165.107078] CR2: 00000000000000b8 CR3: 00000000924fc000 CR4: 00000000000026f0
[  165.107078] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  165.107078] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  165.107078] Process rmmod (pid: 5204, threadinfo ffff8800885e8000, task ffff88009cddd840)
[  165.107078] Stack:
[  165.107078]  ffff8800885e9d18 ffffffffa029e788 ffff8800885e9d18 ffff88009d0202b0
[  165.107078] <0> ffff88009d0202a0 ffff88009d020280 ffff88009f0f2800 ffff88009f0f2800
[  165.107078] <0> ffffffffa02a3560 0000000000000002 ffff8800885e9d38 ffffffffa029e8a2
[  165.107078] Call Trace:
[  165.107078]  [<ffffffffa029e788>] acpi_video_bus_put_devices+0x10d/0x1f5 [video]
[  165.107078]  [<ffffffffa029e8a2>] acpi_video_bus_remove+0x32/0x62 [video]
[  165.107078]  [<ffffffff812ddb88>] acpi_device_remove+0xbe/0xe3
[  165.107078]  [<ffffffff813435a0>] __device_release_driver+0x70/0xe0
[  165.107078]  [<ffffffff813436c8>] driver_detach+0xb8/0xc0
[  165.107078]  [<ffffffff813425b2>] bus_remove_driver+0xa2/0x110
[  165.107078]  [<ffffffff81343e58>] driver_unregister+0x58/0x90
[  165.107078]  [<ffffffff812df426>] acpi_bus_unregister_driver+0x10/0x12
[  165.107078]  [<ffffffffa029e048>] acpi_video_unregister+0x19/0x38 [video]
[  165.107078]  [<ffffffffa02fd2c5>] intel_opregion_free+0x95/0xa0 [i915]
[  165.107078]  [<ffffffffa02d7e32>] i915_driver_unload+0xb2/0x150 [i915]
[  165.107078]  [<ffffffffa02af048>] drm_put_dev+0x78/0x200 [drm]
[  165.107078]  [<ffffffffa02aaa78>] drm_exit+0x58/0x90 [drm]
[  165.107078]  [<ffffffffa02fdd1c>] i915_exit+0x10/0x12 [i915]
[  165.107078]  [<ffffffff810a2b90>] sys_delete_module+0x1e0/0x2b0
[  165.107078]  [<ffffffff81090719>] ? up_write+0x9/0x10
[  165.107078]  [<ffffffff8102ecc2>] system_call_fastpath+0x16/0x1b
[  165.107078] Code: 39 00 48 8b 55 d0 e9 8f fe ff ff 4d 39 e7 75 a9 eb e4 66 0f 1f 44 00 00 48 89 f8 55 48 c7 c7 40 25 70 81 48 85 c0 48 89 e5 74 04 <48> 8b 78 30 e8 b4 d5 ff ff c9 c3 66 90 55 48 89 e5 41 57 41 89 
[  165.107078] RIP  [<ffffffff81149e93>] sysfs_remove_link+0x13/0x20
[  165.107078]  RSP <ffff8800885e9cc8>
[  165.107078] CR2: 00000000000000b8
[  165.110682] ---[ end trace afef04e49a02420b ]---

Best,
	Dominik
