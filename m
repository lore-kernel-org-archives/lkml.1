Return-Path: <linux-kernel-owner+w=401wt.eu-S1754899AbYIMMch@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754899AbYIMMch (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Sep 2008 08:32:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752487AbYIMMc0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Sep 2008 08:32:26 -0400
Received: from hobbit.corpit.ru ([81.13.33.150]:22033 "EHLO hobbit.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752498AbYIMMcZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Sep 2008 08:32:25 -0400
X-Greylist: delayed 640 seconds by postgrey-1.27 at vger.kernel.org; Sat, 13 Sep 2008 08:32:25 EDT
Subject: Stable regression: usb-storage is stuck in 2.6.26.5
From: Michael Tokarev <mjt@tls.msk.ru>
To: <linux-kernel@vger.kernel.org>
Message-Id: <20080913122143.4B13B908E@gandalf.tls.msk.ru>
Date: Sat, 13 Sep 2008 16:16:02 +0400 (MSD)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just updated my machine from 2.6.26.1 to 2.6.26.5, and it does not
wan to boot anymore.  It says "Initializing USB Mass Storage driver.."
(when trying to load usb-storage module) and sits here forever, every
2 minutes showing warnings about stuck processes (traces below).
With 2.6.26.1 or any previous version I never experienced this
problem.  Both 32- and 64-bits kernels behave the same way.
While waiting for usb-storage to complete, no other USB devices
works (incl. mouse and keyboard).

The machine is an AMD X2-64 (BE-2400) processor with an nVidia MCP51
chipset (lspci is below).  Motherboard is Asus M2NPV-VM, latest BIOS
(1401, dated 08/07/2008)

I'm rebuilding 2.6.26.3 for now -- trying to bisect the issue...

Thanks.

/mjt

Example of dmesg output:

Sep 13 16:04:51 gandalf kernel: INFO: task insmod:2662 blocked for more than 120 seconds.
Sep 13 16:04:51 gandalf kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Sep 13 16:04:51 gandalf kernel: insmod        D c01d7662     0  2662   2580
Sep 13 16:04:51 gandalf kernel:        f7241340 00000082 00000000 c01d7662 00000000 f7228d38 c03dddac f7c0b6c0 
Sep 13 16:04:51 gandalf kernel:        00000001 f7f07dc0 c0399080 f7fe4584 00000008 00001f00 f77925d0 f7792734 
Sep 13 16:04:51 gandalf kernel:        00000001 f7228d70 c03dddac f7792734 c205e7ac c01c24e0 c205e7ac f7c28000 
Sep 13 16:04:51 gandalf kernel: Call Trace:
Sep 13 16:04:51 gandalf kernel:  [<c01d7662>] idr_get_empty_slot+0xe2/0x260
Sep 13 16:04:51 gandalf kernel:  [<c01c24e0>] sysfs_ilookup_test+0x0/0x10
Sep 13 16:04:51 gandalf kernel:  [<c02c642d>] schedule_timeout+0x7d/0xb0
Sep 13 16:04:51 gandalf kernel:  [<c01c27b1>] sysfs_find_dirent+0x21/0x30
Sep 13 16:04:51 gandalf kernel:  [<c02c6da5>] __down+0x55/0x90
Sep 13 16:04:51 gandalf kernel:  [<c0140b2a>] down+0x3a/0x40
Sep 13 16:04:51 gandalf kernel:  [<c0233863>] __driver_attach+0x23/0x80
Sep 13 16:04:51 gandalf kernel:  [<c0233064>] bus_for_each_dev+0x44/0x70
Sep 13 16:04:51 gandalf kernel:  [<c02335b6>] driver_attach+0x16/0x20
Sep 13 16:04:51 gandalf kernel:  [<c0233840>] __driver_attach+0x0/0x80
Sep 13 16:04:51 gandalf kernel:  [<c0232a27>] bus_add_driver+0x1a7/0x220
Sep 13 16:04:51 gandalf kernel:  [<c0233a4c>] driver_register+0x5c/0x130
Sep 13 16:04:51 gandalf kernel:  [<f8896961>] usb_register_driver+0x81/0x100 [usbcore]
Sep 13 16:04:51 gandalf kernel:  [<f8b88024>] usb_stor_init+0x24/0x3f [usb_storage]
Sep 13 16:04:51 gandalf kernel:  [<c014be88>] sys_init_module+0x148/0x1bb0
Sep 13 16:04:51 gandalf kernel:  [<c01032f3>] sysenter_past_esp+0x78/0xb1
Sep 13 16:04:51 gandalf kernel:  =======================
Sep 13 16:05:16 gandalf kernel: INFO: task khubd:371 blocked for more than 120 seconds.
Sep 13 16:05:16 gandalf kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Sep 13 16:05:16 gandalf kernel: khubd         D f7fbbd10     0   371      2
Sep 13 16:05:16 gandalf kernel:        f7d2ce00 00000046 00000002 f7fbbd10 f7fbbd18 00000000 c01322f7 f7fbbd04 
Sep 13 16:05:16 gandalf kernel:        ffffffff 00000000 c0399080 f7fbbd18 f7fbbd14 f7fbbd10 f7d2a5d0 f7d2a734 
Sep 13 16:05:16 gandalf kernel:        00000000 ffff8dd5 00000000 f7d2a734 f7c5ec00 fffffffe 00000000 00000000 
Sep 13 16:05:16 gandalf kernel: Call Trace:
Sep 13 16:05:16 gandalf kernel:  [<c01322f7>] lock_timer_base+0x27/0x60
Sep 13 16:05:16 gandalf kernel:  [<f889393d>] usb_kill_urb+0x7d/0xc0 [usbcore]
Sep 13 16:05:16 gandalf kernel:  [<c013c4a0>] autoremove_wake_function+0x0/0x50
Sep 13 16:05:16 gandalf kernel:  [<f88949d3>] usb_start_wait_urb+0xa3/0xc0 [usbcore]
Sep 13 16:05:16 gandalf kernel:  [<f8894c10>] usb_control_msg+0xd0/0x100 [usbcore]
Sep 13 16:05:16 gandalf kernel:  [<f8895be2>] usb_get_descriptor+0xb2/0xe0 [usbcore]
Sep 13 16:05:16 gandalf kernel:  [<c0131ef0>] process_timeout+0x0/0x10
Sep 13 16:05:16 gandalf kernel:  [<f8896dd3>] usb_get_configuration+0xe3/0x1300 [usbcore]
Sep 13 16:05:16 gandalf kernel:  [<c01d8f5a>] kref_put+0x2a/0x60
Sep 13 16:05:16 gandalf kernel:  [<f88949a1>] usb_start_wait_urb+0x71/0xc0 [usbcore]
Sep 13 16:05:16 gandalf kernel:  [<f8895be2>] usb_get_descriptor+0xb2/0xe0 [usbcore]
Sep 13 16:05:16 gandalf kernel:  [<c0132391>] del_timer_sync+0x11/0x20
Sep 13 16:05:16 gandalf kernel:  [<f8895cac>] usb_get_device_descriptor+0x9c/0xa0 [usbcore]
Sep 13 16:05:16 gandalf kernel:  [<f888ecf7>] hub_port_init+0xa7/0x730 [usbcore]
Sep 13 16:05:16 gandalf kernel:  [<f888fab5>] usb_configure_device+0xc5/0x100 [usbcore]
Sep 13 16:05:16 gandalf kernel:  [<f889cd51>] usb_detect_quirks+0x41/0x60 [usbcore]
Sep 13 16:05:16 gandalf kernel:  [<f888fc81>] usb_new_device+0x21/0x180 [usbcore]
Sep 13 16:05:16 gandalf kernel:  [<f8890a97>] hub_thread+0x3e7/0x1090 [usbcore]
Sep 13 16:05:16 gandalf kernel:  [<c013c4a0>] autoremove_wake_function+0x0/0x50
Sep 13 16:05:16 gandalf kernel:  [<f88906b0>] hub_thread+0x0/0x1090 [usbcore]
Sep 13 16:05:16 gandalf kernel:  [<c013c1b9>] kthread+0x39/0x70
Sep 13 16:05:16 gandalf kernel:  [<c013c180>] kthread+0x0/0x70
Sep 13 16:05:16 gandalf kernel:  [<c0103f93>] kernel_thread_helper+0x7/0x14
Sep 13 16:05:16 gandalf kernel:  =======================

lspci:
00:00.0 RAM memory: nVidia Corporation C51 Host Bridge (rev a2)
00:00.1 RAM memory: nVidia Corporation C51 Memory Controller 0 (rev a2)
00:00.2 RAM memory: nVidia Corporation C51 Memory Controller 1 (rev a2)
00:00.3 RAM memory: nVidia Corporation C51 Memory Controller 5 (rev a2)
00:00.4 RAM memory: nVidia Corporation C51 Memory Controller 4 (rev a2)
00:00.5 RAM memory: nVidia Corporation C51 Host Bridge (rev a2)
00:00.6 RAM memory: nVidia Corporation C51 Memory Controller 3 (rev a2)
00:00.7 RAM memory: nVidia Corporation C51 Memory Controller 2 (rev a2)
00:05.0 VGA compatible controller: nVidia Corporation C51PV [GeForce 6150] (rev a2)
00:09.0 RAM memory: nVidia Corporation MCP51 Host Bridge (rev a2)
00:0a.0 ISA bridge: nVidia Corporation MCP51 LPC Bridge (rev a2)
00:0a.1 SMBus: nVidia Corporation MCP51 SMBus (rev a2)
00:0a.2 RAM memory: nVidia Corporation MCP51 Memory Controller 0 (rev a2)
00:0b.0 USB Controller: nVidia Corporation MCP51 USB Controller (rev a2)
00:0b.1 USB Controller: nVidia Corporation MCP51 USB Controller (rev a2)
00:0d.0 IDE interface: nVidia Corporation MCP51 IDE (rev a1)
00:0e.0 IDE interface: nVidia Corporation MCP51 Serial ATA Controller (rev a1)
00:10.0 PCI bridge: nVidia Corporation MCP51 PCI Bridge (rev a2)
00:10.1 Audio device: nVidia Corporation MCP51 High Definition Audio (rev a2)
00:14.0 Bridge: nVidia Corporation MCP51 Ethernet Controller (rev a1)
00:18.0 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] HyperTransport Technology Configuration
00:18.1 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] Address Map
00:18.2 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] DRAM Controller
00:18.3 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] Miscellaneous Control
01:08.0 Serial controller: 3Com Corp, Modem Division 56K FaxModem Model 5610 (rev 01)
01:09.0 Multimedia controller: Philips Semiconductors SAA7134/SAA7135HL Video Broadcast Decoder (rev 01)
