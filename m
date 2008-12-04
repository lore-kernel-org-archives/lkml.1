Return-Path: <linux-kernel-owner+w=401wt.eu-S1756871AbYLDUIP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756871AbYLDUIP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 15:08:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753761AbYLDUH5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 15:07:57 -0500
Received: from mail.atlantis.sk ([80.94.52.35]:36712 "EHLO mail.atlantis.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752652AbYLDUH4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 15:07:56 -0500
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Thu, 04 Dec 2008 15:07:55 EST
From: Ondrej Zary <linux@rainbow-software.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Random host bus errors with pata_it821x, filesystem corruption
Date: Thu, 4 Dec 2008 21:01:06 +0100
User-Agent: KMail/1.9.10
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812042101.08613.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,
I'm using IT8212F-based card with two Samsung HD400LD drives in cards' RAID1 mode.
It works fine most of the time, but sometimes the machine stalls for a while with HDD LED on.
The log contains errors like this then:

(syslog)
Nov 29 11:25:38 pentium kernel: ata3.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
Nov 29 11:25:38 pentium kernel: ata3.00: BMDMA stat 0x26
Nov 29 11:25:38 pentium kernel: ata3.00: cmd ca/00:08:ca:74:d0/00:00:00:00:00/e1 tag 0 dma 4096 out
Nov 29 11:25:38 pentium kernel:          res 51/00:01:01:00:00/00:00:00:00:00/00 Emask 0x21 (host bus error)
Nov 29 11:25:38 pentium kernel: ata3.00: status: { DRDY ERR }
Nov 29 16:09:40 pentium kernel: ata3.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
Nov 29 16:09:41 pentium kernel: ata3.00: BMDMA stat 0x26
Nov 29 16:09:41 pentium kernel: ata3.00: cmd ca/00:08:c2:f5:a7/00:00:00:00:00/e2 tag 0 dma 4096 out
Nov 29 16:09:41 pentium kernel:          res 51/04:01:01:00:00/00:00:00:00:00/00 Emask 0x21 (host bus error)
Nov 29 16:09:41 pentium kernel: ata3.00: status: { DRDY ERR }
Nov 29 16:09:41 pentium kernel: ata3.00: error: { ABRT }

(messages)
Nov 29 11:25:39 pentium kernel: ata3.00: RAID1 volume.
Nov 29 11:25:39 pentium kernel: ata3.00: configured for DMA
Nov 29 11:25:39 pentium kernel: ata3: EH complete
Nov 29 11:25:39 pentium kernel: sd 2:0:0:0: [sdb] 781422766 512-byte hardware sectors (400088 MB)
Nov 29 11:25:39 pentium kernel: sd 2:0:0:0: [sdb] Write Protect is off
Nov 29 11:25:39 pentium kernel: sd 2:0:0:0: [sdb] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
Nov 29 16:09:41 pentium kernel: ata3.00: RAID1 volume.
Nov 29 16:09:41 pentium kernel: ata3.00: configured for DMA
Nov 29 16:09:41 pentium kernel: ata3: EH complete
Nov 29 16:09:41 pentium kernel: sd 2:0:0:0: [sdb] 781422766 512-byte hardware sectors (400088 MB)
Nov 29 16:09:41 pentium kernel: sd 2:0:0:0: [sdb] Write Protect is off
Nov 29 16:09:41 pentium kernel: sd 2:0:0:0: [sdb] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA


or this:

(syslog)
Dec  3 21:30:41 pentium kernel: ata3.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
Dec  3 21:30:42 pentium kernel: ata3.00: BMDMA stat 0x26
Dec  3 21:30:42 pentium kernel: ata3.00: cmd ca/00:08:fa:0f:68/00:00:00:00:00/e1 tag 0 dma 4096 out
Dec  3 21:30:42 pentium kernel:          res 51/10:01:01:00:00/00:00:00:00:00/00 Emask 0xa1 (host bus error)
Dec  3 21:30:42 pentium kernel: ata3.00: status: { DRDY ERR }
Dec  3 21:30:42 pentium kernel: ata3.00: error: { IDNF }
Dec  3 21:30:42 pentium kernel: Descriptor sense data with sense descriptors (in hex):
Dec  3 21:30:42 pentium kernel: end_request: I/O error, dev sdb, sector 23597050
Dec  3 21:30:42 pentium kernel: Buffer I/O error on device sdb2, logical block 1901390
Dec  3 21:30:42 pentium kernel: lost page write due to I/O error on sdb2
Dec  3 21:30:49 pentium kernel: ata3.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
Dec  3 21:30:49 pentium kernel: ata3.00: BMDMA stat 0x26
Dec  3 21:30:49 pentium kernel: ata3.00: cmd ca/00:08:aa:41:d0/00:00:00:00:00/e1 tag 0 dma 4096 out
Dec  3 21:30:49 pentium kernel:          res 51/04:01:01:00:00/00:00:00:00:00/00 Emask 0x21 (host bus error)
Dec  3 21:30:49 pentium kernel: ata3.00: status: { DRDY ERR }
Dec  3 21:30:49 pentium kernel: ata3.00: error: { ABRT }
Dec  3 21:40:41 pentium kernel: ata3.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
Dec  3 21:40:41 pentium kernel: ata3.00: cmd ca/00:18:c2:2f:1e/00:00:00:00:00/e1 tag 0 dma 12288 out
Dec  3 21:40:41 pentium kernel:          res 40/00:01:01:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
Dec  3 21:40:41 pentium kernel: ata3.00: status: { DRDY }

(messages)
Dec  3 21:30:42 pentium kernel: ata3.00: RAID1 volume.
Dec  3 21:30:42 pentium kernel: ata3.00: configured for DMA
Dec  3 21:30:42 pentium kernel: sd 2:0:0:0: [sdb] Result: hostbyte=0x00 driverbyte=0x08
Dec  3 21:30:42 pentium kernel: sd 2:0:0:0: [sdb] Sense Key : 0xb [current] [descriptor]
Dec  3 21:30:42 pentium kernel:         72 0b 14 00 00 00 00 0c 00 0a 80 00 00 00 00 00
Dec  3 21:30:42 pentium kernel:         00 00 00 01
Dec  3 21:30:42 pentium kernel: sd 2:0:0:0: [sdb] ASC=0x14 ASCQ=0x0
Dec  3 21:30:42 pentium kernel: ata3: EH complete
Dec  3 21:30:42 pentium kernel: sd 2:0:0:0: [sdb] 781422766 512-byte hardware sectors (400088 MB)
Dec  3 21:30:42 pentium kernel: sd 2:0:0:0: [sdb] Write Protect is off
Dec  3 21:30:42 pentium kernel: sd 2:0:0:0: [sdb] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
Dec  3 21:30:50 pentium kernel: ata3.00: RAID1 volume.
Dec  3 21:30:50 pentium kernel: ata3.00: configured for DMA
Dec  3 21:30:50 pentium kernel: ata3: EH complete
Dec  3 21:30:50 pentium kernel: sd 2:0:0:0: [sdb] 781422766 512-byte hardware sectors (400088 MB)
Dec  3 21:30:50 pentium kernel: sd 2:0:0:0: [sdb] Write Protect is off
Dec  3 21:30:50 pentium kernel: sd 2:0:0:0: [sdb] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
Dec  3 21:40:41 pentium kernel: ata3: soft resetting link
Dec  3 21:40:42 pentium kernel: ata3.00: RAID1 volume.
Dec  3 21:40:42 pentium kernel: ata3.00: configured for DMA
Dec  3 21:40:42 pentium kernel: ata3: EH complete
Dec  3 21:40:42 pentium kernel: sd 2:0:0:0: [sdb] 781422766 512-byte hardware sectors (400088 MB)
Dec  3 21:40:42 pentium kernel: sd 2:0:0:0: [sdb] Write Protect is off
Dec  3 21:40:42 pentium kernel: sd 2:0:0:0: [sdb] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA



It even resulted in filesystem corruption once:

(syslog)
Dec  2 17:37:55 pentium kernel: ata3.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
Dec  2 17:37:56 pentium kernel: ata3.00: cmd ca/00:08:1a:f6:13/00:00:00:00:00/e1 tag 0 dma 4096 out
Dec  2 17:37:56 pentium kernel:          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
Dec  2 17:37:56 pentium kernel: ata3.00: status: { DRDY }
Dec  2 17:39:32 pentium kernel: EXT3-fs error (device sdb2): htree_dirblock_to_tree: bad entry in directory #945280: rec_len %% 4 != 0 - 
offset=12288, inode=862741792, rec_len=29535, name_len=116

(messages)
Dec  2 17:37:56 pentium kernel: ata3: soft resetting link
Dec  2 17:37:56 pentium kernel: ata3.00: RAID1 volume.
Dec  2 17:37:56 pentium kernel: ata3.00: configured for DMA
Dec  2 17:37:56 pentium kernel: ata3: EH complete
Dec  2 17:37:56 pentium kernel: sd 2:0:0:0: [sdb] 781422766 512-byte hardware sectors (400088 MB)
Dec  2 17:37:56 pentium kernel: sd 2:0:0:0: [sdb] Write Protect is off
Dec  2 17:37:56 pentium kernel: sd 2:0:0:0: [sdb] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA

Next day, fsck started on boot and found some errors.

I wonder what might cause these errors? I switched the controller into non-RAID mode and read SMART - both drives
are 100% OK (no pending or reallocated sectors, no errors logged).

-- 
Ondrej Zary
