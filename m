Return-Path: <linux-kernel-owner+w=401wt.eu-S1757522AbZANTiK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757522AbZANTiK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 14:38:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754618AbZANThv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 14:37:51 -0500
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:2400 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757311AbZANThs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 14:37:48 -0500
Date: Wed, 14 Jan 2009 20:37:46 +0100
From: Folkert van Heusden <folkert@vanheusden.com>
To: linux-kernel@vger.kernel.org
Subject: [2.6.28] BUG: unable to handle kernel NULL pointer dereference at
	00000010
Message-ID: <20090114193745.GQ23674@vanheusden.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Organization: www.unixexpert.nl
X-Chameleon-Return-To: folkert@vanheusden.com
X-Xfmail-Return-To: folkert@vanheusden.com
X-Phonenumber: +31-6-41278122
X-URL: http://www.vanheusden.com/
X-PGP-KeyID: 1F28D8AE
X-GPG-fingerprint: AC89 09CE 41F2 00B4 FCF2  B174 3019 0E8C 1F28 D8AE
X-Key: http://pgp.surfnet.nl:11371/pks/lookup?op=get&search=0x1F28D8AE
Read-Receipt-To: <folkert@vanheusden.com>
Reply-By: Thu Jan 15 09:10:29 CET 2009
X-Message-Flag: www.vanheusden.com
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Was able to trigger the following:
[  812.572406] FDC 0 is a post-1991 82077
[  812.587464] work still pending
[  812.593304] BUG: unable to handle kernel NULL pointer dereference at 00000010
[  812.593443] IP: [<c01f8633>] elv_next_request+0x1ba/0x1cd
[  812.593542] *pde = 00000000 
[  812.593635] Oops: 0000 [#1] SMP 
[  812.593756] last sysfs file: /sys/devices/pci0000:00/0000:00:1d.7/usb1/idVendor
[  812.593827] Modules linked in: snd_intel8x0(+) battery thermal processor loop container ata_generic pcspkr i2c_i801 uhci_hcd(-) i2c_core dm_snapshot ac ehci_hcd rng_core snd_ac97_codec ide_cd_mod shpchp dm_mirror dm_region_hash parport_pc pci_hotplug evdev parport cdrom libata scsi_mod dm_log thermal_sys snd_pcm snd_timer ac97_bus snd_page_alloc snd soundcore hid_dell hid_pl hid_cypress hid_zpff hid_gyration hid_bright hid_sony hid_samsung hid_microsoft hid_tmff hid_monterey hid_ezkey hid_apple hid_a4tech hid_logitech ff_memless hid_cherry hid_sunplus hid_petalynx hid_belkin hid_chicony usbhid hid netconsole ipv6 intel_agp agpgart ext3 jbd mbcache dm_mod ide_generic ide_gd_mod piix ide_core e1000 usbcore [last unloaded: floppy]
[  812.596668] 
[  812.596718] Pid: 10, comm: events/1 Not tainted (2.6.28 #1) 808736G
[  812.596777] EIP: 0060:[<c01f8633>] EFLAGS: 00010046 CPU: 1
[  812.596838] EIP is at elv_next_request+0x1ba/0x1cd
[  812.596894] EAX: dd63ccc0 EBX: de89981c ECX: 00000000 EDX: 00000000
[  812.596951] ESI: de899834 EDI: dd63ccc0 EBP: db078f04 ESP: db078ef0
[  812.597007]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[  812.597007] Process events/1 (pid: 10, ti=db078000 task=db096520 task.ti=db078000)
[  812.597007] Stack:
[  812.597007]  00000000 00000002 de89981c de899834 db02d600 db078f60 de89292c db078f34
[  812.597007]  c01264b7 00000000 00000002 00000000 c012646e 00000046 db02d610 db02d624
[  812.597007]  00000246 db078f90 db02d600 db078f60 00000246 00000000 00000002 00000000
[  812.597007] Call Trace:
[  812.597007]  [<c01264b7>] ? finish_task_switch+0x49/0xbe
[  812.597007]  [<c012646e>] ? finish_task_switch+0x0/0xbe
[  812.597007]  [<c0138568>] ? run_workqueue+0xd7/0x1a5
[  812.597007]  [<c0138523>] ? run_workqueue+0x92/0x1a5
[  812.597007]  [<c0147b67>] ? trace_hardirqs_on+0xb/0xd
[  812.597007]  [<c01386ed>] ? worker_thread+0xb7/0xc3
[  812.597007]  [<c013b7ab>] ? autoremove_wake_function+0x0/0x33
[  812.597007]  [<c0138636>] ? worker_thread+0x0/0xc3
[  812.597007]  [<c013b531>] ? kthread+0x3b/0x61
[  812.597007]  [<c013b4f6>] ? kthread+0x0/0x61
[  812.597007]  [<c01048e3>] ? kernel_thread_helper+0x7/0x10
[  812.597007] Code: f0 8d 55 f0 89 f8 e8 e9 38 00 00 85 c0 74 0d 8b 5d f0 85 db 0f 85 67 fe ff ff eb 18 8b 07 39 f8 75 dc 8b 47 0c 31 d2 8b 08 89 f8 <ff> 51 10 85 c0 75 ea 31 db 8d 65 f4 89 d8 5b 5e 5f 5d c3 55 89 
[  812.597007] EIP: [<c01f8633>] elv_next_request+0x1ba/0x1cd SS:ESP 0068:db078ef0
[  812.597007] ---[ end trace 965a3d81f81574b8 ]---


On a p4 with ht, ide disk and 512mb of ram.


Folkert van Heusden

-- 

Multitail - gibkaja utilita po sledovaniju log-fajlov i vyvoda
kommand. Fil'trovanie, raskrašivanie, slijanie, vizual'noe sravnenie,
i t.d.  http://www.vanheusden.com/multitail/
----------------------------------------------------------------------
Phone: +31-6-41278122, PGP-key: 1F28D8AE, www.vanheusden.com
