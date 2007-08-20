Return-Path: <linux-kernel-owner+w=401wt.eu-S1753695AbXHTXCV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753695AbXHTXCV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 19:02:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754439AbXHTXCJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 19:02:09 -0400
Received: from postfix2-g20.free.fr ([212.27.60.43]:33520 "EHLO
	postfix2-g20.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752555AbXHTXCH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 19:02:07 -0400
Subject: Macbook bug after suspend to disk
From: Lionel Landwerlin <landwer@free.fr>
Reply-To: landwer@free.fr
To: linux-kernel@vger.kernel.org
Content-Type: text/plain
Date: Tue, 21 Aug 2007 00:59:50 +0200
Message-Id: <1187650790.5194.2.camel@cocoduo.atr>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I'm using 2.6.22.1 on my macbook (32bits). I had got this trace a few
hours after a suspend to disk. I never got this kind of trace without
suspend. I will try to reproduce with 2.6.22.3.

Here is the trace :

Aug 20 14:14:23 cocoduo kernel: kernel BUG at mm/slab.c:2980!
Aug 20 14:14:23 cocoduo kernel: invalid opcode: 0000 [#1]
Aug 20 14:14:23 cocoduo kernel: SMP 
Aug 20 14:14:23 cocoduo kernel: Modules linked in: wlan_tkip wlan_ccmp usbkbd ath_pci button nfs lockd nfs_acl sunrpc ac battery cpufreq_ondemand cpufreq_powersave i915 drm binfmt_misc hci_usb rfcomm l2cap bluetooth ppdev lp parport ipv6 dm_snapshot dm_mirror dm_mod cpufreq_userspace acpi_cpufreq freq_table firewire_sbp2 loop joydev usbmouse appletouch snd_hda_intel tsdev sky2 rtc_cmos rtc_core intelfb i2c_i801 wlan_scan_sta iTCO_wdt snd_pcm snd_timer snd soundcore rtc_lib i2c_algo_bit ath_rate_sample intel_agp agpgart i2c_core snd_page_alloc wlan ath_hal(P) evdev ext3 jbd mbcache usbhid hid sd_mod ide_cd cdrom ata_piix ata_generic libata scsi_mod piix firewire_ohci firewire_core crc_itu_t ehci_hcd generic ide_core uhci_hcd usbcore thermal processor fan
Aug 20 14:14:23 cocoduo kernel: CPU:    0
Aug 20 14:14:23 cocoduo kernel: EIP:    0060:[<c016706a>]    Tainted: P       VLI
Aug 20 14:14:23 cocoduo kernel: EFLAGS: 00210092   (2.6.22-1-686 #1)
Aug 20 14:14:23 cocoduo kernel: EIP is at cache_alloc_refill+0xe9/0x451
Aug 20 14:14:23 cocoduo kernel: eax: 0000007f   ebx: c20bf800   ecx: df9e8d40   edx: 00000000
Aug 20 14:14:23 cocoduo kernel: esi: db91c000   edi: 00000010   ebp: dfff1600   esp: eecdddbc
Aug 20 14:14:23 cocoduo kernel: ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
Aug 20 14:14:23 cocoduo kernel: Process hald (pid: 5167, ti=eecdc000 task=ef3a8a50 task.ti=eecdc000)
Aug 20 14:14:23 cocoduo kernel: Stack: 00000000 00000000 000000d0 df9e8d40 df9e0c00 00000000 c0152f3b 00000044 
Aug 20 14:14:23 cocoduo kernel:        000000d0 c0327ff4 ef3a8a50 00000000 000000a4 df9e8d40 00200202 c210ac24 
Aug 20 14:14:23 cocoduo kernel:        c0167553 000000a4 00000001 000000a4 c02017f4 00000004 c210ac00 00000000 
Aug 20 14:14:23 cocoduo kernel: Call Trace:
Aug 20 14:14:23 cocoduo kernel:  [<c0152f3b>] __alloc_pages+0x52/0x294
Aug 20 14:14:23 cocoduo kernel:  [<c0167553>] kmem_cache_zalloc+0x42/0x79
Aug 20 14:14:23 cocoduo kernel:  [<c02017f4>] acpi_ps_alloc_op+0x5d/0x9e
Aug 20 14:14:23 cocoduo kernel:  [<c02014a7>] acpi_ps_parse_loop+0x6f6/0x737
Aug 20 14:14:23 cocoduo kernel:  [<c02007b2>] acpi_ps_parse_aml+0x60/0x237
Aug 20 14:14:23 cocoduo kernel:  [<c01f444c>] acpi_ds_init_aml_walk+0xb4/0xfe
Aug 20 14:14:23 cocoduo kernel:  [<c02019f0>] acpi_ps_execute_method+0x11b/0x1bb
Aug 20 14:14:23 cocoduo kernel:  [<c01fed59>] acpi_ns_evaluate+0x99/0xf0
Aug 20 14:14:23 cocoduo kernel:  [<c01fe9c1>] acpi_evaluate_object+0x139/0x1dc
Aug 20 14:14:23 cocoduo kernel:  [<c01f0a6d>] acpi_evaluate_integer+0x80/0xb3
Aug 20 14:14:23 cocoduo kernel:  [<f8e01096>] acpi_ac_get_state+0x26/0x61 [ac]
Aug 20 14:14:23 cocoduo kernel:  [<c015d3ed>] vma_link+0x54/0xc9
Aug 20 14:14:23 cocoduo kernel:  [<f8e01130>] acpi_ac_seq_show+0x12/0x4e [ac]
Aug 20 14:14:23 cocoduo kernel:  [<c017fc87>] seq_read+0xe7/0x274
Aug 20 14:14:23 cocoduo kernel:  [<c017fba0>] seq_read+0x0/0x274
Aug 20 14:14:23 cocoduo kernel:  [<c016a5b9>] vfs_read+0xa6/0x128
Aug 20 14:14:23 cocoduo kernel:  [<c016a9b5>] sys_read+0x41/0x67
Aug 20 14:14:23 cocoduo kernel:  [<c0103d0e>] sysenter_past_esp+0x6b/0xa1
Aug 20 14:14:23 cocoduo kernel:  =======================
Aug 20 14:14:23 cocoduo kernel: Code: 00 00 00 8b 75 00 39 ee 75 15 8b 75 10 8d 45 10 c7 45 34 01 00 00 00 39 c6 0f 84 9c 00 00 00 8b 4c 24 0c 8b 41 38 39 46 10 72 34 <0f> 0b eb fe 8b 44 24 10 8b 5e 14 8b 08 8b 44 24 0c 8b 50 2c 8b 
Aug 20 14:14:23 cocoduo kernel: EIP: [<c016706a>] cache_alloc_refill+0xe9/0x451 SS:ESP 0068:eecdddbc


-- 
Lionel Landwerlin

