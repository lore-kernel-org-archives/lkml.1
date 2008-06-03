Return-Path: <linux-kernel-owner+w=401wt.eu-S1754059AbYFCJt7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754059AbYFCJt7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 05:49:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751935AbYFCJtq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 05:49:46 -0400
Received: from 2605ds1-ynoe.1.fullrate.dk ([90.184.12.24]:53784 "EHLO
	shrek.krogh.cc" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751760AbYFCJtn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 05:49:43 -0400
Message-ID: <47107.195.41.66.226.1212486572.squirrel@mail.jabbernet.dk>
In-Reply-To: <alpine.LFD.1.10.0805261127030.2958@woody.linux-foundation.org>
References: <alpine.LFD.1.10.0805261127030.2958@woody.linux-foundation.org>
Date: Tue, 3 Jun 2008 11:49:32 +0200 (CEST)
Subject: Re: Linux 2.6.26-rc4
From: "Jesper Krogh" <jesper@krogh.cc>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org
User-Agent: SquirrelMail/1.5.1 [CVS]
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

I'm getting this one. The mount.nfs call is being called by the
autofs-daemon.

It is not directly reproducible, but happens around once a day on a single
node on a 48 node cluster.

I reported it to the NFS-guys on a .22 kernel, and was directed to the
fsdevel list(CC'ed again) back then. Now the problem is reproduces on
.26-rc4

Jesper


Jun  3 09:46:58 node40 kernel: [17191699.952564] PGD 9f6f5067 PUD baf4f067
PMD 0
Jun  3 09:46:58 node40 kernel: [17191699.952564] CPU 1
Jun  3 09:46:58 node40 kernel: [17191699.952564] Modules linked in: nfs
lockd sunrpc autofs4 ipv6 af_packet usbhid hid uhci_hcd ehci_hcd usbkbd
parport_pc lp parport amd_rng i2c_amd756 container psmouse serio_raw
button pcspkr evdev i2c_core k8temp shpchp pci_hotplug ext3 jbd mbcache sg
sd_mod ide_cd_mod cdrom amd74xx ide_core floppy mptspi mptscsih mptbase
scsi_transport_spi tg3 ata_generic libata scsi_mod dock ohci_hcd usbcore
thermal processor fan thermal_sys fuse
Jun  3 09:46:58 node40 kernel: [17191699.952564] Pid: 15602, comm:
mount.nfs Not tainted 2.6.26-rc4 #1
Jun  3 09:46:58 node40 kernel: [17191700.727822] RIP:
0010:[graft_tree+77/288]  [graft_tree+77/288] graft_tree+0x4d/0x120
Jun  3 09:46:58 node40 kernel: [17191700.727822] RSP:
0000:ffff810068683e08  EFLAGS: 00010246
Jun  3 09:46:58 node40 kernel: [17191700.727822] RAX: ffff8100bf836a90
RBX: 00000000ffffffec RCX: 0000000000000000
Jun  3 09:46:58 node40 kernel: [17191700.983576] RDX: ffff8100fa378500
RSI: ffff810068683e68 RDI: ffff810029252b00
Jun  3 09:46:58 node40 kernel: [17191700.983576] RBP: ffff810029252b00
R08: 0000000000000000 R09: 0000000000000001
Jun  3 09:46:58 node40 kernel: [17191700.983576] R10: 0000000000000001
R11: ffffffff803011c0 R12: ffff810068683e68
Jun  3 09:46:58 node40 kernel: [17191700.983576] R13: 0000000000000000
R14: 000000000000000b R15: 000000000000000b
Jun  3 09:46:58 node40 kernel: [17191700.983576] FS: 
00007f525595b6e0(0000) GS:ffff8100fbb12280(0000) knlGS:00000000cb307b90
Jun  3 09:46:58 node40 kernel: [17191701.435324] CS:  0010 DS: 0000 ES:
0000 CR0: 000000008005003b
Jun  3 09:46:58 node40 kernel: [17191701.435324] CR2: 00000000000000b2
CR3: 000000005ccbc000 CR4: 00000000000006e0
Jun  3 09:46:58 node40 kernel: [17191701.435324] DR0: 0000000000000000
DR1: 0000000000000000 DR2: 0000000000000000
Jun  3 09:46:58 node40 kernel: [17191701.435324] DR3: 0000000000000000
DR6: 00000000ffff0ff0 DR7: 0000000000000400
Jun  3 09:46:58 node40 kernel: [17191701.435324] Process mount.nfs (pid:
15602, threadinfo ffff810068682000, task ffff8100bad61700)
Jun  3 09:46:58 node40 kernel: [17191701.879311] Stack:  ffff810068683e68
ffff810068683e70 ffff810029252b00 ffffffff802b2622
Jun  3 09:46:58 node40 kernel: [17191701.879311]  0000000000000006
0000000000000000 ffff8100c1b72000 ffff8100f68aa000
Jun  3 09:46:58 node40 kernel: [17191701.879311]  ffff8100f6540000
ffffffff802b49e9 000000004844f763 0000000000000000
Jun  3 09:46:58 node40 kernel: [17191701.879311] Call Trace:
Jun  3 09:46:58 node40 kernel: [17191701.879311]  [do_add_mount+162/320] ?
do_add_mount+0xa2/0x140
Jun  3 09:46:58 node40 kernel: [17191701.879311]  [do_mount+505/592] ?
do_mount+0x1f9/0x250
Jun  3 09:46:58 node40 kernel: [17191701.879311] 
[copy_mount_options+269/384] ? copy_mount_options+0x10d/0x180
Jun  3 09:46:58 node40 kernel: [17191701.879311]  [sys_mount+155/256] ?
sys_mount+0x9b/0x100
Jun  3 09:46:58 node40 kernel: [17191701.879311] 
[system_call_after_swapgs+123/128] ? system_call_after_swapgs+0x7b/0x80
Jun  3 09:46:58 node40 kernel: [17191701.879311]
Jun  3 09:46:58 node40 kernel: [17191701.879311]
Jun  3 09:46:58 node40 kernel: [17191701.879311]  RSP <ffff810068683e08>
Jun  3 09:46:58 node40 kernel: [17191704.861207] ---[ end trace
bc4c286fe026e348 ]---



-- 
Jesper Krogh

