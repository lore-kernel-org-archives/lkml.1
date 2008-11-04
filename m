Return-Path: <linux-kernel-owner+w=401wt.eu-S1757854AbYKDR1p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757854AbYKDR1p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 12:27:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757462AbYKDR1c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 12:27:32 -0500
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:2393 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757061AbYKDR1a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 12:27:30 -0500
Date: Tue, 4 Nov 2008 18:27:27 +0100
From: Folkert van Heusden <folkert@vanheusden.com>
To: linux-kernel@vger.kernel.org
Subject: [2.6.26] OOPS: unable to handle kernel NULL pointer dereference at
	0000000000000038
Message-ID: <20081104172727.GJ23232@vanheusden.com>
References: <20081104172513.GH23232@vanheusden.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20081104172513.GH23232@vanheusden.com>
Organization: www.unixexpert.nl
X-Chameleon-Return-To: folkert@vanheusden.com
X-Xfmail-Return-To: folkert@vanheusden.com
X-Phonenumber: +31-6-41278122
X-URL: http://www.vanheusden.com/
X-PGP-KeyID: 1F28D8AE
X-GPG-fingerprint: AC89 09CE 41F2 00B4 FCF2  B174 3019 0E8C 1F28 D8AE
X-Key: http://pgp.surfnet.nl:11371/pks/lookup?op=get&search=0x1F28D8AE
Read-Receipt-To: <folkert@vanheusden.com>
Reply-By: Wed Nov  5 16:29:01 CET 2008
X-Message-Flag: MultiTail - tail on steroids
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While running my http://vanheusden.com/pyk/ script (which randomly
inserts and removes modules) I triggered the folllowing WARNING in a
2.6.26 kernel on an IBM xSeries x3650 (2 quadcores (intel qc x5450)
and 10GB ram).

(probably related to previous report)

[ 2813.078161] BUG: unable to handle kernel NULL pointer dereference at 0000000000000038
[ 2813.078161] IP: [<ffffffff802e2264>] sysfs_addrm_start+0x2d/0x99
[ 2813.078161] PGD 2bb8be067 PUD 2bb89d067 PMD 0 
[ 2813.078161] Oops: 0000 [1] SMP 
[ 2813.078161] CPU 5 
[ 2813.078161] Modules linked in: cpufreq_conservative(+) dock ppdev cpufreq_ondemand sg lp cpufreq_userspace acpi_cpufreq pcspkr edac_core ses parport_pc appletalk(-) enclosure loop parport video output battery cdrom rng_core qla2xxx(-) ac rfcomm l2cap bluetooth nfsd lockd nfs_acl auth_rpcgss sunrpc exportfs freq_table ipv6 evdev ext3 jbd mbcache dm_log dm_mod usbhid hid ff_memless sd_mod firmware_class scsi_transport_fc ide_pci_generic ide_core ehci_hcd uhci_hcd scsi_tgt aacraid scsi_mod processor thermal_sys [last unloaded: thermal]
[ 2813.078161] Pid: 10082, comm: qla2xxx_8_dpc Tainted: G        W 2.6.26-1-amd64 #1
[ 2813.078161] RIP: 0010:[<ffffffff802e2264>]  [<ffffffff802e2264>] sysfs_addrm_start+0x2d/0x99
[ 2813.078161] RSP: 0000:ffff8102ba429a60  EFLAGS: 00010246
[ 2813.083209] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
[ 2813.083209] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff8102bfc2d000
[ 2813.083209] RBP: ffff8102ba429a80 R08: 0000000000000080 R09: ffff8102ba429980
[ 2813.083209] R10: ffff8102b8c7a598 R11: 00000e8e90dbbaa0 R12: 00000000fffffff4
[ 2813.083209] R13: 0000000000000000 R14: ffff8102ba429ad8 R15: ffff81028a49c170
[ 2813.083209] FS:  0000000000000000(0000) GS:ffff8102be5696c0(0000) knlGS:0000000000000000
[ 2813.083209] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
[ 2813.083209] CR2: 0000000000000038 CR3: 00000002b99eb000 CR4: 00000000000006e0
[ 2813.083209] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 2813.083209] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 2813.083209] Process qla2xxx_8_dpc (pid: 10082, threadinfo ffff8102ba428000, task ffff8102bbc7c140)
[ 2813.083209] Stack:  00000000fffffff4 ffff8102b8c7a550 ffff8102bc541460 ffffffff802e272b
[ 2813.083209]  0000000000000000 0000000000000000 0000000000000000 0000000000000000
[ 2813.083209]  ffff8102b8c7a550 ffff8102b8c7a400 00000000fffffffe ffff8102b8c7a598
[ 2813.083209] Call Trace:
[ 2813.083209]  [<ffffffff802e272b>] ? create_dir+0x44/0x87
[ 2813.083209]  [<ffffffff802e27a3>] ? sysfs_create_dir+0x35/0x4a
[ 2813.083209]  [<ffffffff8031ae88>] ? kobject_get+0x12/0x17
[ 2813.083209]  [<ffffffff8031afb5>] ? kobject_add_internal+0xc3/0x17e
[ 2813.083209]  [<ffffffff8031b46e>] ? kobject_add+0x74/0x7c
[ 2813.083209]  [<ffffffff8031f235>] ? sprintf+0x51/0x59
[ 2813.083209]  [<ffffffff8031ae88>] ? kobject_get+0x12/0x17
[ 2813.083209]  [<ffffffff80382771>] ? get_device+0x17/0x20
[ 2813.083209]  [<ffffffff80382d81>] ? device_add+0x9b/0x53f
[ 2813.083209]  [<ffffffff80386df6>] ? attribute_container_add_device+0x3f/0x124
[ 2813.083209]  [<ffffffffa00a30e7>] ? :scsi_transport_fc:fc_remote_port_add+0x47a/0x60d
[ 2813.083209]  [<ffffffffa03864a4>] ? :qla2xxx:qla2x00_update_fcport+0x2b8/0x363
[ 2813.083209]  [<ffffffffa038e02d>] ? :qla2xxx:qla2x00_get_port_database+0x2f0/0x2fe
[ 2813.083209]  [<ffffffffa03868fa>] ? :qla2xxx:qla2x00_configure_local_loop+0x32a/0x3c0
[ 2813.083209]  [<ffffffffa0386d14>] ? :qla2xxx:qla2x00_configure_loop+0x384/0x10fd
[ 2813.083209]  [<ffffffffa038c854>] ? :qla2xxx:qla2x00_get_retry_cnt+0x43/0xbd
[ 2813.083209]  [<ffffffff8023ca94>] ? process_timeout+0x0/0x5
[ 2813.083209]  [<ffffffff8042874a>] ? schedule_timeout+0x85/0xad
[ 2813.083209]  [<ffffffffa0387ae9>] ? :qla2xxx:qla2x00_loop_resync+0x5c/0xae
[ 2813.083209]  [<ffffffffa03848d5>] ? :qla2xxx:qla2x00_do_dpc+0x435/0x4d4
[ 2813.083209]  [<ffffffffa03844a0>] ? :qla2xxx:qla2x00_do_dpc+0x0/0x4d4
[ 2813.083209]  [<ffffffff80245efb>] ? kthread+0x47/0x74
[ 2813.083209]  [<ffffffff80230057>] ? schedule_tail+0x27/0x5c
[ 2813.083209]  [<ffffffff8020cef8>] ? child_rip+0xa/0x12
[ 2813.083209]  [<ffffffff80245eb4>] ? kthread+0x0/0x74
[ 2813.083209]  [<ffffffff8020ceee>] ? child_rip+0x0/0x12
[ 2813.083209] 
[ 2813.083209] 
[ 2813.083209] Code: c0 b9 08 00 00 00 fc 53 48 89 fd 48 89 f3 48 83 ec 08 f3 ab 48 89 75 00 48 c7 c7 20 ba 50 80 e8 18 67 14 00 48 8b 3d 64 1b 37 00 <48> 8b 73 38 48 89 d9 48 c7 c2 b8 1f 2e 80 e8 09 a5 fc ff 48 85 
[ 2813.089237] RIP  [<ffffffff802e2264>] sysfs_addrm_start+0x2d/0x99
[ 2813.089237]  RSP <ffff8102ba429a60>
[ 2813.089237] CR2: 0000000000000038
[ 2813.096458] ---[ end trace a70f168407a6dea1 ]---


Folkert van Heusden

-- 
MultiTail è uno flexible tool per seguire di logfiles e effettuazione
di commissioni. Feltrare, provedere da colore, merge, 'diff-view',
etc. http://www.vanheusden.com/multitail/
----------------------------------------------------------------------
Phone: +31-6-41278122, PGP-key: 1F28D8AE, www.vanheusden.com
