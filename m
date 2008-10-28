Return-Path: <linux-kernel-owner+w=401wt.eu-S1754154AbYJ1PMS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754154AbYJ1PMS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 11:12:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752326AbYJ1PMG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 11:12:06 -0400
Received: from smtp-vbr16.xs4all.nl ([194.109.24.36]:3608 "EHLO
	smtp-vbr16.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751673AbYJ1PME (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 11:12:04 -0400
Date: Tue, 28 Oct 2008 16:11:57 +0100
From: Folkert van Heusden <folkert@vanheusden.com>
To: linux-kernel@vger.kernel.org
Subject: [2.6.26] kobject_add_internal failed for 2:0 with -EEXIST / unable
	to handle kernel NULL pointer dereference in sysfs_create_link
Message-ID: <20081028151157.GI11214@vanheusden.com>
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
Reply-By: Wed Oct 29 12:57:18 CET 2008
X-Message-Flag: MultiTail - tail on steroids
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While running my http://vanheusden.com/pyk/ script (which randomly
inserts and removes modules) I triggered the folllowing oops in a 2.6.26
kernel on an IBM xSeries 260. This oops (in fact no oops at all) did not
get triggered in a 2.6.18 kernel on that system.

[   42.507375] FDC 0 is a National Semiconductor PC87306
[   42.509057] kobject_add_internal failed for 2:0 with -EEXIST, don't try to register things with the same name in the same directory.
[   42.509291] Pid: 5301, comm: modprobe Not tainted 2.6.26-1-amd64 #1
[   42.509431]
[   42.509433] Call Trace:
[   42.509685]  [<ffffffff8031b031>] kobject_add_internal+0x13f/0x17e
[   42.509823]  [<ffffffff8031b46e>] kobject_add+0x74/0x7c
[   42.509969]  [<ffffffff802e2470>] sysfs_addrm_finish+0x19/0x1ea
[   42.510141]  [<ffffffff802e21b4>] sysfs_find_dirent+0x1b/0x2f
[   42.510331]  [<ffffffff802e2741>] create_dir+0x5a/0x87
[   42.510466]  [<ffffffff8031ae88>] kobject_get+0x12/0x17
[   42.510614]  [<ffffffff80382771>] get_device+0x17/0x20
[   42.510754]  [<ffffffff80382d81>] device_add+0x9b/0x53f
[   42.510915]  [<ffffffff8031acf2>] kobject_init+0x41/0x69
[   42.511374]  [<ffffffff803832d1>] device_create_vargs+0x9a/0xc6
[   42.511519]  [<ffffffff8027d23b>] bdi_register+0x57/0xb4
[   42.511657]  [<ffffffff8030ac34>] elv_register_queue+0x67/0x6f
[   42.511818]  [<ffffffff8030e54e>] blk_register_queue+0x77/0x9b
[   42.511818]  [<ffffffff80311ff4>] add_disk+0x64/0x87
[   42.511818]  [<ffffffffa0071f04>] :floppy:floppy_module_init+0xdf3/0xea8
[   42.511818]  [<ffffffff8022c184>] try_to_wake_up+0x118/0x129
[   42.511840]  [<ffffffff80254e9b>] sys_init_module+0x190e/0x1aa4
[   42.511992]  [<ffffffff8030cc77>] blk_init_queue+0x0/0x8
[   42.512148]  [<ffffffff8020be9a>] system_call_after_swapgs+0x8a/0x8f
[   42.512290]
[   42.512410] BUG: unable to handle kernel NULL pointer dereference at 0000000000000128
[   42.512703] IP: [<ffffffff802e2f17>] sysfs_create_link+0x44/0x105
[   42.512889] PGD 1bdc12067 PUD 1ba9d5067 PMD 0
[   42.513198] Oops: 0000 [1] SMP
[   42.513422] CPU 2
[   42.513576] Modules linked in: floppy(+) output ide_cd_mod serio_raw dm_snapshot ata_generic snd_pcm snd_timer i2c_piix4 dm_mirror ehci_hcd battery usbhid ff_memless pcspkr(-) fan thermal_sys libata loop i2c_core joydev dm_log hid cdrom snd_page_alloc evdev netconsole configfs ipv6 snd soundcore ext3 jbd mbcache dm_mod dock enclosure sd_mod serverworks aacraid scsi_mod tg3 ide_pci_generic ide_core [last unloaded: psmouse]
[   42.519374] Pid: 5301, comm: modprobe Not tainted 2.6.26-1-amd64 #1
[   42.519374] RIP: 0010:[<ffffffff802e2f17>]  [<ffffffff802e2f17>] sysfs_create_link+0x44/0x105
[   42.519374] RSP: 0018:ffff8101ba991d48  EFLAGS: 00010246
[   42.519374] RAX: 0000000000009292 RBX: 00000000000000f0 RCX: ffffffff804fe088
[   42.519374] RDX: ffffffff804b341d RSI: 00000000000000f0 RDI: ffffffff80653d80
[   42.519374] RBP: ffffffff804b341d R08: 0000000000000000 R09: ffff8101bb44d000
[   42.519374] R10: 0000000000000001 R11: 0000000000000046 R12: 00000000fffffff2
[   42.519374] R13: ffff8101bac6c5f0 R14: 0000000000000008 R15: 0000000000000000
[   42.519374] FS:  00007f97800126e0(0000) GS:ffff8101bf0ad0c0(0000) knlGS:0000000000000000
[   42.519374] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   42.519374] CR2: 0000000000000128 CR3: 00000001a9c89000 CR4: 00000000000006e0
[   42.519374] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   42.519374] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   42.519374] Process modprobe (pid: 5301, threadinfo ffff8101ba990000, task ffff8101bf20e3c0)
[   42.519374] Stack:  0000000000000000 ffffffff8030e54e ffff8101bc0d9c00 0000000000000000
[   42.519374]  ffff8101bc0d9d58 0000000000000000 0000000000000000 ffffffffa01fee30
[   42.522582]  ffffffffa01fee20 ffffffffa0071f04 ffffffff8022c184 0000000000000282
[   42.522582] Call Trace:
[   42.522582]  [<ffffffff8030e54e>] ? blk_register_queue+0x77/0x9b
[   42.522582]  [<ffffffffa0071f04>] ? :floppy:floppy_module_init+0xdf3/0xea8
[   42.522582]  [<ffffffff8022c184>] ? try_to_wake_up+0x118/0x129
[   42.522582]  [<ffffffff80254e9b>] ? sys_init_module+0x190e/0x1aa4
[   42.522582]  [<ffffffff8030cc77>] ? blk_init_queue+0x0/0x8
[   42.522582]  [<ffffffff8020be9a>] ? system_call_after_swapgs+0x8a/0x8f
[   42.522582]
[   42.522582]
[   42.522582] Code: 48 85 ff 49 c7 c5 a0 ba 50 80 74 13 4c 8b 6f 38 41 bc f2 ff ff ff 4d 85 ed 0f 84 bc 00 00 00 48 c7 c7 80 3d 65 80 e8 fb 68 14 00 <48> 8b 5b 38 48 85 db 74 19 83 3b 00 75 11 be 81 00 00 00 48 c7
[   42.526571] RIP  [<ffffffff802e2f17>] sysfs_create_link+0x44/0x105
[   42.526571]  RSP <ffff8101ba991d48>
[   42.526571] CR2: 0000000000000128
[   42.531559] ---[ end trace 4eb65a6452398ce5 ]---


Folkert van Heusden

-- 
Multitail est un outil permettant la visualisation de fichiers de
journalisation et/ou le suivi de l'exécution de commandes. Filtrage,
mise en couleur de mot-clé, fusions, visualisation de différences
(diff-view), etc.  http://www.vanheusden.com/multitail/
----------------------------------------------------------------------
Phone: +31-6-41278122, PGP-key: 1F28D8AE, www.vanheusden.com
