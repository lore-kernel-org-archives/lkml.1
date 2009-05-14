Return-Path: <linux-kernel-owner+w=401wt.eu-S1754152AbZENTSw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754152AbZENTSw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 15:18:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752047AbZENTSn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 15:18:43 -0400
Received: from mo-p00-ob.rzone.de ([81.169.146.160]:55620 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751203AbZENTSm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 15:18:42 -0400
X-RZG-AUTH: :O2kGeEG7b/pS1E64W3aniLTNDUcEh+JwjGMyQkjVygg3aAH02IubSkmAm8qKP6B6ckik
X-RZG-CLASS-ID: mo00
Subject: WARNING in >2.6.30-rc4 : at lib/dma-debug.c:558 check_for_stack
 (warn_slowpath)
From: Martin Capitanio <martin@capitanio.org>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain
Date: Thu, 14 May 2009 21:18:24 +0200
Message-Id: <1242328704.5235.42.camel@marvin>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I get this always during the boot-time (once or twice) with latest git (45d447406a19).
The kernel has no visible issues, so far.

	Martin

x86_64

[   17.276655] WARNING: at lib/dma-debug.c:558 check_for_stack+0x87/0xd0()
[   17.276694] Hardware name: Satellite L300
[   17.276727] ehci_hcd 0000:00:1d.7: DMA-API: device driver maps memory fromstack [addr=ffff8800bd85fce0]
[   17.276788] Modules linked in: rtl8187(+) snd_seq_oss(+) snd_seq_midi snd_rawmidi snd_seq_midi_event uvcvideo snd_seq snd_timer snd_seq_device psmouse mac80211 videodev rfkill iTCO_wdt eeprom_93cx6 pcspkr serio_raw v4l1_compat v4l2_compat_ioctl32 snd btusb input_polldev evdev joydev iTCO_vendor_support video output processor battery ac button intel_agp bluetooth cfg80211 soundcore snd_page_alloc hid_apple sg usbhid hid sd_mod crc_t10dif sr_mod cdrom r8169 mii uhci_hcd dm_mirror dm_region_hash dm_log dm_snapshot dm_mod thermal fan fuse
[   17.277657] Pid: 1627, comm: modprobe Not tainted 2.6.30-rc5-mc29-01 #4
[   17.277693] Call Trace:
[   17.277725]  [<ffffffff80245328>] warn_slowpath_fmt+0xd8/0x130
[   17.277763]  [<ffffffff803f7879>] ? __make_request+0x119/0x460
[   17.277800]  [<ffffffff8020be56>] ? ftrace_call+0x5/0x2b
[   17.277836]  [<ffffffff80270249>] ? __module_address+0x9/0x90
[   17.277870]  [<ffffffff802702e2>] ? __module_text_address+0x12/0x80
[   17.277906]  [<ffffffff8027035e>] ? is_module_text_address+0xe/0x20
[   17.277942]  [<ffffffff8025ab68>] ? __kernel_text_address+0x58/0x80
[   17.277979]  [<ffffffff8020ff41>] ? print_context_stack+0x81/0x150
[   17.278015]  [<ffffffff8020ef76>] ? dump_trace+0x116/0x2d0
[   17.278050]  [<ffffffff8020be56>] ? ftrace_call+0x5/0x2b
[   17.278085]  [<ffffffff80425a47>] check_for_stack+0x87/0xd0
[   17.278120]  [<ffffffff80425d12>] debug_dma_map_page+0x102/0x170
[   17.278157]  [<ffffffff804f6f87>] dma_map_single+0xd7/0x100
[   17.278191]  [<ffffffff804f7e1a>] usb_hcd_submit_urb+0x5aa/0xd70
[   17.278233]  [<ffffffff804132a5>] ? kvasprintf+0x55/0x90
[   17.278267]  [<ffffffff8020be56>] ? ftrace_call+0x5/0x2b
[   17.278301]  [<ffffffff8020be56>] ? ftrace_call+0x5/0x2b
[   17.278335]  [<ffffffff804f8a8d>] usb_submit_urb+0x10d/0x330
[   17.278370]  [<ffffffff804fa2ed>] usb_start_wait_urb+0x5d/0x1b0
[   17.278406]  [<ffffffff8020be56>] ? ftrace_call+0x5/0x2b
[   17.278440]  [<ffffffff804f9118>] ? usb_init_urb+0x28/0x40
[   17.278474]  [<ffffffff804fa6d5>] usb_control_msg+0x135/0x160
[   17.278513]  [<ffffffffa027c190>] rtl8187_probe+0x1a4/0x7cc [rtl8187]
[   17.278549]  [<ffffffff8020be56>] ? ftrace_call+0x5/0x2b
[   17.278584]  [<ffffffffa02747e0>] ? rtl8187_eeprom_register_read+0x0/0x90 [rtl8187]
[   17.278636]  [<ffffffffa02745e0>] ? rtl8187_eeprom_register_write+0x0/0xa0 [rtl8187]
[   17.278687]  [<ffffffff805daac9>] ? mutex_unlock+0x9/0x20
[   17.278721]  [<ffffffff804fc8a0>] ? usb_autopm_do_device+0xc0/0x120
[   17.278758]  [<ffffffff804fd581>] usb_probe_interface+0xf1/0x260
[   17.278795]  [<ffffffff804b8649>] driver_probe_device+0xb9/0x2c0
[   17.278830]  [<ffffffff804b88eb>] __driver_attach+0x9b/0xb0
[   17.278864]  [<ffffffff804b8850>] ? __driver_attach+0x0/0xb0
[   17.278899]  [<ffffffff804b7c9b>] bus_for_each_dev+0x6b/0xa0
[   17.278933]  [<ffffffff804b83c1>] driver_attach+0x21/0x30
[   17.278968]  [<ffffffff804b73fd>] bus_add_driver+0x1ad/0x2e0
[   17.279002]  [<ffffffff804b8bee>] driver_register+0x7e/0x160
[   17.279037]  [<ffffffff804fd299>] usb_register_driver+0xa9/0x120
[   17.279074]  [<ffffffffa0282000>] ? rtl8187_init+0x0/0x20 [rtl8187]
[   17.279110]  [<ffffffffa028201e>] rtl8187_init+0x1e/0x20 [rtl8187]
[   17.279146]  [<ffffffff80209051>] do_one_initcall+0x41/0x170
[   17.279181]  [<ffffffff802623c8>] ? __blocking_notifier_call_chain+0x68/0x90
[   17.279220]  [<ffffffff80273fb5>] sys_init_module+0xb5/0x200
[   17.279254]  [<ffffffff8020c15b>] system_call_fastpath+0x16/0x1b
[   17.279290] ---[ end trace 1c35db9e80ae84cb ]---

----------rc4+------------

 [   14.643004] ------------[ cut here ]------------
 [   14.643036] WARNING: at fs/namei.c:1251 lookup_one_len+0xd9/0xf0()
 [   14.643070] Hardware name: Satellite L300
 [   14.643100] Modules linked in: sr_mod cdrom sd_mod crc_t10dif sg pata_acpi r8169 mii uhci_hcd dm_mirror dm_region_hash dm_log dm_snapshot dm_mod thermal fan fuse
 [   14.643357] Pid: 1229, comm: mount Not tainted 2.6.30-rc4-mc29-01 #1
 [   14.643391] Call Trace:
 [   14.643423]  [<ffffffff80245368>] warn_slowpath+0xd8/0x130
 [   14.643461]  [<ffffffff805d9f25>] ? printk+0x6c/0x6f
 [   14.643495]  [<ffffffff8036ec86>] ? prepare_error_buf+0x5b6/0x6b0
 [   14.643533]  [<ffffffff802602f9>] ? __mutex_init+0x9/0x30
 [   14.643568]  [<ffffffff8020be56>] ? ftrace_call+0x5/0x2b
 [   14.643603]  [<ffffffff8036ee8d>] ? reiserfs_info+0x8d/0xb0
 [   14.643638]  [<ffffffff8020be56>] ? ftrace_call+0x5/0x2b
 [   14.643672]  [<ffffffff802fbfa9>] lookup_one_len+0xd9/0xf0
 [   14.643708]  [<ffffffff80381465>] reiserfs_xattr_init+0xf5/0x270
 [   14.643743]  [<ffffffff8036cf77>] reiserfs_fill_super+0x6e7/0xc00
 [   14.643779]  [<ffffffff8020be56>] ? ftrace_call+0x5/0x2b
 [   14.643813]  [<ffffffff8020be56>] ? ftrace_call+0x5/0x2b
 [   14.643848]  [<ffffffff802f5342>] get_sb_bdev+0x172/0x1a0
 [   14.643882]  [<ffffffff8036c890>] ? reiserfs_fill_super+0x0/0xc00
 [   14.643918]  [<ffffffff8020be56>] ? ftrace_call+0x5/0x2b
 [   14.643952]  [<ffffffff8036a028>] get_super_block+0x18/0x20
 [   14.643986]  [<ffffffff802f4961>] vfs_kern_mount+0x81/0x180
 [   14.644032]  [<ffffffff802f4ad3>] do_kern_mount+0x53/0x110
 [   14.644068]  [<ffffffff8030e00c>] do_mount+0x74c/0x940
 [   14.644102]  [<ffffffff8030e2c0>] sys_mount+0xc0/0xf0
 [   14.644136]  [<ffffffff8020c15b>] system_call_fastpath+0x16/0x1b
 [   14.644171] ---[ end trace 9b6ec5a91604a5bc ]---
...
 [   26.217760] ------------[ cut here ]------------
 [   26.217799] WARNING: at lib/dma-debug.c:609 check_for_stack+0x87/0xd0()
 [   26.217834] Hardware name: Satellite L300
 [   26.217867] ehci_hcd 0000:00:1d.7: DMA-API: device driver maps memory fromstack [addr=ffff8800bc9f9ce0]
 [   26.217920] Modules linked in: rtl8187(+) snd_seq_midi_event uvcvideo snd_seq snd_timer snd_seq_device mac80211 rfkill iTCO_wdt pcspkr psmouse serio_raw videodev v4l1_compat v4l2_compat_ioctl32 eeprom_93cx6 evdev input_polldev video output intel_agp iTCO_vendor_support snd battery ac processor button cfg80211 soundcore snd_page_alloc sr_mod cdrom sd_mod crc_t10dif sg pata_acpi r8169 mii uhci_hcd dm_mirror dm_region_hash dm_log dm_snapshot dm_mod thermal fan fuse
 [   26.218634] Pid: 1482, comm: modprobe Tainted: G        W  2.6.30-rc4-mc29-01 #1
 [   26.218687] Call Trace:
 [   26.218723]  [<ffffffff80245368>] warn_slowpath+0xd8/0x130
 [   26.218765]  [<ffffffff803f0030>] ? test_pcomp+0x3b0/0x530
 [   26.218806]  [<ffffffff8020be56>] ? ftrace_call+0x5/0x2b
 [   26.218845]  [<ffffffff802702d9>] ? __module_address+0x9/0x90
 [   26.218883]  [<ffffffff80270372>] ? __module_text_address+0x12/0x80
 [   26.218921]  [<ffffffff802703ee>] ? is_module_text_address+0xe/0x20
 [   26.218964]  [<ffffffff8025aba8>] ? __kernel_text_address+0x58/0x80
 [   26.219004]  [<ffffffff8020ff51>] ? print_context_stack+0x81/0x150
 [   26.219041]  [<ffffffff8020ef86>] ? dump_trace+0x116/0x2d0
 [   26.219079]  [<ffffffff8020be56>] ? ftrace_call+0x5/0x2b
 [   26.219117]  [<ffffffff8020be56>] ? ftrace_call+0x5/0x2b
 [   26.219153]  [<ffffffff80425d87>] check_for_stack+0x87/0xd0
 [   26.219190]  [<ffffffff80426052>] debug_dma_map_page+0x102/0x170
 [   26.219229]  [<ffffffff804f7877>] dma_map_single+0xd7/0x100
 [   26.219265]  [<ffffffff804f870a>] usb_hcd_submit_urb+0x5aa/0xd70
 [   26.219309]  [<ffffffff804114f9>] ? vsnprintf+0x429/0x590
 [   26.219350]  [<ffffffff804136c5>] ? kvasprintf+0x55/0x90
 [   26.219389]  [<ffffffff8020be56>] ? ftrace_call+0x5/0x2b
 [   26.219426]  [<ffffffff8020be56>] ? ftrace_call+0x5/0x2b
 [   26.219461]  [<ffffffff804f937d>] usb_submit_urb+0x10d/0x330
 [   26.219496]  [<ffffffff804fabdd>] usb_start_wait_urb+0x5d/0x1b0
 [   26.219531]  [<ffffffff8020be56>] ? ftrace_call+0x5/0x2b
 [   26.219565]  [<ffffffff804f9a08>] ? usb_init_urb+0x28/0x40
 [   26.219600]  [<ffffffff804fafc5>] usb_control_msg+0x135/0x160
 [   26.219639]  [<ffffffffa020a1a0>] rtl8187_probe+0x1a4/0x7cc [rtl8187]
 [   26.219675]  [<ffffffff8020be56>] ? ftrace_call+0x5/0x2b
 [   26.219711]  [<ffffffffa02027e0>] ? rtl8187_eeprom_register_read+0x0/0x90 [rtl8187]
 [   26.219762]  [<ffffffffa02025e0>] ? rtl8187_eeprom_register_write+0x0/0xa0 [rtl8187]
 [   26.219814]  [<ffffffff805db3c9>] ? mutex_unlock+0x9/0x20
 [   26.219849]  [<ffffffff804fd190>] ? usb_autopm_do_device+0xc0/0x120
 [   26.219886]  [<ffffffff804fde71>] usb_probe_interface+0xf1/0x260
 [   26.219922]  [<ffffffff804b8eb9>] driver_probe_device+0xb9/0x2c0
 [   26.219957]  [<ffffffff804b915b>] __driver_attach+0x9b/0xb0
 [   26.219992]  [<ffffffff804b90c0>] ? __driver_attach+0x0/0xb0
 [   26.220033]  [<ffffffff804b850b>] bus_for_each_dev+0x6b/0xa0
 [   26.220084]  [<ffffffff804b8c31>] driver_attach+0x21/0x30
 [   26.220120]  [<ffffffff804b7c6d>] bus_add_driver+0x1ad/0x2e0
 [   26.220154]  [<ffffffff804b945e>] driver_register+0x7e/0x160
 [   26.220190]  [<ffffffff804fdb89>] usb_register_driver+0xa9/0x120
 [   26.220226]  [<ffffffffa0210000>] ? rtl8187_init+0x0/0x20 [rtl8187]
 [   26.220263]  [<ffffffffa021001e>] rtl8187_init+0x1e/0x20 [rtl8187]
 [   26.220299]  [<ffffffff80209051>] do_one_initcall+0x41/0x170
 [   26.220334]  [<ffffffff80262418>] ? __blocking_notifier_call_chain+0x68/0x90
 [   26.220372]  [<ffffffff80273fb5>] sys_init_module+0xb5/0x200
 [   26.220407]  [<ffffffff8020c15b>] system_call_fastpath+0x16/0x1b
 [   26.220443] ---[ end trace 9b6ec5a91604a5bd ]---


