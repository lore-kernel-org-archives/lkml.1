Return-Path: <linux-kernel-owner+w=401wt.eu-S1754094AbYJ1Rw5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754094AbYJ1Rw5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 13:52:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752774AbYJ1Rwt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 13:52:49 -0400
Received: from smtp2.sensus.se ([193.13.139.17]:57971 "EHLO smtp2.sensus.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752745AbYJ1Rws (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 13:52:48 -0400
X-Greylist: delayed 2882 seconds by postgrey-1.27 at vger.kernel.org; Tue, 28 Oct 2008 13:52:47 EDT
Date: Tue, 28 Oct 2008 18:01:05 +0100
From: Oskar Liljeblad <oskar@osk.mine.nu>
To: linux-kernel@vger.kernel.org
Subject: sata errors with Seagate 1.5TB on AMD 780G/SB700 motherboard
Message-ID: <20081028170105.GA21933@osk.mine.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Spam-Score: -96.0 (---------------------------------------------------)
X-Spam-Report: Spam detection software, running on the system "smtp2.sensus.se", has
	identified this incoming email as possible spam.  The original message
	has been attached to this so you can view it (if it isn't spam) or label
	similar future email.  If you have any questions, see
	the administrator of that system for details.
	Content preview:  Can anyone make any sense of these SATA errors? They're
	killing my md RAID5 (at least the second error did). Hard drives
	(ata1/sda, ata2/sdb, ata3/sdc): Seagate ST31500341AS 1.5TB SATA
	Motherboard: Asus M3A78-EH with AMD 780G/SB700 chipset SATA driver: ahci
	00:11.0 SATA controller: ATI Technologies Inc SB700/SB800 SATA
	Controller [AHCI mode] [...] 
	Content analysis details:   (-96.0 points, 5.0 required)
	pts rule name              description
	---- ---------------------- --------------------------------------------------
	-100 USER_IN_WHITELIST      From: address is in the user's white-list
	2.0 RCVD_IN_SORBS_DUL      RBL: SORBS: sent directly from dynamic IP address
	[81.236.171.23 listed in dnsbl.sorbs.net]
	2.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Can anyone make any sense of these SATA errors? They're killing my md RAID5
(at least the second error did).

Hard drives (ata1/sda, ata2/sdb, ata3/sdc): Seagate ST31500341AS 1.5TB SATA
Motherboard: Asus M3A78-EH with AMD 780G/SB700 chipset
SATA driver: ahci
00:11.0 SATA controller: ATI Technologies Inc SB700/SB800 SATA Controller [AHCI mode]

Smart reports no errors on the drives, short & long tests have been run as
well. The system is brand new.

I've read some reports about SATA 3.0 Gbps vs 1.5 Gbps problems and I'm
considering limiting the drives to 1.5 Gbps using jumpers. Would that be a
good idea?

19:24:26 ata2: exception Emask 0x50 SAct 0x0 SErr 0x90a02 action 0xe frozen
19:24:26 ata2: irq_stat 0x00400000, PHY RDY changed
19:24:26 ata2: SError: { RecovComm Persist HostInt PHYRdyChg 10B8B }
19:24:26 ata2: hard resetting link
19:24:27 ata2: SATA link down (SStatus 0 SControl 300)
19:24:30 ata2: hard resetting link
19:24:35 ata2: link is slow to respond, please be patient (ready=0)
19:24:38 ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
19:24:38 ata2.00: configured for UDMA/133
19:24:38 ata2: exception Emask 0x10 SAct 0x0 SErr 0x0 action 0x9 t4
19:24:38 ata2: irq_stat 0x00000040, connection status changed
19:24:38 ata2.00: configured for UDMA/133
19:24:38 ata2: EH complete

And then the day after:

09:07:49 ata3.00: exception Emask 0x40 SAct 0x0 SErr 0x800 action 0x6 frozen
09:07:49 ata3: SError: { HostInt }
09:07:49 ata3.00: cmd ea/00:00:00:00:00/00:00:00:00:00/a0 tag 0
09:07:49          res 40/00:00:00:00:00/00:00:00:00:00/a0 Emask 0x44 (timeout)
09:07:49 ata3.00: status: { DRDY }
09:07:49 ata3: hard resetting link
09:07:49 ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
09:07:49 ata3.00: configured for UDMA/133
09:07:49 ata3: EH complete
09:07:49 sd 2:0:0:0: [sdc] 2930277168 512-byte hardware sectors (1500302 MB)
09:07:49 sd 2:0:0:0: [sdc] Write Protect is off
09:07:49 sd 2:0:0:0: [sdc] Mode Sense: 00 3a 00 00
09:07:49 sd 2:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
09:07:49 end_request: I/O error, dev sdc, sector 8
09:07:49 md: super_written gets error=-5, uptodate=0
09:07:49 raid5: Disk failure on sdc, disabling device.
09:07:49 raid5: Operation continuing on 1 devices.

For reference:

ata1: SATA max UDMA/133 abar m1024@0xf8fff800 port 0xf8fff900 irq 22
ata2: SATA max UDMA/133 abar m1024@0xf8fff800 port 0xf8fff980 irq 22
ata3: SATA max UDMA/133 abar m1024@0xf8fff800 port 0xf8fffa00 irq 22
ata4: SATA max UDMA/133 abar m1024@0xf8fff800 port 0xf8fffa80 irq 22
ata5: SATA max UDMA/133 abar m1024@0xf8fff800 port 0xf8fffb00 irq 22
ata6: SATA max UDMA/133 abar m1024@0xf8fff800 port 0xf8fffb80 irq 22
ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata1.00: HPA detected: current 2930277168, native 18446744072344861488
ata1.00: ATA-8: ST31500341AS, SD17, max UDMA/133
ata1.00: 2930277168 sectors, multi 16: LBA48 NCQ (depth 31/32)
ata1.00: configured for UDMA/133
ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata2.00: HPA detected: current 2930277168, native 18446744072344861488
ata2.00: ATA-8: ST31500341AS, SD17, max UDMA/133
ata2.00: 2930277168 sectors, multi 16: LBA48 NCQ (depth 31/32)
ata2.00: configured for UDMA/133
ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata3.00: HPA detected: current 2930277168, native 18446744072344861488
ata3.00: ATA-8: ST31500341AS, SD17, max UDMA/133
ata3.00: 2930277168 sectors, multi 16: LBA48 NCQ (depth 31/32)
ata3.00: configured for UDMA/133

Regards,

Oskar
