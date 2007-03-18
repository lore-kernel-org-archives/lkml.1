Return-Path: <linux-kernel-owner+w=401wt.eu-S932456AbXCRP4P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932456AbXCRP4P (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2007 11:56:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932463AbXCRP4P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Mar 2007 11:56:15 -0400
Received: from www17.your-server.de ([213.133.104.17]:4784 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932456AbXCRP4N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2007 11:56:13 -0400
Message-ID: <45FD616C.30909@m3y3r.de>
Date: Sun, 18 Mar 2007 16:57:32 +0100
From: Thomas Meyer <thomas@m3y3r.de>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [BUG] While rmmod ohci1394
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This happens with cd05a1f818073a623455a58e756c5b419fc98db9:

BUG: unable to handle kernel NULL pointer dereference at virtual address
000000a4
 printing eip:
c021ca33
*pde = 00000000
Oops: 0000 [#1]
SMP
Modules linked in: snd_seq snd_seq_device wlan_wep nls_iso8859_15
nls_cp850 vfat fat appletouch dummy genrtc binfmt_misc tun
cpufreq_ondemand cpufreq_powersave cpufreq_conservative pktcdvd loop
video thermal fan eth1394 button battery ac msr cpuid acpi_cpufreq
freq_table usbhid processor eeprom uhci_hcd ehci_hcd rng_core iTCO_wdt
wlan_scan_sta usbcore ath_rate_sample tpm_infineon tpm tpm_bios ohci1394
snd_hda_intel snd_hda_codec snd_pcm ath_pci wlan snd_timer ath_hal(P)
snd soundcore snd_page_alloc ieee1394 sr_mod cdrom evdev i2c_i801
i2c_core sg
CPU:    0
EIP:    0060:[<c021ca33>]    Tainted: P       VLI
EFLAGS: 00210246   (2.6.21-rc4 #250)
EIP is at class_device_remove_attrs+0xa/0x30
eax: f7247c60   ebx: 00000000   ecx: f934e3d0   edx: 00000000
esi: 00000000   edi: f7247c60   ebp: 00000000   esp: ee3ebe34
ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
Process rmmod (pid: 6961, ti=ee3eb000 task=edde05b0 task.ti=ee3eb000)
Stack: f7247c60 f7247c68 00000000 c021cb13 00000000 f7247c60 f7247af0
f933d9fb
       00000000 c021cb49 f7247abc f933d9e2 f9343081 000441c7 0000001b
00000161
       00000000 f94f51bf 00000000 f709a000 f933da03 c021a3aa f709a0a8
f709a0ac
Call Trace:
 [<c021cb13>] class_device_del+0xba/0xe8
 [<f933d9fb>] __nodemgr_remove_host_dev+0x0/0xb [ieee1394]
 [<c021cb49>] class_device_unregister+0x8/0x10
 [<f933d9e2>] nodemgr_remove_ne+0x61/0x7a [ieee1394]
 [<f94f51bf>] ether1394_header_cache+0x0/0x4c [eth1394]
 [<f933da03>] __nodemgr_remove_host_dev+0x8/0xb [ieee1394]
 [<c021a3aa>] device_for_each_child+0x1a/0x3c
 [<f933dd22>] nodemgr_remove_host+0x30/0x90 [ieee1394]
 [<c016d0a4>] iput+0x39/0x62
 [<f933b4a4>] __unregister_host+0x1a/0x98 [ieee1394]
 [<c012c74f>] flush_cpu_workqueue+0x77/0x81
 [<f933b238>] hl_get_hostinfo+0x1e/0x42 [ieee1394]
 [<f933b6ad>] highlevel_remove_host+0x21/0x42 [ieee1394]
 [<f933b136>] hpsb_remove_host+0x38/0x56 [ieee1394]
 [<f93c11f4>] ohci1394_pci_remove+0x44/0x1d9 [ohci1394]
 [<c02a53ad>] klist_del+0x18/0x31
 [<c01d072c>] pci_device_remove+0x16/0x35
 [<c021c24f>] __device_release_driver+0x6e/0x8b
 [<c021c6e8>] driver_detach+0x76/0xb2
 [<c021be8d>] bus_remove_driver+0x57/0x75
 [<c021c744>] driver_unregister+0x8/0x13
 [<c01d0876>] pci_unregister_driver+0xc/0x57
 [<c013b84f>] sys_delete_module+0x192/0x1bb
 [<c015042b>] remove_vma+0x36/0x3b
 [<c0150de7>] do_munmap+0x193/0x1ac
 [<c0103d1e>] sysenter_past_esp+0x5f/0x85
 [<c02a0000>] xfrm_state_add+0x64/0x17d
 =======================
Code: ff c3 85 c0 74 08 83 c0 08 e9 dd 43 f7 ff b8 ea ff ff ff c3 85 c0
74 08 83 c0 08 e9 0a 28 f7 ff c3 57 89 c7 56 53 31 db 8b 70 48 <83> be
a4 00 00 00 00 75 09 eb 17 89 f8 e8 d7 ff ff ff 89 da 83
EIP: [<c021ca33>] class_device_remove_attrs+0xa/0x30 SS:ESP 0068:ee3ebe3

