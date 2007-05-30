Return-Path: <linux-kernel-owner+w=401wt.eu-S1753352AbXE3I1h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753352AbXE3I1h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 04:27:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751433AbXE3I1a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 04:27:30 -0400
Received: from linux.dunaweb.hu ([62.77.196.1]:38023 "EHLO linux.dunaweb.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1749667AbXE3I12 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 04:27:28 -0400
Message-ID: <465D355B.4030401@dunaweb.hu>
Date: Wed, 30 May 2007 10:27:07 +0200
From: Zoltan Boszormenyi <zboszor@dunaweb.hu>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: MCP55 NCQ problem?
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I just got this with 2.6.22-rc2 + cfs-v13 + swncq patch:

ata2.00: exception Emask 0x0 SAct 0x6 SErr 0x0 action 0x2 frozen
ata2.00: cmd 61/18:08:0f:b7:68/00:00:16:00:00/40 tag 1 cdb 0x0 data 
12288 out
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata2.00: cmd 61/18:10:7f:b7:68/00:00:16:00:00/40 tag 2 cdb 0x0 data 
12288 out
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata2: hard resetting port
ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata2.00: ata_hpa_resize 1: sectors = 625142448, hpa_sectors = 625142448
ata2.00: ata_hpa_resize 1: sectors = 625142448, hpa_sectors = 625142448
ata2.00: configured for UDMA/133
ata2: EH pending after completion, repeating EH (cnt=4)
ata2: EH complete
sd 1:0:0:0: [sdb] 625142448 512-byte hardware sectors (320073 MB)
sd 1:0:0:0: [sdb] Write Protect is off
sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't 
support DPO or FUA

At the time I was creating a DVD ISO image (reads and writes went to the 
disk
that was resetted), browsing mail in thunderbird which also exercised 
the same
disk and I was downloading another ISO with about 400-450 kB/sec to
another disk. Here are the disks in question:

scsi 0:0:0:0: Direct-Access     ATA      SAMSUNG HD160JJ  WU10 PQ: 0 ANSI: 5
scsi 1:0:0:0: Direct-Access     ATA      ST3320620AS      3.AA PQ: 0 ANSI: 5

I got almost the same yesterday with 2.6.22-rc2-mm1:

May 29 12:44:20 localhost kernel: ata2.00: exception Emask 0x0 SAct 0x6 
SErr 0x0 action 0x2 frozen
May 29 12:44:20 localhost kernel: ata2.00: cmd 
61/10:08:2f:41:e9/00:00:07:00:00/40 tag 1 cdb 0x0 data 8192 out
May 29 12:44:20 localhost kernel:          res 
40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
May 29 12:44:20 localhost kernel: ata2.00: status: {DRDY }
May 29 12:44:20 localhost kernel: ata2.00: cmd 
61/30:10:8f:42:e9/00:00:07:00:00/40 tag 2 cdb 0x0 data 24576 out
May 29 12:44:20 localhost kernel:          res 
40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
May 29 12:44:20 localhost kernel: ata2.00: status: {DRDY }
May 29 12:44:20 localhost kernel: ata2: hard resetting port
May 29 12:44:21 localhost kernel: ata2: SATA link up 1.5 Gbps (SStatus 
113 SControl 300)
May 29 12:44:21 localhost kernel: ata2.00: ata_hpa_resize: sectors = 
625142448, hpa_sectors = 625142448
May 29 12:44:21 localhost kernel: ata2.00: ata_hpa_resize: sectors = 
625142448, hpa_sectors = 625142448
May 29 12:44:21 localhost kernel: ata2.00: configured for UDMA/133
May 29 12:44:21 localhost kernel: ata2: EH pending after completion, 
repeating EH (cnt=4)
May 29 12:44:21 localhost kernel: ata2: EH complete
May 29 12:44:21 localhost kernel: sd 1:0:0:0: [sdb] 625142448 512-byte 
hardware sectors (320073 MB)
May 29 12:44:21 localhost kernel: sd 1:0:0:0: [sdb] Write Protect is off
May 29 12:44:21 localhost kernel: sd 1:0:0:0: [sdb] Write cache: 
enabled, read cache: enabled, doesn't support DPO or FUA
...
May 29 12:47:46 localhost kernel: ata2.00: exception Emask 0x0 SAct 0x7 
SErr 0x0 action 0x2 frozen
May 29 12:47:46 localhost kernel: ata2.00: cmd 
61/08:00:27:5a:eb/00:00:07:00:00/40 tag 0 cdb 0x0 data 4096 out
May 29 12:47:46 localhost kernel:          res 
40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
May 29 12:47:46 localhost kernel: ata2.00: status: {DRDY }
May 29 12:47:46 localhost kernel: ata2.00: cmd 
61/08:08:bf:61:9e/00:00:0f:00:00/40 tag 1 cdb 0x0 data 4096 out
May 29 12:47:46 localhost kernel:          res 
40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
May 29 12:47:46 localhost kernel: ata2.00: status: {DRDY }
May 29 12:47:46 localhost kernel: ata2.00: cmd 
61/20:10:97:5a:eb/00:00:07:00:00/40 tag 2 cdb 0x0 data 16384 out
May 29 12:47:46 localhost kernel:          res 
40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
May 29 12:47:46 localhost kernel: ata2.00: status: {DRDY }
May 29 12:47:46 localhost kernel: ata2: hard resetting port
May 29 12:47:46 localhost kernel: ata2: SATA link up 1.5 Gbps (SStatus 
113 SControl 300)
May 29 12:47:46 localhost kernel: ata2.00: ata_hpa_resize: sectors = 
625142448, hpa_sectors = 625142448
May 29 12:47:46 localhost kernel: ata2.00: ata_hpa_resize: sectors = 
625142448, hpa_sectors = 625142448
May 29 12:47:47 localhost kernel: ata2.00: configured for UDMA/133
May 29 12:47:47 localhost kernel: ata2: EH pending after completion, 
repeating EH (cnt=4)
May 29 12:47:47 localhost kernel: ata2: EH complete
May 29 12:47:47 localhost kernel: sd 1:0:0:0: [sdb] 625142448 512-byte 
hardware sectors (320073 MB)
May 29 12:47:47 localhost kernel: sd 1:0:0:0: [sdb] Write Protect is off
May 29 12:47:47 localhost kernel: sd 1:0:0:0: [sdb] Write cache: 
enabled, read cache: enabled, doesn't support DPO or FUA
May 29 12:49:23 localhost kernel: ata2.00: exception Emask 0x0 SAct 0x6 
SErr 0x2000000 action 0x2 frozen
May 29 12:49:23 localhost kernel: ata2: SError: {UnrecFIS }
May 29 12:49:23 localhost kernel: ata2.00: cmd 
61/40:08:3f:71:fa/00:00:07:00:00/40 tag 1 cdb 0x0 data 32768 out
May 29 12:49:23 localhost kernel:          res 
40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
May 29 12:49:23 localhost kernel: ata2.00: status: {DRDY }
May 29 12:49:23 localhost kernel: ata2.00: cmd 
61/10:10:7f:e7:fa/00:00:07:00:00/40 tag 2 cdb 0x0 data 8192 out
May 29 12:49:23 localhost kernel:          res 
40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
May 29 12:49:23 localhost kernel: ata2.00: status: {DRDY }
May 29 12:49:23 localhost kernel: ata2: hard resetting port
May 29 12:49:24 localhost kernel: ata2: SATA link up 1.5 Gbps (SStatus 
113 SControl 300)
May 29 12:49:24 localhost kernel: ata2.00: ata_hpa_resize: sectors = 
625142448, hpa_sectors = 625142448
May 29 12:49:24 localhost kernel: ata2.00: ata_hpa_resize: sectors = 
625142448, hpa_sectors = 625142448
May 29 12:49:24 localhost kernel: ata2.00: configured for UDMA/133
May 29 12:49:24 localhost kernel: ata2: EH pending after completion, 
repeating EH (cnt=4)
May 29 12:49:24 localhost kernel: ata2: EH complete
May 29 12:49:24 localhost kernel: sd 1:0:0:0: [sdb] 625142448 512-byte 
hardware sectors (320073 MB)
May 29 12:49:24 localhost kernel: sd 1:0:0:0: [sdb] Write Protect is off
May 29 12:49:24 localhost kernel: sd 1:0:0:0: [sdb] Write cache: 
enabled, read cache: enabled, doesn't support DPO or FUA
May 29 12:50:24 localhost kernel: ata2.00: NCQ disabled due to excessive 
errors
May 29 12:50:24 localhost kernel: ata2.00: exception Emask 0x0 SAct 0x6 
SErr 0x0 action 0x2 frozen
May 29 12:50:24 localhost kernel: ata2.00: cmd 
61/10:08:c7:88:b8/00:00:0f:00:00/40 tag 1 cdb 0x0 data 8192 out
May 29 12:50:24 localhost kernel:          res 
40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
May 29 12:50:24 localhost kernel: ata2.00: status: {DRDY }
May 29 12:50:24 localhost kernel: ata2.00: cmd 
61/10:10:9f:8a:b8/00:00:0f:00:00/40 tag 2 cdb 0x0 data 8192 out
May 29 12:50:24 localhost kernel:          res 
40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
May 29 12:50:24 localhost kernel: ata2.00: status: {DRDY }
May 29 12:50:24 localhost kernel: ata2: hard resetting port
May 29 12:50:25 localhost kernel: ata2: SATA link up 1.5 Gbps (SStatus 
113 SControl 300)
May 29 12:50:25 localhost kernel: ata2.00: ata_hpa_resize: sectors = 
625142448, hpa_sectors = 625142448
May 29 12:50:25 localhost kernel: ata2.00: ata_hpa_resize: sectors = 
625142448, hpa_sectors = 625142448
May 29 12:50:25 localhost kernel: ata2.00: configured for UDMA/133
May 29 12:50:25 localhost kernel: ata2: EH pending after completion, 
repeating EH (cnt=4)
May 29 12:50:25 localhost kernel: ata2: EH complete
May 29 12:50:25 localhost kernel: sd 1:0:0:0: [sdb] 625142448 512-byte 
hardware sectors (320073 MB)
May 29 12:50:25 localhost kernel: sd 1:0:0:0: [sdb] Write Protect is off
May 29 12:50:25 localhost kernel: sd 1:0:0:0: [sdb] Write cache: 
enabled, read cache: enabled, doesn't support DPO or FUA

After the system disabled NCQ there weren't any more more ata resets
and the disks were working OK.

Strange thing is, when I have run PostgreSQL pgbench with 25 clients
on 2.6.22-rc2 + cfs-v13 + swncq (which clearly showed advanced transfer 
rate)
I had no such problems. The PostgreSQL DB was also on ata2.00.

Best regards,
Zoltán Böszörményi

