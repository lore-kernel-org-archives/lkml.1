Return-Path: <linux-kernel-owner+w=401wt.eu-S1755012AbYBXN2o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755012AbYBXN2o (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2008 08:28:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751317AbYBXN2d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Feb 2008 08:28:33 -0500
Received: from web52908.mail.re2.yahoo.com ([206.190.49.18]:26335 "HELO
	web52908.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751837AbYBXN22 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2008 08:28:28 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=M7JF9UCN6Bl30j2nX7lJFa9Dazohipn8U/xWCcLQKGK0cddISCQ7AWeMXaOwqauTNO1onYiPRep4aS6vCCBIrUG0DYJ8cg5VdfS5Cna0mr10pNkF1xjIRAizYOr9y+JD7evDfYs90NP5ohluItu1f/atX4v5CxKfP+22VM//Yg8=;
X-YMail-OSG: ZNjsoscVM1nOLIsh2DbDyuHUfhaNqKD1cNV5l3iJ8ELjymgyGp7JdF1g11rTdFH2hCuoNB0yRvhDfZjJJT1k3oGne_1P3IdNCyacbJMxJl7vjRq6tMvvDhm.h.VF
Date: Sun, 24 Feb 2008 13:28:27 +0000 (GMT)
From: Chris Rankin <rankincj@yahoo.com>
Subject: [BUG] NMI watchdog alert with Linux 2.6.23.16
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <370601.68398.qm@web52908.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is a strange NMI lockup - I have no idea what triggered it and so cannot possibly reproduce
it. Requests to try (try "what"?) with 2.6.24.x would be similarly unhelpful.

But anyway, here it is. A perfectly normal boot of 2.6.23.16 on a dual P4 Xeon (HT enabled, to
give 4 logical CPUs) with 2 GB RAM, until it all goes horribly wrong:

...
scsi1 : ata_piix
ata1: PATA max UDMA/100 cmd 0x000101f0 ctl 0x000103f6 bmdma 0x0001ffa0 irq 14
ata2: PATA max UDMA/100 cmd 0x00010170 ctl 0x00010376 bmdma 0x0001ffa8 irq 15
ata1.00: ATA-6: IC35L090AVV207-0, V23OA66A, max UDMA/100
ata1.00: 156250000 sectors, multi 8: LBA48 
usb 1-2: device not accepting address 2, error -71
ata1.00: configured for UDMA/100
usb 4-3: new high speed USB device using ehci_hcd and address 3
ata2.00: ATAPI: HL-DT-STDVD-ROM GDR8162B, 0015, max UDMA/33
ata2.01: ATAPI: SONY    CD-RW  CRX216E, PD01, max UDMA/33
usb 4-3: configuration #1 chosen from 1 choice
hub 4-3:1.0: USB hub found
hub 4-3:1.0: 4 ports detected
ata2.00: configured for UDMA/33
ata2.01: configured for UDMA/33
scsi 0:0:0:0: Direct-Access     ATA      IC35L090AVV207-0 V23O PQ: 0 ANSI: 5
sd 0:0:0:0: [sda] 156250000 512-byte hardware sectors (80000 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:0: [sda] 156250000 512-byte hardware sectors (80000 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda: sda1 sda2 sda3 sda4 < sda5 sda6 sda7 >
sd 0:0:0:0: [sda] Attached SCSI disk
scsi 1:0:0:0: CD-ROM            HL-DT-ST DVD-ROM GDR8162B 0015 PQ: 0 ANSI: 5
usb 1-2: new full speed USB device using uhci_hcd and address 4
scsi 1:0:1:0: CD-ROM            SONY     CD-RW  CRX216E   PD01 PQ: 0 ANSI: 5
usb 1-2: configuration #1 chosen from 1 choice
usb 4-3.4: new high speed USB device using ehci_hcd and address 4
usb 4-3.4: configuration #1 chosen from 1 choice
device-mapper: ioctl: 4.11.0-ioctl (2006-10-12) initialised: dm-devel@redhat.com
end_request: I/O error, dev fd0, sector 0
end_request: I/O error, dev fd0, sector 0
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
Real Time Clock Driver v1.12ac

Fedora release 8 (Werewolf)
Kernel 2.6.23.16 on an i686

volcano.underworld login: BUG: NMI Watchdog detected LOCKUP on CPU1, eip c010df34, registers:
CPU:    1
EIP:    0060:[<c010df34>]    Not tainted VLI
EFLAGS: 00000046   (2.6.23.16 #1)
EIP is at ipi_handler+0x17/0x57
eax: f5c1ed98   ebx: f5c1ed98   ecx: 01cdb000   edx: c0340d00
esi: 00000086   edi: 00000000   ebp: f6073c9c   esp: c0346dd8
ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
Process sendmail (pid: 2232, ti=c0346000 task=f6a02ff0 task.ti=f6be4000)
Stack: 0000000f f5c1ed98 c010df1d 00000000 f6073c9c c0112b52 f6371218 f7392480 
       f739256c c0104a04 f6371218 c0346000 00000207 f7392480 f739256c f6073c9c 
       f6371218 0000007b 0000007b 000000d8 ffffff04 c02777b5 00000060 00000207 
Call Trace:
 [<c010df1d>] ipi_handler+0x0/0x57
 [<c0112b52>] smp_call_function_interrupt+0x37/0x52
 [<c0104a04>] call_function_interrupt+0x28/0x30
 [<c02777b5>] _spin_unlock_irqrestore+0x5/0x23
 [<c0224fa6>] sock_def_readable+0x3c/0x66
 [<c024d9dd>] tcp_data_queue+0x502/0xa48
 [<c024f527>] tcp_rcv_established+0x5a4/0x645
 [<c02544d7>] tcp_v4_do_rcv+0x28/0x342
 [<c012528f>] local_bh_enable+0x86/0xa2
 [<c02567ec>] tcp_v4_rcv+0x828/0x884
 [<c023e45b>] ip_local_deliver+0xd9/0x196
 [<c023e97e>] ip_rcv+0x466/0x49c
 [<c011b892>] load_balance+0x6d/0x255
 [<c02777e1>] _spin_unlock_irq+0xe/0x22
 [<c023e518>] ip_rcv+0x0/0x49c
 [<c022ad23>] netif_receive_skb+0x1c9/0x255
 [<c022cccc>] process_backlog+0x7f/0xe7
 [<c022cd94>] net_rx_action+0x60/0xeb
 [<c0125062>] __do_softirq+0x58/0xba
 [<c01067aa>] do_softirq+0x5c/0xb2
 [<c0201947>] loopback_xmit+0x5d/0x62
 [<c0125285>] local_bh_enable+0x7c/0xa2
 [<c022d254>] dev_queue_xmit+0x268/0x290
 [<c0242012>] ip_output+0x20d/0x245
 [<c0242964>] ip_queue_xmit+0x29d/0x2dd
 [<c0179f07>] __getblk+0x14/0x1ea
 [<c014bc5f>] __inc_zone_state+0xc/0x4c
 [<f88948af>] __ext3_get_inode_loc+0x10a/0x2cd [ext3]
 [<c02502d9>] tcp_transmit_skb+0x622/0x655
 [<c0277637>] _spin_lock+0xd/0x5a
 [<c0180f1d>] inotify_d_instantiate+0x44/0x72
 [<c0251c75>] __tcp_push_pending_frames+0x709/0x7b9
 [<c0226f1d>] __alloc_skb+0x28/0xfb
 [<c0226f42>] __alloc_skb+0x4d/0xfb
 [<c02482f3>] tcp_sendmsg+0x921/0xa19
 [<c0170c42>] mntput_no_expire+0x11/0x63
 [<c0221185>] sock_aio_write+0xbc/0xc8
 [<c015e79b>] do_sync_write+0xc7/0x10a
 [<c0130ed4>] autoremove_wake_function+0x0/0x35
 [<c011a648>] __wake_up+0x32/0x43
 [<c015ef28>] vfs_write+0x9e/0x10c
 [<c027788f>] unlock_kernel+0x2e/0x2f
 [<c015f483>] sys_write+0x41/0x67
 [<c0103f66>] sysenter_past_esp+0x5f/0x85
 [<c0270000>] xfrm_hash_alloc+0x5e/0x76
 =======================
Code: 78 04 01 75 0d 9c 5b fa a1 a4 68 35 c0 ff 50 0c 53 9d 5b c3 55 57 56 53 83 ec 04 89 c3 9c 5e
fa f0 ff 08 eb 02 f3 90 83 7b 04 00 <74> f8 8b 7b 10 83 ff ff 8b 2d a4 68 35 c0 74 14 8b 4b 0c 8b
53 



      __________________________________________________________
Sent from Yahoo! Mail.
A Smarter Inbox. http://uk.docs.yahoo.com/nowyoucan.html
