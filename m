Return-Path: <linux-kernel-owner+w=401wt.eu-S1754433AbYGISTb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754433AbYGISTb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 14:19:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752677AbYGISTY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 14:19:24 -0400
Received: from mailmxout.mailmx.agnat.pl ([193.239.44.238]:3386 "EHLO
	mailmxout.mailmx.agnat.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752015AbYGISTX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 14:19:23 -0400
From: Arkadiusz Miskiewicz <arekm@maven.pl>
To: linux-kernel@vger.kernel.org
Subject: 2.6.25.6 raid5 resync oops
Date: Wed, 9 Jul 2008 20:19:19 +0200
User-Agent: PLD Linux KMail/1.9.9
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200807092019.20090.arekm@maven.pl>
X-Authenticated-Id: arekm
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


While kernel was resyncing raid5 array on 4 sata disks this happened

------------[ cut here ]------------
kernel BUG at drivers/md/raid5.c:2398!
invalid opcode: 0000 [1] SMP
CPU 0
Modules linked in: acquirewdt advantechwdt hpwdt iTCO_wdt ib700wdt pcwd_pci pcwd_usb wafer5823wdt wdt_pci ipmi_watchdog ipmi_msghandler ipv6 nf_conntrack_ipv4 xt_state nf_conntrack xt_tcpudp ipt_REJECT iptable_filter 
xt_CLASSIFY iptable_mangle ip_tables x_tables sch_sfq sch_htb forcedeth ext3 jbd mbcache raid456 async_xor async_memcpy async_tx xor raid1 usbkbd usb_storage libusual ohci_hcd ssb pcmcia pcmcia_core firmware_class 
ehci_hcd usbcore xfs scsi_wait_scan sd_mod sata_nv libata dock scsi_mod raid10 md_mod
Pid: 1619, comm: md3_resync Not tainted 2.6.25.6-vanilla-1 #1
RIP: 0010:[<ffffffff8816d740>]  [<ffffffff8816d740>] :raid456:cleanup_module+0x4620/0x8380
RSP: 0018:ffff81007c511b40  EFLAGS: 00010202
RAX: 0000000000000000 RBX: 0000000000000000 RCX: ffff81007c448b30
RDX: 0000000000000004 RSI: 0000000000000000 RDI: 00000000ffffffff
RBP: ffff81007c448ac0 R08: ffff81007c448b38 R09: 0000000000000000
R10: ffff81007c448b38 R11: 0000000000000003 R12: 0000000000000003
R13: ffff81007cd26000 R14: 0000000000000003 R15: 0000000000000000
FS:  0000000041a2d960(0000) GS:ffffffff805b2000(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 00007f2a52084000 CR3: 000000002c906000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process md3_resync (pid: 1619, threadinfo ffff81007c510000, task ffff81007e95f5a0)
Stack:  0000000000000000 00000004010060f0 0000000000000001 0000000000000000
 0000000000000003 0000000000000000 0000000000000000 0000000000000000
 0000000000000000 0000000000000000 0000000000000001 ffff81007c448ac0
Call Trace:
 [<ffffffff8816ee59>] ? :raid456:cleanup_module+0x5d39/0x8380
 [<ffffffff88169726>] ? :raid456:cleanup_module+0x606/0x8380
 [<ffffffff8816a246>] ? :raid456:cleanup_module+0x1126/0x8380
 [<ffffffff8817037e>] ? :raid456:cleanup_module+0x725e/0x8380
 [<ffffffff80332868>] ? generic_unplug_device+0x18/0x30
 [<ffffffff80331395>] ? blk_unplug+0x35/0x70
 [<ffffffff88169220>] ? :raid456:cleanup_module+0x100/0x8380
 [<ffffffff8800657e>] ? :md_mod:md_do_sync+0x32e/0x1370
 [<ffffffff8024cb60>] ? autoremove_wake_function+0x0/0x30
 [<ffffffff88009480>] ? :md_mod:md_check_recovery+0x1ec0/0x2220
 [<ffffffff880094b0>] ? :md_mod:md_check_recovery+0x1ef0/0x2220
 [<ffffffff88009480>] ? :md_mod:md_check_recovery+0x1ec0/0x2220
 [<ffffffff8024c75b>] ? kthread+0x4b/0x80
 [<ffffffff8020cfe8>] ? child_rip+0xa/0x12
 [<ffffffff8024c710>] ? kthread+0x0/0x80
 [<ffffffff8020cfde>] ? child_rip+0x0/0x12


Code: 00 00 00 01 83 44 24 1c 01 e9 5d f6 ff ff f0 0f ba 6d 38 06 f0 0f ba 6d 38 02 e9 bf fe ff ff 0f 0b eb fe 0f 0b eb fe 0f 0b eb fe <0f> 0b eb fe 66 66 66 2e 0f 1f 84 00 00 00 00 00 41 57 49 89 f8
RIP  [<ffffffff8816d740>] :raid456:cleanup_module+0x4620/0x8380
 RSP <ffff81007c511b40>
---[ end trace f55178690f3a1b5d ]---

-- 
Arkadiusz Miśkiewicz        PLD/Linux Team
arekm / maven.pl            http://ftp.pld-linux.org/
