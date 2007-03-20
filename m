Return-Path: <linux-kernel-owner+w=401wt.eu-S933834AbXCTUzf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933834AbXCTUzf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 16:55:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753900AbXCTUzf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 16:55:35 -0400
Received: from hoppetossa.avesi.com ([208.239.169.21]:35725 "HELO
	hoppetossa.avesi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753898AbXCTUzb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 16:55:31 -0400
X-Greylist: delayed 395 seconds by postgrey-1.27 at vger.kernel.org; Tue, 20 Mar 2007 16:55:30 EDT
Message-ID: <460048BA.2050305@avesi.com>
Date: Tue, 20 Mar 2007 16:48:58 -0400
From: Christopher Mulcahy <cmulcahy@avesi.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20070104)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: sata_nv  exceptions  in 2.6.20.3
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


My harddrives are Seagate Barracudas ( 7200.10, 500GB, ST3500630AS )

They have jumpers to toggle between 1.5Gb/s operation and 3.0Gb/s operation.

When jumpered to 1.5Gbs operation, there are no problems.

Settings the drives to 3.0Gbs operation generates exceptions on only one 
of the 4 drives, but this quickly leads to hard lock-up.  ( I don't see 
a kernel crash-dump, but the system becomes frozen and has to be reset )

The errors, lspci output, and dmesg from both 3G ( broken ) and 1.5G 
(working) operation are as follows:



ERRORS:

instance #1:

Mar 20 14:45:46 mesa kernel: ata4: exception Emask 0x10 SAct 0x0 SErr 
0x150000 action 0x2 frozen
Mar 20 14:45:46 mesa kernel: ata4: soft resetting port
Mar 20 14:45:53 mesa kernel: ata4: port is slow to respond, please be 
patient (Status 0x80)
Mar 20 14:45:56 mesa kernel: ata4: SATA link up 3.0 Gbps (SStatus 123 
SControl 300)
Mar 20 14:45:56 mesa kernel: ata4.00: ATA-7, max UDMA/133, 976773168 
sectors: LBA48 NCQ (depth 31/32)
Mar 20 14:45:56 mesa kernel: ata4.00: configured for UDMA/133
Mar 20 14:45:56 mesa kernel: ata4: EH pending after completion, 
repeating EH (cnt=4)
Mar 20 14:45:56 mesa kernel: ata4: EH complete
Mar 20 14:45:56 mesa kernel: scsi 3:0:0:0: Direct-Access     ATA      
ST3500630AS      3.AA PQ: 0 ANSI: 5
Mar 20 14:45:56 mesa kernel: ata4: bounce limit 0xFFFFFFFFFFFFFFFF, 
segment boundary 0xFFFFFFFF, hw segs 61
Mar 20 14:45:56 mesa kernel: SCSI device sdd: 976773168 512-byte hdwr 
sectors (500108 MB)
Mar 20 14:45:56 mesa kernel: sdd: Write Protect is off
Mar 20 14:45:56 mesa kernel: sdd: Mode Sense: 00 3a 00 00
Mar 20 14:45:56 mesa kernel: SCSI device sdd: write cache: enabled, read 
cache: enabled, doesn't support DPO or FUA
Mar 20 14:45:56 mesa kernel: SCSI device sdd: 976773168 512-byte hdwr 
sectors (500108 MB)
Mar 20 14:45:56 mesa kernel: sdd: Write Protect is off
Mar 20 14:45:56 mesa kernel: sdd: Mode Sense: 00 3a 00 00
Mar 20 14:45:56 mesa kernel: SCSI device sdd: write cache: enabled, read 
cache: enabled, doesn't support DPO or FUA
Mar 20 14:45:56 mesa kernel:  sdd: unknown partition table
Mar 20 14:45:56 mesa kernel: sd 3:0:0:0: Attached scsi disk sdd
Mar 20 14:45:56 mesa kernel: sd 3:0:0:0: Attached scsi generic sg3 type 0

// Hard Lockup //



instance #2:

Mar 20 14:54:06 mesa kernel: ata4: CPB flags CMD err, flags=0x11
Mar 20 14:54:36 mesa kernel: ata4: EH in ADMA mode, notifier 0x0 
notifier_error 0x0 gen_ctl 0x1501000 status 0x400
Mar 20 14:54:37 mesa kernel: ata4: CPB 0: ctl_flags 0x1f, resp_flags 0x11
Mar 20 14:54:37 mesa kernel: ata4: CPB 1: ctl_flags 0x1f, resp_flags 0x0
Mar 20 14:54:37 mesa kernel: ata4: CPB 2: ctl_flags 0x1f, resp_flags 0x0
Mar 20 14:54:37 mesa kernel: ata4: CPB 3: ctl_flags 0x1f, resp_flags 0x0
Mar 20 14:54:37 mesa kernel: ata4: CPB 4: ctl_flags 0x1f, resp_flags 0x0
Mar 20 14:54:37 mesa kernel: ata4: CPB 5: ctl_flags 0x1f, resp_flags 0x0
Mar 20 14:54:37 mesa kernel: ata4: CPB 6: ctl_flags 0x1f, resp_flags 0x0
Mar 20 14:54:37 mesa kernel: ata4: CPB 7: ctl_flags 0x1f, resp_flags 0x0
Mar 20 14:54:37 mesa kernel: ata4: CPB 8: ctl_flags 0x1f, resp_flags 0x0
Mar 20 14:54:37 mesa kernel: ata4: CPB 9: ctl_flags 0x1f, resp_flags 0x0
Mar 20 14:54:37 mesa kernel: ata4: CPB 10: ctl_flags 0x1f, resp_flags 0x0
Mar 20 14:54:37 mesa kernel: ata4: CPB 11: ctl_flags 0x1f, resp_flags 0x0
Mar 20 14:54:37 mesa kernel: ata4: CPB 12: ctl_flags 0x1f, resp_flags 0x0
Mar 20 14:54:37 mesa kernel: ata4: CPB 13: ctl_flags 0x1f, resp_flags 0x0
Mar 20 14:54:37 mesa kernel: ata4: CPB 14: ctl_flags 0x1f, resp_flags 0x0
Mar 20 14:54:37 mesa kernel: ata4: CPB 15: ctl_flags 0x1f, resp_flags 0x0
Mar 20 14:54:37 mesa kernel: ata4: CPB 16: ctl_flags 0x1f, resp_flags 0x0
Mar 20 14:54:37 mesa kernel: ata4: CPB 17: ctl_flags 0x1f, resp_flags 0x0
Mar 20 14:54:37 mesa kernel: ata4: CPB 18: ctl_flags 0x1f, resp_flags 0x0
Mar 20 14:54:37 mesa kernel: ata4: CPB 19: ctl_flags 0x1f, resp_flags 0x0
Mar 20 14:54:37 mesa kernel: ata4: CPB 20: ctl_flags 0x1f, resp_flags 0x0
Mar 20 14:54:37 mesa kernel: ata4: CPB 21: ctl_flags 0x1f, resp_flags 0x0
Mar 20 14:54:37 mesa kernel: ata4: CPB 22: ctl_flags 0x1f, resp_flags 0x0
Mar 20 14:54:37 mesa kernel: ata4: CPB 23: ctl_flags 0x1f, resp_flags 0x0
Mar 20 14:54:37 mesa kernel: ata4: CPB 24: ctl_flags 0x1f, resp_flags 0x0
Mar 20 14:54:37 mesa kernel: ata4: CPB 25: ctl_flags 0x1f, resp_flags 0x0
Mar 20 14:54:37 mesa kernel: ata4: CPB 26: ctl_flags 0x1f, resp_flags 0x0
Mar 20 14:54:37 mesa kernel: ata4: CPB 27: ctl_flags 0x1f, resp_flags 0x0
Mar 20 14:54:37 mesa kernel: ata4: CPB 28: ctl_flags 0x1f, resp_flags 0x0
Mar 20 14:54:37 mesa kernel: ata4: CPB 29: ctl_flags 0x1f, resp_flags 0x0
Mar 20 14:54:37 mesa kernel: ata4: CPB 30: ctl_flags 0x1f, resp_flags 0x0
Mar 20 14:54:37 mesa kernel: ata4: Resetting port
Mar 20 14:54:37 mesa kernel: ata4.00: exception Emask 0x0 SAct 
0x7fffffff SErr 0x400000 action 0x2 frozen
Mar 20 14:54:37 mesa kernel: ata4.00: cmd 
61/80:00:bf:9a:38/00:00:00:00:00/40 tag 0 cdb 0x0 data 65536 out
Mar 20 14:54:37 mesa kernel:          res 
41/00:00:bf:9a:38/00:00:00:00:00/40 Emask 0x1 (device error)
Mar 20 14:54:37 mesa kernel: ata4.00: cmd 
61/80:08:3f:9b:38/00:00:00:00:00/40 tag 1 cdb 0x0 data 65536 out
Mar 20 14:54:37 mesa kernel:          res 
40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
Mar 20 14:54:37 mesa kernel: ata4.00: cmd 
61/80:10:bf:9b:38/00:00:00:00:00/40 tag 2 cdb 0x0 data 65536 out
Mar 20 14:54:37 mesa kernel:          res 
40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
Mar 20 14:54:37 mesa kernel: ata4.00: cmd 
61/80:18:3f:9c:38/00:00:00:00:00/40 tag 3 cdb 0x0 data 65536 out
Mar 20 14:54:37 mesa kernel:          res 
40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
Mar 20 14:54:37 mesa kernel: ata4.00: cmd 
61/80:20:bf:9c:38/00:00:00:00:00/40 tag 4 cdb 0x0 data 65536 out
Mar 20 14:54:37 mesa kernel:          res 
40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
Mar 20 14:54:37 mesa kernel: ata4.00: cmd 
61/80:28:3f:9d:38/00:00:00:00:00/40 tag 5 cdb 0x0 data 65536 out
Mar 20 14:54:37 mesa kernel:          res 
40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
Mar 20 14:54:37 mesa kernel: ata4.00: cmd 
61/80:30:bf:9d:38/00:00:00:00:00/40 tag 6 cdb 0x0 data 65536 out
Mar 20 14:54:37 mesa kernel:          res 
40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
Mar 20 14:54:37 mesa kernel: ata4.00: cmd 
61/80:38:3f:9e:38/00:00:00:00:00/40 tag 7 cdb 0x0 data 65536 out
Mar 20 14:54:37 mesa kernel:          res 
40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
Mar 20 14:54:37 mesa kernel: ata4.00: cmd 
61/80:40:bf:9e:38/00:00:00:00:00/40 tag 8 cdb 0x0 data 65536 out
Mar 20 14:54:37 mesa kernel:          res 
40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
Mar 20 14:54:37 mesa kernel: ata4.00: cmd 
61/80:48:3f:9f:38/00:00:00:00:00/40 tag 9 cdb 0x0 data 65536 out
Mar 20 14:54:37 mesa kernel:          res 
40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
Mar 20 14:54:37 mesa kernel: ata4.00: cmd 
61/80:50:bf:9f:38/00:00:00:00:00/40 tag 10 cdb 0x0 data 65536 out
Mar 20 14:54:37 mesa kernel:          res 
40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
Mar 20 14:54:37 mesa kernel: ata4.00: cmd 
61/80:58:3f:a0:38/00:00:00:00:00/40 tag 11 cdb 0x0 data 65536 out
Mar 20 14:54:37 mesa kernel:          res 
40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
Mar 20 14:54:37 mesa kernel: ata4.00: cmd 
61/80:60:bf:a0:38/00:00:00:00:00/40 tag 12 cdb 0x0 data 65536 out
Mar 20 14:54:37 mesa kernel:          res 
40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
Mar 20 14:54:37 mesa kernel: ata4.00: cmd 
61/80:68:3f:a1:38/00:00:00:00:00/40 tag 13 cdb 0x0 data 65536 out
Mar 20 14:54:37 mesa kernel:          res 
40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
Mar 20 14:54:37 mesa kernel: ata4.00: cmd 
61/80:70:bf:a1:38/00:00:00:00:00/40 tag 14 cdb 0x0 data 65536 out
Mar 20 14:54:37 mesa kernel:          res 
40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
Mar 20 14:54:37 mesa kernel: ata4.00: cmd 
61/80:78:3f:a2:38/00:00:00:00:00/40 tag 15 cdb 0x0 data 65536 out
Mar 20 14:54:37 mesa kernel:          res 
40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
Mar 20 14:54:37 mesa kernel: ata4.00: cmd 
61/80:80:bf:a2:38/00:00:00:00:00/40 tag 16 cdb 0x0 data 65536 out
Mar 20 14:54:37 mesa kernel:          res 
40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
Mar 20 14:54:37 mesa kernel: ata4.00: cmd 
61/80:88:3f:a3:38/00:00:00:00:00/40 tag 17 cdb 0x0 data 65536 out
Mar 20 14:54:37 mesa kernel:          res 
40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
Mar 20 14:54:37 mesa kernel: ata4.00: cmd 
61/80:90:bf:a3:38/00:00:00:00:00/40 tag 18 cdb 0x0 data 65536 out
Mar 20 14:54:37 mesa kernel:          res 
40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
Mar 20 14:54:37 mesa kernel: ata4.00: cmd 
61/80:98:3f:a4:38/00:00:00:00:00/40 tag 19 cdb 0x0 data 65536 out
Mar 20 14:54:37 mesa kernel:          res 
40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
Mar 20 14:54:37 mesa kernel: ata4.00: cmd 
61/80:a0:bf:a4:38/00:00:00:00:00/40 tag 20 cdb 0x0 data 65536 out
Mar 20 14:54:37 mesa kernel:          res 
40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
Mar 20 14:54:37 mesa kernel: ata4.00: cmd 
61/80:a8:3f:a5:38/00:00:00:00:00/40 tag 21 cdb 0x0 data 65536 out
Mar 20 14:54:37 mesa kernel:          res 
40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
Mar 20 14:54:37 mesa kernel: ata4.00: cmd 
61/80:b0:bf:a5:38/00:00:00:00:00/40 tag 22 cdb 0x0 data 65536 out
Mar 20 14:54:37 mesa kernel:          res 
40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
Mar 20 14:54:37 mesa kernel: ata4.00: cmd 
61/80:b8:3f:a6:38/00:00:00:00:00/40 tag 23 cdb 0x0 data 65536 out
Mar 20 14:54:37 mesa kernel:          res 
40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
Mar 20 14:54:37 mesa kernel: ata4.00: cmd 
61/80:c0:bf:a6:38/00:00:00:00:00/40 tag 24 cdb 0x0 data 65536 out
Mar 20 14:54:37 mesa kernel:          res 
40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
Mar 20 14:54:37 mesa kernel: ata4.00: cmd 
61/80:c8:3f:a7:38/00:00:00:00:00/40 tag 25 cdb 0x0 data 65536 out
Mar 20 14:54:37 mesa kernel:          res 
40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
Mar 20 14:54:37 mesa kernel: ata4.00: cmd 
61/80:d0:bf:a7:38/00:00:00:00:00/40 tag 26 cdb 0x0 data 65536 out
Mar 20 14:54:37 mesa kernel:          res 
40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
Mar 20 14:54:37 mesa kernel: ata4.00: cmd 
61/80:d8:3f:a8:38/00:00:00:00:00/40 tag 27 cdb 0x0 data 65536 out
Mar 20 14:54:37 mesa kernel:          res 
40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
Mar 20 14:54:37 mesa kernel: ata4.00: cmd 
61/80:e0:bf:a8:38/00:00:00:00:00/40 tag 28 cdb 0x0 data 65536 out
Mar 20 14:54:37 mesa kernel:          res 
40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
Mar 20 14:54:37 mesa kernel: ata4.00: cmd 
61/80:e8:3f:a9:38/00:00:00:00:00/40 tag 29 cdb 0x0 data 65536 out
Mar 20 14:54:37 mesa kernel:          res 
40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
Mar 20 14:54:37 mesa kernel: ata4.00: cmd 
61/80:f0:bf:a9:38/00:00:00:00:00/40 tag 30 cdb 0x0 data 65536 out
Mar 20 14:54:37 mesa kernel:          res 
40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
Mar 20 14:54:37 mesa kernel: ata4: soft resetting port
Mar 20 14:54:37 mesa kernel: ata4: SATA link up 3.0 Gbps (SStatus 123 
SControl 300)
Mar 20 14:54:37 mesa kernel: ata4.00: configured for UDMA/133
Mar 20 14:54:37 mesa kernel: ata4: EH complete
Mar 20 14:54:37 mesa kernel: SCSI device sdd: 976773168 512-byte hdwr 
sectors (500108 MB)
Mar 20 14:54:37 mesa kernel: sdd: Write Protect is off
Mar 20 14:54:37 mesa kernel: sdd: Mode Sense: 00 3a 00 00
Mar 20 14:54:37 mesa kernel: SCSI device sdd: write cache: enabled, read 
cache: enabled, doesn't support DPO or FUA
Mar 20 14:56:32 mesa kernel: ata4: CPB flags CMD err, flags=0x11
Mar 20 14:57:02 mesa kernel: ata4: EH in ADMA mode, notifier 0x0 
notifier_error 0x0 gen_ctl 0x1501000 status 0x400
Mar 20 14:57:02 mesa kernel: ata4: CPB 0: ctl_flags 0x1f, resp_flags 0x2
Mar 20 14:57:02 mesa kernel: ata4: CPB 1: ctl_flags 0x1f, resp_flags 0x2
Mar 20 14:57:02 mesa kernel: ata4: CPB 2: ctl_flags 0x1f, resp_flags 0x2
Mar 20 14:57:02 mesa kernel: ata4: CPB 3: ctl_flags 0x1f, resp_flags 0x2
Mar 20 14:57:02 mesa kernel: ata4: CPB 4: ctl_flags 0x1f, resp_flags 0x2
Mar 20 14:57:02 mesa kernel: ata4: CPB 5: ctl_flags 0x1f, resp_flags 0x2
Mar 20 14:57:02 mesa kernel: ata4: CPB 6: ctl_flags 0x1f, resp_flags 0x2
Mar 20 14:57:02 mesa kernel: ata4: CPB 7: ctl_flags 0x1f, resp_flags 0x2
Mar 20 14:57:02 mesa kernel: ata4: CPB 8: ctl_flags 0x1f, resp_flags 0x2
Mar 20 14:57:02 mesa kernel: ata4: CPB 9: ctl_flags 0x1f, resp_flags 0x2
Mar 20 14:57:02 mesa kernel: ata4: CPB 10: ctl_flags 0x1f, resp_flags 0x2
Mar 20 14:57:02 mesa kernel: ata4: CPB 11: ctl_flags 0x1f, resp_flags 0x2
Mar 20 14:57:02 mesa kernel: ata4: CPB 12: ctl_flags 0x1f, resp_flags 0x2
Mar 20 14:57:02 mesa kernel: ata4: CPB 13: ctl_flags 0x1f, resp_flags 0x2
Mar 20 14:57:02 mesa kernel: ata4: CPB 14: ctl_flags 0x1f, resp_flags 0x2
Mar 20 14:57:02 mesa kernel: ata4: CPB 15: ctl_flags 0x1f, resp_flags 0x2
Mar 20 14:57:02 mesa kernel: ata4: CPB 16: ctl_flags 0x1f, resp_flags 0x2
Mar 20 14:57:02 mesa kernel: ata4: CPB 17: ctl_flags 0x1f, resp_flags 0x0
Mar 20 14:57:02 mesa kernel: ata4: CPB 18: ctl_flags 0x1f, resp_flags 0x11
Mar 20 14:57:02 mesa kernel: ata4: CPB 19: ctl_flags 0x1f, resp_flags 0x2
Mar 20 14:57:02 mesa kernel: ata4: CPB 20: ctl_flags 0x1f, resp_flags 0x2
Mar 20 14:57:02 mesa kernel: ata4: CPB 21: ctl_flags 0x1f, resp_flags 0x2
Mar 20 14:57:02 mesa kernel: ata4: CPB 22: ctl_flags 0x1f, resp_flags 0x2
Mar 20 14:57:02 mesa kernel: ata4: CPB 23: ctl_flags 0x1f, resp_flags 0x2
Mar 20 14:57:02 mesa kernel: ata4: CPB 24: ctl_flags 0x1f, resp_flags 0x2
Mar 20 14:57:02 mesa kernel: ata4: CPB 25: ctl_flags 0x1f, resp_flags 0x2
Mar 20 14:57:02 mesa kernel: ata4: CPB 26: ctl_flags 0x1f, resp_flags 0x2
Mar 20 14:57:02 mesa kernel: ata4: CPB 27: ctl_flags 0x1f, resp_flags 0x2
Mar 20 14:57:02 mesa kernel: ata4: CPB 28: ctl_flags 0x1f, resp_flags 0x2
Mar 20 14:57:02 mesa kernel: ata4: CPB 29: ctl_flags 0x1f, resp_flags 0x2
Mar 20 14:57:02 mesa kernel: ata4: CPB 30: ctl_flags 0x1f, resp_flags 0x2
Mar 20 14:57:02 mesa kernel: ata4: Resetting port
Mar 20 14:57:02 mesa kernel: ata4.00: exception Emask 0x0 SAct 
0x7fffffff SErr 0x400000 action 0x2 frozen
Mar 20 14:57:02 mesa kernel: ata4.00: cmd 
61/80:00:3f:86:29/00:00:01:00:00/40 tag 0 cdb 0x0 data 65536 out
Mar 20 14:57:02 mesa kernel:          res 
40/00:00:bf:9a:38/00:00:00:00:00/40 Emask 0x4 (timeout)
Mar 20 14:57:02 mesa kernel: ata4.00: cmd 
61/80:08:bf:7a:29/00:00:01:00:00/40 tag 1 cdb 0x0 data 65536 out
Mar 20 14:57:02 mesa kernel:          res 
40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
Mar 20 14:57:02 mesa kernel: ata4.00: cmd 
61/80:10:3f:7b:29/00:00:01:00:00/40 tag 2 cdb 0x0 data 65536 out
Mar 20 14:57:02 mesa kernel:          res 
40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
Mar 20 14:57:02 mesa kernel: ata4.00: cmd 
61/80:18:bf:7d:29/00:00:01:00:00/40 tag 3 cdb 0x0 data 65536 out
Mar 20 14:57:02 mesa kernel:          res 
40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
Mar 20 14:57:02 mesa kernel: ata4.00: cmd 
61/80:20:bf:7e:29/00:00:01:00:00/40 tag 4 cdb 0x0 data 65536 out
Mar 20 14:57:02 mesa kernel:          res 
40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
Mar 20 14:57:02 mesa kernel: ata4.00: cmd 
61/80:28:3f:81:29/00:00:01:00:00/40 tag 5 cdb 0x0 data 65536 out
Mar 20 14:57:02 mesa kernel:          res 
40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
Mar 20 14:57:02 mesa kernel: ata4.00: cmd 
61/80:30:bf:81:29/00:00:01:00:00/40 tag 6 cdb 0x0 data 65536 out
Mar 20 14:57:02 mesa kernel:          res 
40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
Mar 20 14:57:02 mesa kernel: ata4.00: cmd 
61/80:38:bf:7b:29/00:00:01:00:00/40 tag 7 cdb 0x0 data 65536 out
Mar 20 14:57:02 mesa kernel:          res 
40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
Mar 20 14:57:02 mesa kernel: ata4.00: cmd 
61/80:40:3f:7c:29/00:00:01:00:00/40 tag 8 cdb 0x0 data 65536 out
Mar 20 14:57:02 mesa kernel:          res 
40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
Mar 20 14:57:02 mesa kernel: ata4.00: cmd 
61/80:48:bf:7c:29/00:00:01:00:00/40 tag 9 cdb 0x0 data 65536 out
Mar 20 14:57:02 mesa kernel:          res 
40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
Mar 20 14:57:02 mesa kernel: ata4.00: cmd 
61/80:50:3f:82:29/00:00:01:00:00/40 tag 10 cdb 0x0 data 65536 out
Mar 20 14:57:02 mesa kernel:          res 
40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
Mar 20 14:57:02 mesa kernel: ata4.00: cmd 
61/80:58:bf:82:29/00:00:01:00:00/40 tag 11 cdb 0x0 data 65536 out
Mar 20 14:57:02 mesa kernel:          res 
40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
Mar 20 14:57:02 mesa kernel: ata4.00: cmd 
61/80:60:3f:83:29/00:00:01:00:00/40 tag 12 cdb 0x0 data 65536 out
Mar 20 14:57:02 mesa kernel:          res 
40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
Mar 20 14:57:02 mesa kernel: ata4.00: cmd 
61/80:68:3f:84:29/00:00:01:00:00/40 tag 13 cdb 0x0 data 65536 out
Mar 20 14:57:02 mesa kernel:          res 
40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
Mar 20 14:57:02 mesa kernel: ata4.00: cmd 
61/80:70:bf:84:29/00:00:01:00:00/40 tag 14 cdb 0x0 data 65536 out
Mar 20 14:57:02 mesa kernel:          res 
40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
Mar 20 14:57:02 mesa kernel: ata4.00: cmd 
61/80:78:bf:86:29/00:00:01:00:00/40 tag 15 cdb 0x0 data 65536 out
Mar 20 14:57:02 mesa kernel:          res 
40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
Mar 20 14:57:02 mesa kernel: ata4.00: cmd 
61/80:80:3f:87:29/00:00:01:00:00/40 tag 16 cdb 0x0 data 65536 out
Mar 20 14:57:02 mesa kernel:          res 
40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
Mar 20 14:57:02 mesa kernel: ata4.00: cmd 
61/80:88:3f:88:29/00:00:01:00:00/40 tag 17 cdb 0x0 data 65536 out
Mar 20 14:57:02 mesa kernel:          res 
40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
Mar 20 14:57:02 mesa kernel: ata4.00: cmd 
61/80:90:3f:79:29/00:00:01:00:00/40 tag 18 cdb 0x0 data 65536 out
Mar 20 14:57:02 mesa kernel:          res 
41/00:e0:bf:87:29/00:00:00:00:00/40 Emask 0x1 (device error)
Mar 20 14:57:02 mesa kernel: ata4.00: cmd 
61/80:98:bf:79:29/00:00:01:00:00/40 tag 19 cdb 0x0 data 65536 out
Mar 20 14:57:02 mesa kernel:          res 
40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
Mar 20 14:57:02 mesa kernel: ata4.00: cmd 
61/80:a0:3f:7d:29/00:00:01:00:00/40 tag 20 cdb 0x0 data 65536 out
Mar 20 14:57:02 mesa kernel:          res 
40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
Mar 20 14:57:02 mesa kernel: ata4.00: cmd 
61/80:a8:3f:7e:29/00:00:01:00:00/40 tag 21 cdb 0x0 data 65536 out
Mar 20 14:57:02 mesa kernel:          res 
40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
Mar 20 14:57:02 mesa kernel: ata4.00: cmd 
61/80:b0:bf:83:29/00:00:01:00:00/40 tag 22 cdb 0x0 data 65536 out
Mar 20 14:57:02 mesa kernel:          res 
40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
Mar 20 14:57:02 mesa kernel: ata4.00: cmd 
61/80:b8:3f:7f:29/00:00:01:00:00/40 tag 23 cdb 0x0 data 65536 out
Mar 20 14:57:02 mesa kernel:          res 
40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
Mar 20 14:57:02 mesa kernel: ata4.00: cmd 
61/80:c0:bf:7f:29/00:00:01:00:00/40 tag 24 cdb 0x0 data 65536 out
Mar 20 14:57:02 mesa kernel:          res 
40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
Mar 20 14:57:02 mesa kernel: ata4.00: cmd 
61/80:c8:bf:80:29/00:00:01:00:00/40 tag 25 cdb 0x0 data 65536 out
Mar 20 14:57:02 mesa kernel:          res 
40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
Mar 20 14:57:02 mesa kernel: ata4.00: cmd 
61/80:d0:3f:85:29/00:00:01:00:00/40 tag 26 cdb 0x0 data 65536 out
Mar 20 14:57:02 mesa kernel:          res 
40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
Mar 20 14:57:02 mesa kernel: ata4.00: cmd 
61/80:d8:bf:85:29/00:00:01:00:00/40 tag 27 cdb 0x0 data 65536 out
Mar 20 14:57:02 mesa kernel:          res 
40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
Mar 20 14:57:02 mesa kernel: ata4.00: cmd 
61/80:e0:bf:87:29/00:00:01:00:00/40 tag 28 cdb 0x0 data 65536 out
Mar 20 14:57:02 mesa kernel:          res 
40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
Mar 20 14:57:02 mesa kernel: ata4.00: cmd 
61/80:e8:3f:80:29/00:00:01:00:00/40 tag 29 cdb 0x0 data 65536 out
Mar 20 14:57:02 mesa kernel:          res 
40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
Mar 20 14:57:02 mesa kernel: ata4.00: cmd 
61/80:f0:3f:7a:29/00:00:01:00:00/40 tag 30 cdb 0x0 data 65536 out
Mar 20 14:57:02 mesa kernel:          res 
40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
Mar 20 14:57:03 mesa kernel: ata4: soft resetting port
Mar 20 14:57:03 mesa kernel: ata4: SATA link up 3.0 Gbps (SStatus 123 
SControl 300)
Mar 20 14:57:03 mesa kernel: ata4.00: configured for UDMA/133
Mar 20 14:57:03 mesa kernel: ata4: EH complete
Mar 20 14:57:03 mesa kernel: SCSI device sdd: 976773168 512-byte hdwr 
sectors (500108 MB)
Mar 20 14:57:03 mesa kernel: sdd: Write Protect is off
Mar 20 14:57:03 mesa kernel: sdd: Mode Sense: 00 3a 00 00
Mar 20 14:57:03 mesa kernel: SCSI device sdd: write cache: enabled, read 
cache: enabled, doesn't support DPO or FUA
Mar 20 14:57:55 mesa kernel: ata4: CPB flags CMD err, flags=0x11
Mar 20 14:58:25 mesa kernel: ata4: EH in ADMA mode, notifier 0x0 
notifier_error 0x0 gen_ctl 0x1501000 status 0x400
Mar 20 14:58:25 mesa kernel: ata4: CPB 0: ctl_flags 0x1f, resp_flags 0x0
Mar 20 14:58:25 mesa kernel: ata4: CPB 1: ctl_flags 0x1f, resp_flags 0x2
Mar 20 14:58:25 mesa kernel: ata4: CPB 2: ctl_flags 0x1f, resp_flags 0x2
Mar 20 14:58:25 mesa kernel: ata4: CPB 3: ctl_flags 0x1f, resp_flags 0x2
Mar 20 14:58:25 mesa kernel: ata4: CPB 4: ctl_flags 0x1f, resp_flags 0x2
Mar 20 14:58:25 mesa kernel: ata4: CPB 5: ctl_flags 0x1f, resp_flags 0x2
Mar 20 14:58:25 mesa kernel: ata4: CPB 6: ctl_flags 0x1f, resp_flags 0x11
Mar 20 14:58:25 mesa kernel: ata4: CPB 7: ctl_flags 0x1f, resp_flags 0x2
Mar 20 14:58:25 mesa kernel: ata4: CPB 8: ctl_flags 0x1f, resp_flags 0x2
Mar 20 14:58:25 mesa kernel: ata4: CPB 9: ctl_flags 0x1f, resp_flags 0x2
Mar 20 14:58:25 mesa kernel: ata4: CPB 10: ctl_flags 0x1f, resp_flags 0x2
Mar 20 14:58:25 mesa kernel: ata4: CPB 11: ctl_flags 0x1f, resp_flags 0x2
Mar 20 14:58:25 mesa kernel: ata4: CPB 12: ctl_flags 0x1f, resp_flags 0x2
Mar 20 14:58:25 mesa kernel: ata4: CPB 13: ctl_flags 0x1f, resp_flags 0x2
Mar 20 14:58:25 mesa kernel: ata4: CPB 14: ctl_flags 0x1f, resp_flags 0x2
Mar 20 14:58:25 mesa kernel: ata4: CPB 15: ctl_flags 0x1f, resp_flags 0x2
Mar 20 14:58:25 mesa kernel: ata4: CPB 16: ctl_flags 0x1f, resp_flags 0x2
Mar 20 14:58:25 mesa kernel: ata4: CPB 17: ctl_flags 0x1f, resp_flags 0x2
Mar 20 14:58:25 mesa kernel: ata4: CPB 18: ctl_flags 0x1f, resp_flags 0x2
Mar 20 14:58:25 mesa kernel: ata4: CPB 19: ctl_flags 0x1f, resp_flags 0x2
Mar 20 14:58:25 mesa kernel: ata4: CPB 20: ctl_flags 0x1f, resp_flags 0x2
Mar 20 14:58:25 mesa kernel: ata4: CPB 21: ctl_flags 0x1f, resp_flags 0x2
Mar 20 14:58:25 mesa kernel: ata4: CPB 22: ctl_flags 0x1f, resp_flags 0x2
Mar 20 14:58:25 mesa kernel: ata4: CPB 23: ctl_flags 0x1f, resp_flags 0x2
Mar 20 14:58:25 mesa kernel: ata4: CPB 24: ctl_flags 0x1f, resp_flags 0x2
Mar 20 14:58:25 mesa kernel: ata4: CPB 25: ctl_flags 0x1f, resp_flags 0x2
Mar 20 14:58:25 mesa kernel: ata4: CPB 26: ctl_flags 0x1f, resp_flags 0x2
Mar 20 14:58:25 mesa kernel: ata4: CPB 27: ctl_flags 0x1f, resp_flags 0x2
Mar 20 14:58:25 mesa kernel: ata4: CPB 28: ctl_flags 0x1f, resp_flags 0x2
Mar 20 14:58:25 mesa kernel: ata4: CPB 29: ctl_flags 0x1f, resp_flags 0x2
Mar 20 14:58:25 mesa kernel: ata4: CPB 30: ctl_flags 0x1f, resp_flags 0x2
Mar 20 14:58:25 mesa kernel: ata4: Resetting port
Mar 20 14:58:25 mesa kernel: ata4.00: exception Emask 0x0 SAct 
0x7fffffff SErr 0x400000 action 0x2 frozen
Mar 20 14:58:25 mesa kernel: ata4.00: cmd 
61/80:00:bf:32:94/00:00:01:00:00/40 tag 0 cdb 0x0 data 65536 out
Mar 20 14:58:25 mesa kernel:          res 
40/00:00:bf:9a:38/00:00:00:00:00/40 Emask 0x4 (timeout)
Mar 20 14:58:25 mesa kernel: ata4.00: cmd 
61/80:08:bf:29:94/00:00:01:00:00/40 tag 1 cdb 0x0 data 65536 out
Mar 20 14:58:25 mesa kernel:          res 
40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
Mar 20 14:58:25 mesa kernel: ata4.00: cmd 
61/80:10:3f:2a:94/00:00:01:00:00/40 tag 2 cdb 0x0 data 65536 out
Mar 20 14:58:25 mesa kernel:          res 
40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
Mar 20 14:58:25 mesa kernel: ata4.00: cmd 
61/80:18:3f:30:94/00:00:01:00:00/40 tag 3 cdb 0x0 data 65536 out
Mar 20 14:58:25 mesa kernel:          res 
40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
Mar 20 14:58:25 mesa kernel: ata4.00: cmd 
61/80:20:bf:30:94/00:00:01:00:00/40 tag 4 cdb 0x0 data 65536 out
Mar 20 14:58:25 mesa kernel:          res 
40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
Mar 20 14:58:25 mesa kernel: ata4.00: cmd 
61/80:28:bf:31:94/00:00:01:00:00/40 tag 5 cdb 0x0 data 65536 out
Mar 20 14:58:25 mesa kernel:          res 
40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
Mar 20 14:58:25 mesa kernel: ata4.00: cmd 
61/80:30:bf:23:94/00:00:01:00:00/40 tag 6 cdb 0x0 data 65536 out
Mar 20 14:58:25 mesa kernel:          res 
41/00:c8:3f:32:94/00:00:00:00:00/40 Emask 0x1 (device error)
Mar 20 14:58:25 mesa kernel: ata4.00: cmd 
61/80:38:3f:24:94/00:00:01:00:00/40 tag 7 cdb 0x0 data 65536 out
Mar 20 14:58:25 mesa kernel:          res 
40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
Mar 20 14:58:25 mesa kernel: ata4.00: cmd 
61/80:40:3f:25:94/00:00:01:00:00/40 tag 8 cdb 0x0 data 65536 out
Mar 20 14:58:25 mesa kernel:          res 
40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
Mar 20 14:58:25 mesa kernel: ata4.00: cmd 
61/80:48:bf:2a:94/00:00:01:00:00/40 tag 9 cdb 0x0 data 65536 out
Mar 20 14:58:25 mesa kernel:          res 
40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
Mar 20 14:58:25 mesa kernel: ata4.00: cmd 
61/80:50:3f:2c:94/00:00:01:00:00/40 tag 10 cdb 0x0 data 65536 out
Mar 20 14:58:25 mesa kernel:          res 
40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
Mar 20 14:58:25 mesa kernel: ata4.00: cmd 
61/80:58:bf:2c:94/00:00:01:00:00/40 tag 11 cdb 0x0 data 65536 out
Mar 20 14:58:25 mesa kernel:          res 
40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
Mar 20 14:58:25 mesa kernel: ata4.00: cmd 
61/80:60:bf:2d:94/00:00:01:00:00/40 tag 12 cdb 0x0 data 65536 out
Mar 20 14:58:25 mesa kernel:          res 
40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
Mar 20 14:58:25 mesa kernel: ata4.00: cmd 
61/80:68:3f:2f:94/00:00:01:00:00/40 tag 13 cdb 0x0 data 65536 out
Mar 20 14:58:25 mesa kernel:          res 
40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
Mar 20 14:58:25 mesa kernel: ata4.00: cmd 
61/80:70:3f:26:94/00:00:01:00:00/40 tag 14 cdb 0x0 data 65536 out
Mar 20 14:58:25 mesa kernel:          res 
40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
Mar 20 14:58:25 mesa kernel: ata4.00: cmd 
61/80:78:3f:27:94/00:00:01:00:00/40 tag 15 cdb 0x0 data 65536 out
Mar 20 14:58:25 mesa kernel:          res 
40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
Mar 20 14:58:25 mesa kernel: ata4.00: cmd 
61/80:80:3f:29:94/00:00:01:00:00/40 tag 16 cdb 0x0 data 65536 out
Mar 20 14:58:25 mesa kernel:          res 
40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
Mar 20 14:58:25 mesa kernel: ata4.00: cmd 
61/80:88:bf:2b:94/00:00:01:00:00/40 tag 17 cdb 0x0 data 65536 out
Mar 20 14:58:25 mesa kernel:          res 
40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
Mar 20 14:58:25 mesa kernel: ata4.00: cmd 
61/80:90:bf:2f:94/00:00:01:00:00/40 tag 18 cdb 0x0 data 65536 out
Mar 20 14:58:25 mesa kernel:          res 
40/00:e0:bf:87:29/00:00:00:00:00/40 Emask 0x4 (timeout)
Mar 20 14:58:25 mesa kernel: ata4.00: cmd 
61/80:98:bf:26:94/00:00:01:00:00/40 tag 19 cdb 0x0 data 65536 out
Mar 20 14:58:25 mesa kernel:          res 
40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
Mar 20 14:58:25 mesa kernel: ata4.00: cmd 
61/80:a0:bf:24:94/00:00:01:00:00/40 tag 20 cdb 0x0 data 65536 out
Mar 20 14:58:25 mesa kernel:          res 
40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
Mar 20 14:58:25 mesa kernel: ata4.00: cmd 
61/80:a8:bf:27:94/00:00:01:00:00/40 tag 21 cdb 0x0 data 65536 out
Mar 20 14:58:25 mesa kernel:          res 
40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
Mar 20 14:58:25 mesa kernel: ata4.00: cmd 
61/80:b0:3f:2d:94/00:00:01:00:00/40 tag 22 cdb 0x0 data 65536 out
Mar 20 14:58:25 mesa kernel:          res 
40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
Mar 20 14:58:25 mesa kernel: ata4.00: cmd 
61/80:b8:3f:2e:94/00:00:01:00:00/40 tag 23 cdb 0x0 data 65536 out
Mar 20 14:58:25 mesa kernel:          res 
40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
Mar 20 14:58:25 mesa kernel: ata4.00: cmd 
61/80:c0:bf:2e:94/00:00:01:00:00/40 tag 24 cdb 0x0 data 65536 out
Mar 20 14:58:25 mesa kernel:          res 
40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
Mar 20 14:58:25 mesa kernel: ata4.00: cmd 
61/80:c8:3f:32:94/00:00:01:00:00/40 tag 25 cdb 0x0 data 65536 out
Mar 20 14:58:25 mesa kernel:          res 
40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
Mar 20 14:58:25 mesa kernel: ata4.00: cmd 
61/80:d0:3f:28:94/00:00:01:00:00/40 tag 26 cdb 0x0 data 65536 out
Mar 20 14:58:25 mesa kernel:          res 
40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
Mar 20 14:58:25 mesa kernel: ata4.00: cmd 
61/80:d8:3f:31:94/00:00:01:00:00/40 tag 27 cdb 0x0 data 65536 out
Mar 20 14:58:25 mesa kernel:          res 
40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
Mar 20 14:58:25 mesa kernel: ata4.00: cmd 
61/80:e0:bf:28:94/00:00:01:00:00/40 tag 28 cdb 0x0 data 65536 out
Mar 20 14:58:25 mesa kernel:          res 
40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
Mar 20 14:58:25 mesa kernel: ata4.00: cmd 
61/80:e8:bf:25:94/00:00:01:00:00/40 tag 29 cdb 0x0 data 65536 out
Mar 20 14:58:25 mesa kernel:          res 
40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
Mar 20 14:58:25 mesa kernel: ata4.00: cmd 
61/80:f0:3f:2b:94/00:00:01:00:00/40 tag 30 cdb 0x0 data 65536 out
Mar 20 14:58:25 mesa kernel:          res 
40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
Mar 20 14:58:26 mesa kernel: ata4: soft resetting port
Mar 20 14:58:26 mesa kernel: ata4: SATA link up 3.0 Gbps (SStatus 123 
SControl 300)
Mar 20 14:58:26 mesa kernel: ata4.00: configured for UDMA/133
Mar 20 14:58:26 mesa kernel: ata4: EH complete
Mar 20 14:58:26 mesa kernel: SCSI device sdd: 976773168 512-byte hdwr 
sectors (500108 MB)
Mar 20 14:58:26 mesa kernel: sdd: Write Protect is off
Mar 20 14:58:26 mesa kernel: sdd: Mode Sense: 00 3a 00 00
Mar 20 14:58:26 mesa kernel: SCSI device sdd: write cache: enabled, read 
cache: enabled, doesn't support DPO or FUA

// Hard Lockup //


lspci output:

00:00.0 Memory controller: nVidia Corporation CK804 Memory Controller 
(rev a3)
00:01.0 ISA bridge: nVidia Corporation CK804 ISA Bridge (rev a3)
00:01.1 SMBus: nVidia Corporation CK804 SMBus (rev a2)
00:02.0 USB Controller: nVidia Corporation CK804 USB Controller (rev a2)
00:02.1 USB Controller: nVidia Corporation CK804 USB Controller (rev a3)
00:06.0 IDE interface: nVidia Corporation CK804 IDE (rev f2)
00:07.0 IDE interface: nVidia Corporation CK804 Serial ATA Controller 
(rev f3)
00:08.0 IDE interface: nVidia Corporation CK804 Serial ATA Controller 
(rev f3)
00:09.0 PCI bridge: nVidia Corporation CK804 PCI Bridge (rev a2)
00:0e.0 PCI bridge: nVidia Corporation CK804 PCIE Bridge (rev a3)
00:18.0 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] 
HyperTransport Technology Configuration
00:18.1 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] 
Address Map
00:18.2 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] 
DRAM Controller
00:18.3 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] 
Miscellaneous Control
00:19.0 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] 
HyperTransport Technology Configuration
00:19.1 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] 
Address Map
00:19.2 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] 
DRAM Controller
00:19.3 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] 
Miscellaneous Control
01:07.0 VGA compatible controller: ATI Technologies Inc Rage XL (rev 27)
08:0a.0 PCI bridge: Advanced Micro Devices [AMD] AMD-8131 PCI-X Bridge 
(rev 12)
08:0a.1 PIC: Advanced Micro Devices [AMD] AMD-8131 PCI-X IOAPIC (rev 01)
08:0b.0 PCI bridge: Advanced Micro Devices [AMD] AMD-8131 PCI-X Bridge 
(rev 12)
08:0b.1 PIC: Advanced Micro Devices [AMD] AMD-8131 PCI-X IOAPIC (rev 01)
0a:09.0 Ethernet controller: Broadcom Corporation NetXtreme BCM5704 
Gigabit Ethernet (rev 03)
0a:09.1 Ethernet controller: Broadcom Corporation NetXtreme BCM5704 
Gigabit Ethernet (rev 03)



dmesg for 3.0Gb/s operation:

Mar 20 14:39:12 mesa kernel: Inspecting /boot/System.map-2.6.20.3
Mar 20 14:39:12 mesa kernel: Loaded 29887 symbols from 
/boot/System.map-2.6.20.3.
Mar 20 14:39:12 mesa kernel: Symbols match kernel version 2.6.20.
Mar 20 14:39:12 mesa kernel: No module symbols loaded - kernel modules 
not enabled.
Mar 20 14:39:12 mesa kernel: Linux version 2.6.20.3 (root@mesa) (gcc 
version 4.1.2 20060928 (prerelease) (Ubuntu 4.1.1-13ubuntu5)) #1 SMP Sun 
Mar 18 03:41:44 EDT 2007
Mar 20 14:39:12 mesa kernel: Command line: root=/dev/md0 ro
Mar 20 14:39:12 mesa kernel: BIOS-provided physical RAM map:
Mar 20 14:39:12 mesa kernel:  BIOS-e820: 0000000000000000 - 
000000000009b800 (usable)
Mar 20 14:39:12 mesa kernel:  BIOS-e820: 000000000009b800 - 
00000000000a0000 (reserved)
Mar 20 14:39:12 mesa kernel:  BIOS-e820: 00000000000d4000 - 
0000000000100000 (reserved)
Mar 20 14:39:12 mesa kernel:  BIOS-e820: 0000000000100000 - 
000000007ff90000 (usable)
Mar 20 14:39:12 mesa kernel:  BIOS-e820: 000000007ff90000 - 
000000007ff99000 (ACPI data)
Mar 20 14:39:12 mesa kernel:  BIOS-e820: 000000007ff99000 - 
0000000080000000 (ACPI NVS)
Mar 20 14:39:12 mesa kernel:  BIOS-e820: 0000000080000000 - 
00000000cff80000 (usable)
Mar 20 14:39:12 mesa kernel:  BIOS-e820: 00000000cff80000 - 
00000000d0000000 (reserved)
Mar 20 14:39:12 mesa kernel:  BIOS-e820: 00000000e0000000 - 
00000000e8000000 (reserved)
Mar 20 14:39:12 mesa kernel:  BIOS-e820: 00000000fec00000 - 
00000000fec00400 (reserved)
Mar 20 14:39:12 mesa kernel:  BIOS-e820: 00000000fee00000 - 
00000000fee01000 (reserved)
Mar 20 14:39:12 mesa kernel:  BIOS-e820: 00000000fff80000 - 
0000000100000000 (reserved)
Mar 20 14:39:12 mesa kernel:  BIOS-e820: 0000000100000000 - 
0000000200000000 (usable)
Mar 20 14:39:12 mesa kernel: Entering add_active_range(0, 0, 155) 0 
entries of 3200 used
Mar 20 14:39:12 mesa kernel: Entering add_active_range(0, 256, 524176) 1 
entries of 3200 used
Mar 20 14:39:12 mesa kernel: Entering add_active_range(0, 524288, 
851840) 2 entries of 3200 used
Mar 20 14:39:12 mesa kernel: Entering add_active_range(0, 1048576, 
2097152) 3 entries of 3200 used
Mar 20 14:39:12 mesa kernel: end_pfn_map = 2097152
Mar 20 14:39:12 mesa kernel: DMI present.
Mar 20 14:39:12 mesa kernel: ACPI: RSDP (v000 
PTLTD                                 ) @ 0x00000000000f7040
Mar 20 14:39:12 mesa kernel: ACPI: RSDT (v001 PTLTD    RSDT   
0x06040000  LTP 0x00000000) @ 0x000000007ff9542f
Mar 20 14:39:12 mesa kernel: ACPI: FADT (v001 NVIDIA CK8S     0x06040000 
PTL_ 0x000f4240) @ 0x000000007ff98d9a
Mar 20 14:39:12 mesa kernel: ACPI: SRAT (v001 AMD    HAMMER   0x06040000 
AMD  0x00000001) @ 0x000000007ff98e0e
Mar 20 14:39:12 mesa kernel: ACPI: SPCR (v001 PTLTD  $UCRTBL$ 0x06040000 
PTL  0x00000001) @ 0x000000007ff98ef6
Mar 20 14:39:12 mesa kernel: ACPI: MADT (v001 PTLTD  ^I APIC   
0x06040000  LTP 0x00000000) @ 0x000000007ff98f46
Mar 20 14:39:12 mesa kernel: ACPI: BOOT (v001 PTLTD  $SBFTBL$ 
0x06040000  LTP 0x00000001) @ 0x000000007ff98fd8
Mar 20 14:39:12 mesa kernel: ACPI: DSDT (v001 NVIDIA      CK8 0x06040000 
MSFT 0x0100000e) @ 0x0000000000000000
Mar 20 14:39:12 mesa kernel: SRAT: PXM 0 -> APIC 0 -> Node 0
Mar 20 14:39:12 mesa kernel: SRAT: PXM 0 -> APIC 1 -> Node 0
Mar 20 14:39:12 mesa kernel: SRAT: PXM 1 -> APIC 2 -> Node 1
Mar 20 14:39:12 mesa kernel: SRAT: PXM 1 -> APIC 3 -> Node 1
Mar 20 14:39:12 mesa kernel: SRAT: Node 0 PXM 0 0-a0000
Mar 20 14:39:12 mesa kernel: Entering add_active_range(0, 0, 155) 0 
entries of 3200 used
Mar 20 14:39:12 mesa kernel: SRAT: Node 0 PXM 0 0-d0000000
Mar 20 14:39:12 mesa kernel: Entering add_active_range(0, 0, 155) 1 
entries of 3200 used
Mar 20 14:39:12 mesa kernel: Entering add_active_range(0, 256, 524176) 1 
entries of 3200 used
Mar 20 14:39:12 mesa kernel: Entering add_active_range(0, 524288, 
851840) 2 entries of 3200 used
Mar 20 14:39:12 mesa kernel: SRAT: Node 1 PXM 1 100000000-200000000
Mar 20 14:39:12 mesa kernel: Entering add_active_range(1, 1048576, 
2097152) 3 entries of 3200 used
Mar 20 14:39:12 mesa kernel: NUMA: Using 32 for the hash shift.
Mar 20 14:39:12 mesa kernel: Bootmem setup node 0 
0000000000000000-00000000d0000000
Mar 20 14:39:12 mesa kernel: Bootmem setup node 1 
0000000100000000-0000000200000000
Mar 20 14:39:12 mesa kernel: Zone PFN ranges:
Mar 20 14:39:12 mesa kernel:   DMA             0 ->     4096
Mar 20 14:39:12 mesa kernel:   DMA32        4096 ->  1048576
Mar 20 14:39:12 mesa kernel:   Normal    1048576 ->  2097152
Mar 20 14:39:12 mesa kernel: early_node_map[4] active PFN ranges
Mar 20 14:39:12 mesa kernel:     0:        0 ->      155
Mar 20 14:39:12 mesa kernel:     0:      256 ->   524176
Mar 20 14:39:12 mesa kernel:     0:   524288 ->   851840
Mar 20 14:39:12 mesa kernel:     1:  1048576 ->  2097152
Mar 20 14:39:12 mesa kernel: On node 0 totalpages: 851627
Mar 20 14:39:12 mesa kernel:   DMA zone: 56 pages used for memmap
Mar 20 14:39:12 mesa kernel:   DMA zone: 1343 pages reserved
Mar 20 14:39:12 mesa kernel:   DMA zone: 2596 pages, LIFO batch:0
Mar 20 14:39:12 mesa kernel:   DMA32 zone: 11590 pages used for memmap
Mar 20 14:39:12 mesa kernel:   DMA32 zone: 836042 pages, LIFO batch:31
Mar 20 14:39:12 mesa kernel:   Normal zone: 0 pages used for memmap
Mar 20 14:39:12 mesa kernel: On node 1 totalpages: 1048576
Mar 20 14:39:12 mesa kernel:   DMA zone: 0 pages used for memmap
Mar 20 14:39:12 mesa kernel:   DMA32 zone: 0 pages used for memmap
Mar 20 14:39:12 mesa kernel:   Normal zone: 14336 pages used for memmap
Mar 20 14:39:12 mesa kernel:   Normal zone: 1034240 pages, LIFO batch:31
Mar 20 14:39:12 mesa kernel: Nvidia board detected. Ignoring ACPI timer 
override.
Mar 20 14:39:12 mesa kernel: If you got timer trouble try 
acpi_use_timer_override
Mar 20 14:39:12 mesa kernel: ACPI: PM-Timer IO Port: 0x8008
Mar 20 14:39:12 mesa kernel: ACPI: Local APIC address 0xfee00000
Mar 20 14:39:12 mesa kernel: ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] 
enabled)
Mar 20 14:39:12 mesa kernel: Processor #0 (Bootup-CPU)
Mar 20 14:39:12 mesa kernel: ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] 
enabled)
Mar 20 14:39:12 mesa kernel: Processor #1
Mar 20 14:39:12 mesa kernel: ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] 
enabled)
Mar 20 14:39:12 mesa kernel: Processor #2
Mar 20 14:39:12 mesa kernel: ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] 
enabled)
Mar 20 14:39:12 mesa kernel: Processor #3
Mar 20 14:39:12 mesa kernel: ACPI: LAPIC_NMI (acpi_id[0x00] high edge 
lint[0x1])
Mar 20 14:39:12 mesa kernel: ACPI: LAPIC_NMI (acpi_id[0x01] high edge 
lint[0x1])
Mar 20 14:39:12 mesa kernel: ACPI: LAPIC_NMI (acpi_id[0x02] high edge 
lint[0x1])
Mar 20 14:39:12 mesa kernel: ACPI: LAPIC_NMI (acpi_id[0x03] high edge 
lint[0x1])
Mar 20 14:39:12 mesa kernel: ACPI: IOAPIC (id[0x04] address[0xfec00000] 
gsi_base[0])
Mar 20 14:39:12 mesa kernel: IOAPIC[0]: apic_id 4, address 0xfec00000, 
GSI 0-23
Mar 20 14:39:12 mesa kernel: ACPI: IOAPIC (id[0x05] address[0xdf200000] 
gsi_base[24])
Mar 20 14:39:12 mesa kernel: IOAPIC[1]: apic_id 5, address 0xdf200000, 
GSI 24-27
Mar 20 14:39:12 mesa kernel: ACPI: IOAPIC (id[0x06] address[0xdf201000] 
gsi_base[28])
Mar 20 14:39:12 mesa kernel: IOAPIC[2]: apic_id 6, address 0xdf201000, 
GSI 28-31
Mar 20 14:39:12 mesa kernel: ACPI: INT_SRC_OVR (bus 0 bus_irq 9 
global_irq 9 low level)
Mar 20 14:39:12 mesa kernel: ACPI: IRQ9 used by override.
Mar 20 14:39:12 mesa kernel: Setting APIC routing to flat
Mar 20 14:39:12 mesa kernel: Using ACPI (MADT) for SMP configuration 
information
Mar 20 14:39:12 mesa kernel: Nosave address range: 000000000009b000 - 
000000000009c000
Mar 20 14:39:12 mesa kernel: Nosave address range: 000000000009c000 - 
00000000000a0000
Mar 20 14:39:12 mesa kernel: Nosave address range: 00000000000a0000 - 
00000000000d4000
Mar 20 14:39:12 mesa kernel: Nosave address range: 00000000000d4000 - 
0000000000100000
Mar 20 14:39:12 mesa kernel: Nosave address range: 000000007ff90000 - 
000000007ff99000
Mar 20 14:39:12 mesa kernel: Nosave address range: 000000007ff99000 - 
0000000080000000
Mar 20 14:39:12 mesa kernel: Nosave address range: 00000000cff80000 - 
00000000d0000000
Mar 20 14:39:12 mesa kernel: Nosave address range: 00000000d0000000 - 
00000000e0000000
Mar 20 14:39:12 mesa kernel: Nosave address range: 00000000e0000000 - 
00000000e8000000
Mar 20 14:39:12 mesa kernel: Nosave address range: 00000000e8000000 - 
00000000fec00000
Mar 20 14:39:12 mesa kernel: Nosave address range: 00000000fec00000 - 
00000000fee00000
Mar 20 14:39:12 mesa kernel: Nosave address range: 00000000fee00000 - 
00000000fee01000
Mar 20 14:39:12 mesa kernel: Nosave address range: 00000000fee01000 - 
00000000fff80000
Mar 20 14:39:12 mesa kernel: Nosave address range: 00000000fff80000 - 
0000000100000000
Mar 20 14:39:12 mesa kernel: Allocating PCI resources starting at 
ea000000 (gap: e8000000:16c00000)
Mar 20 14:39:12 mesa kernel: PERCPU: Allocating 32768 bytes of per cpu data
Mar 20 14:39:12 mesa kernel: Built 2 zonelists.  Total pages: 1872878
Mar 20 14:39:12 mesa kernel: Kernel command line: root=/dev/md0 ro
Mar 20 14:39:12 mesa kernel: Initializing CPU#0
Mar 20 14:39:12 mesa kernel: PID hash table entries: 4096 (order: 12, 
32768 bytes)
Mar 20 14:39:12 mesa kernel: Console: colour VGA+ 80x25
Mar 20 14:39:12 mesa kernel: Dentry cache hash table entries: 1048576 
(order: 11, 8388608 bytes)
Mar 20 14:39:12 mesa kernel: Inode-cache hash table entries: 524288 
(order: 10, 4194304 bytes)
Mar 20 14:39:12 mesa kernel: Checking aperture...
Mar 20 14:39:12 mesa kernel: CPU 0: aperture @ 0 size 32 MB
Mar 20 14:39:12 mesa kernel: No AGP bridge found
Mar 20 14:39:12 mesa kernel: Your BIOS doesn't leave a aperture memory hole
Mar 20 14:39:12 mesa kernel: Please enable the IOMMU option in the BIOS 
setup
Mar 20 14:39:12 mesa kernel: This costs you 64 MB of RAM
Mar 20 14:39:12 mesa kernel: Mapping aperture over 65536 KB of RAM @ 8000000
Mar 20 14:39:12 mesa kernel: Memory: 7413304k/8388608k available (3161k 
kernel code, 187508k reserved, 1297k data, 344k init)
Mar 20 14:39:12 mesa kernel: Calibrating delay using timer specific 
routine.. 3618.36 BogoMIPS (lpj=18091839)
Mar 20 14:39:12 mesa kernel: Mount-cache hash table entries: 256
Mar 20 14:39:12 mesa kernel: CPU: L1 I Cache: 64K (64 bytes/line), D 
cache 64K (64 bytes/line)
Mar 20 14:39:12 mesa kernel: CPU: L2 Cache: 1024K (64 bytes/line)
Mar 20 14:39:12 mesa kernel: CPU 0/0 -> Node 0
Mar 20 14:39:12 mesa kernel: CPU: Physical Processor ID: 0
Mar 20 14:39:12 mesa kernel: CPU: Processor Core ID: 0
Mar 20 14:39:12 mesa kernel: Freeing SMP alternatives: 36k freed
Mar 20 14:39:12 mesa kernel: ACPI: Core revision 20060707
Mar 20 14:39:12 mesa kernel: Using local APIC timer interrupts.
Mar 20 14:39:12 mesa kernel: result 12557931
Mar 20 14:39:12 mesa kernel: Detected 12.557 MHz APIC timer.
Mar 20 14:39:12 mesa kernel: Booting processor 1/4 APIC 0x1
Mar 20 14:39:12 mesa kernel: Initializing CPU#1
Mar 20 14:39:12 mesa kernel: Calibrating delay using timer specific 
routine.. 3616.79 BogoMIPS (lpj=18083950)
Mar 20 14:39:12 mesa kernel: CPU: L1 I Cache: 64K (64 bytes/line), D 
cache 64K (64 bytes/line)
Mar 20 14:39:12 mesa kernel: CPU: L2 Cache: 1024K (64 bytes/line)
Mar 20 14:39:12 mesa kernel: CPU 1/1 -> Node 0
Mar 20 14:39:12 mesa kernel: CPU: Physical Processor ID: 0
Mar 20 14:39:12 mesa kernel: CPU: Processor Core ID: 1
Mar 20 14:39:12 mesa kernel: Dual Core AMD Opteron(tm) Processor 265 
stepping 02
Mar 20 14:39:12 mesa kernel: CPU 1: Syncing TSC to CPU 0.
Mar 20 14:39:12 mesa kernel: CPU 1: synchronized TSC with CPU 0 (last 
diff -5 cycles, maxerr 558 cycles)
Mar 20 14:39:12 mesa kernel: Booting processor 2/4 APIC 0x2
Mar 20 14:39:12 mesa kernel: Initializing CPU#2
Mar 20 14:39:12 mesa kernel: Calibrating delay using timer specific 
routine.. 3616.80 BogoMIPS (lpj=18084038)
Mar 20 14:39:12 mesa kernel: CPU: L1 I Cache: 64K (64 bytes/line), D 
cache 64K (64 bytes/line)
Mar 20 14:39:12 mesa kernel: CPU: L2 Cache: 1024K (64 bytes/line)
Mar 20 14:39:12 mesa kernel: CPU 2/2 -> Node 1
Mar 20 14:39:12 mesa kernel: CPU: Physical Processor ID: 1
Mar 20 14:39:12 mesa kernel: CPU: Processor Core ID: 0
Mar 20 14:39:12 mesa kernel: Dual Core AMD Opteron(tm) Processor 265 
stepping 02
Mar 20 14:39:12 mesa kernel: CPU 2: Syncing TSC to CPU 0.
Mar 20 14:39:12 mesa kernel: CPU 2: synchronized TSC with CPU 0 (last 
diff -5 cycles, maxerr 1019 cycles)
Mar 20 14:39:12 mesa kernel: Booting processor 3/4 APIC 0x3
Mar 20 14:39:12 mesa kernel: Initializing CPU#3
Mar 20 14:39:12 mesa kernel: Calibrating delay using timer specific 
routine.. 3616.81 BogoMIPS (lpj=18084060)
Mar 20 14:39:12 mesa kernel: CPU: L1 I Cache: 64K (64 bytes/line), D 
cache 64K (64 bytes/line)
Mar 20 14:39:12 mesa kernel: CPU: L2 Cache: 1024K (64 bytes/line)
Mar 20 14:39:12 mesa kernel: CPU 3/3 -> Node 1
Mar 20 14:39:12 mesa kernel: CPU: Physical Processor ID: 1
Mar 20 14:39:12 mesa kernel: CPU: Processor Core ID: 1
Mar 20 14:39:12 mesa kernel: Dual Core AMD Opteron(tm) Processor 265 
stepping 02
Mar 20 14:39:12 mesa kernel: CPU 3: Syncing TSC to CPU 0.
Mar 20 14:39:12 mesa kernel: CPU 3: synchronized TSC with CPU 0 (last 
diff -7 cycles, maxerr 1019 cycles)
Mar 20 14:39:12 mesa kernel: Brought up 4 CPUs
Mar 20 14:39:12 mesa kernel: testing NMI watchdog ... OK.
Mar 20 14:39:12 mesa kernel: Disabling vsyscall due to use of PM timer
Mar 20 14:39:12 mesa kernel: time.c: Using 3.579545 MHz WALL PM GTOD PM 
timer.
Mar 20 14:39:12 mesa kernel: time.c: Detected 1808.341 MHz processor.
Mar 20 14:39:12 mesa kernel: migration_cost=402,760
Mar 20 14:39:12 mesa kernel: NET: Registered protocol family 16
Mar 20 14:39:12 mesa kernel: ACPI: bus type pci registered
Mar 20 14:39:12 mesa kernel: PCI: Using configuration type 1
Mar 20 14:39:12 mesa kernel: ACPI: Interpreter enabled
Mar 20 14:39:12 mesa kernel: ACPI: Using IOAPIC for interrupt routing
Mar 20 14:39:12 mesa kernel: ACPI: PCI Root Bridge [PCI0] (0000:00)
Mar 20 14:39:12 mesa kernel: PCI: Probing PCI hardware (bus 00)
Mar 20 14:39:12 mesa kernel: ACPI: Assume root bridge [\_SB_.PCI0] bus is 0
Mar 20 14:39:12 mesa kernel: Boot video device is 0000:01:07.0
Mar 20 14:39:12 mesa kernel: ACPI: PCI Interrupt Routing Table 
[\_SB_.PCI0._PRT]
Mar 20 14:39:12 mesa kernel: ACPI: PCI Interrupt Routing Table 
[\_SB_.PCI0.P2P0._PRT]
Mar 20 14:39:12 mesa kernel: ACPI: PCI Interrupt Routing Table 
[\_SB_.PCI0.XVR0._PRT]
Mar 20 14:39:12 mesa kernel: ACPI: PCI Interrupt Link [LNK1] (IRQs 16 17 
18 19) *0
Mar 20 14:39:12 mesa kernel: ACPI: PCI Interrupt Link [LNK2] (IRQs 16 17 
18 19) *0
Mar 20 14:39:12 mesa kernel: ACPI: PCI Interrupt Link [LNK3] (IRQs 16 17 
18 19) *0
Mar 20 14:39:12 mesa kernel: ACPI: PCI Interrupt Link [LNK4] (IRQs 16 17 
18 19) *0, disabled.
Mar 20 14:39:12 mesa kernel: ACPI: PCI Interrupt Link [LNK5] (IRQs 16 17 
18 19) *0, disabled.
Mar 20 14:39:12 mesa kernel: ACPI: PCI Interrupt Link [LSMB] (IRQs 20 21 
22 23) *0, disabled.
Mar 20 14:39:12 mesa kernel: ACPI: PCI Interrupt Link [LUS0] (IRQs 20 21 
22 23) *0
Mar 20 14:39:12 mesa kernel: ACPI: PCI Interrupt Link [LUS2] (IRQs 20 21 
22 23) *0
Mar 20 14:39:12 mesa kernel: ACPI: PCI Interrupt Link [LMAC] (IRQs 20 21 
22 23) *0, disabled.
Mar 20 14:39:12 mesa kernel: ACPI: PCI Interrupt Link [LACI] (IRQs 20 21 
22 23) *0, disabled.
Mar 20 14:39:12 mesa kernel: ACPI: PCI Interrupt Link [LMCI] (IRQs 20 21 
22 23) *0, disabled.
Mar 20 14:39:12 mesa kernel: ACPI: PCI Interrupt Link [LPID] (IRQs 20 21 
22 23) *0, disabled.
Mar 20 14:39:12 mesa kernel: ACPI: PCI Interrupt Link [LTID] (IRQs 20 21 
22 23) *0
Mar 20 14:39:12 mesa kernel: ACPI: PCI Interrupt Link [LSI1] (IRQs 20 21 
22 23) *0, disabled.
Mar 20 14:39:12 mesa kernel: ACPI: PCI Interrupt Link [APCP] (IRQs 20 21 
22 23) *0, disabled.
Mar 20 14:39:12 mesa kernel: ACPI: PCI Root Bridge [PCI2] (0000:08)
Mar 20 14:39:12 mesa kernel: PCI: Probing PCI hardware (bus 08)
Mar 20 14:39:12 mesa kernel: ACPI: Assume root bridge [\_SB_.PCI0] bus is 0
Mar 20 14:39:12 mesa kernel: ACPI: PCI Interrupt Routing Table 
[\_SB_.PCI2.G0PA._PRT]
Mar 20 14:39:12 mesa kernel: ACPI: PCI Interrupt Routing Table 
[\_SB_.PCI2.G0PB._PRT]
Mar 20 14:39:12 mesa kernel: Linux Plug and Play Support v0.97 (c) Adam 
Belay
Mar 20 14:39:12 mesa kernel: pnp: PnP ACPI init
Mar 20 14:39:12 mesa kernel: pnp: PnP ACPI: found 15 devices
Mar 20 14:39:12 mesa kernel: SCSI subsystem initialized
Mar 20 14:39:12 mesa kernel: libata version 2.00 loaded.
Mar 20 14:39:12 mesa kernel: usbcore: registered new interface driver usbfs
Mar 20 14:39:12 mesa kernel: usbcore: registered new interface driver hub
Mar 20 14:39:12 mesa kernel: usbcore: registered new device driver usb
Mar 20 14:39:12 mesa kernel: PCI: Using ACPI for IRQ routing
Mar 20 14:39:12 mesa kernel: PCI: If a device doesn't work, try 
"pci=routeirq".  If it helps, post a report
Mar 20 14:39:12 mesa kernel: PCI-DMA: Disabling AGP.
Mar 20 14:39:12 mesa kernel: PCI-DMA: aperture base @ 8000000 size 65536 KB
Mar 20 14:39:12 mesa kernel: PCI-DMA: using GART IOMMU.
Mar 20 14:39:12 mesa kernel: PCI-DMA: Reserving 64MB of IOMMU area in 
the AGP aperture
Mar 20 14:39:12 mesa kernel: pnp: 00:08: ioport range 0x8000-0x807f 
could not be reserved
Mar 20 14:39:12 mesa kernel: pnp: 00:08: ioport range 0x8080-0x80ff has 
been reserved
Mar 20 14:39:12 mesa kernel: pnp: 00:08: ioport range 0x8400-0x847f has 
been reserved
Mar 20 14:39:12 mesa kernel: pnp: 00:08: ioport range 0x8480-0x84ff has 
been reserved
Mar 20 14:39:12 mesa kernel: pnp: 00:08: ioport range 0x8800-0x887f has 
been reserved
Mar 20 14:39:12 mesa kernel: pnp: 00:08: ioport range 0x8880-0x88ff has 
been reserved
Mar 20 14:39:12 mesa kernel: pnp: 00:08: ioport range 0x5000-0x503f has 
been reserved
Mar 20 14:39:12 mesa kernel: pnp: 00:08: ioport range 0x5040-0x507f has 
been reserved
Mar 20 14:39:12 mesa kernel: PCI: Bridge: 0000:00:09.0
Mar 20 14:39:12 mesa kernel:   IO window: 2000-2fff
Mar 20 14:39:12 mesa kernel:   MEM window: dd100000-deffffff
Mar 20 14:39:12 mesa kernel:   PREFETCH window: ea000000-ea0fffff
Mar 20 14:39:12 mesa kernel: PCI: Bridge: 0000:00:0e.0
Mar 20 14:39:12 mesa kernel:   IO window: disabled.
Mar 20 14:39:12 mesa kernel:   MEM window: disabled.
Mar 20 14:39:12 mesa kernel:   PREFETCH window: disabled.
Mar 20 14:39:12 mesa kernel: PCI: Setting latency timer of device 
0000:00:09.0 to 64
Mar 20 14:39:12 mesa kernel: PCI: Setting latency timer of device 
0000:00:0e.0 to 64
Mar 20 14:39:12 mesa kernel: PCI: Bridge: 0000:08:0a.0
Mar 20 14:39:12 mesa kernel:   IO window: disabled.
Mar 20 14:39:12 mesa kernel:   MEM window: disabled.
Mar 20 14:39:12 mesa kernel:   PREFETCH window: disabled.
Mar 20 14:39:12 mesa kernel: PCI: Bridge: 0000:08:0b.0
Mar 20 14:39:12 mesa kernel:   IO window: disabled.
Mar 20 14:39:12 mesa kernel:   MEM window: df300000-df3fffff
Mar 20 14:39:12 mesa kernel:   PREFETCH window: ea100000-ea1fffff
Mar 20 14:39:12 mesa kernel: NET: Registered protocol family 2
Mar 20 14:39:12 mesa kernel: IP route cache hash table entries: 262144 
(order: 9, 2097152 bytes)
Mar 20 14:39:12 mesa kernel: TCP established hash table entries: 262144 
(order: 10, 4194304 bytes)
Mar 20 14:39:12 mesa kernel: TCP bind hash table entries: 65536 (order: 
8, 1048576 bytes)
Mar 20 14:39:12 mesa kernel: TCP: Hash tables configured (established 
262144 bind 65536)
Mar 20 14:39:12 mesa kernel: TCP reno registered
Mar 20 14:39:12 mesa kernel: Simple Boot Flag at 0x36 set to 0x1
Mar 20 14:39:12 mesa kernel: audit: initializing netlink socket (disabled)
Mar 20 14:39:12 mesa kernel: audit(1174415939.280:1): initialized
Mar 20 14:39:12 mesa kernel: VFS: Disk quotas dquot_6.5.1
Mar 20 14:39:12 mesa kernel: Dquot-cache hash table entries: 512 (order 
0, 4096 bytes)
Mar 20 14:39:12 mesa kernel: SGI XFS with ACLs, security attributes, 
large block/inode numbers, no debug enabled
Mar 20 14:39:12 mesa kernel: SGI XFS Quota Management subsystem
Mar 20 14:39:12 mesa kernel: io scheduler noop registered
Mar 20 14:39:12 mesa kernel: io scheduler anticipatory registered
Mar 20 14:39:12 mesa kernel: io scheduler deadline registered
Mar 20 14:39:12 mesa kernel: io scheduler cfq registered (default)
Mar 20 14:39:12 mesa kernel: PCI: Found disabled HT MSI Mapping on 
0000:00:0e.0
Mar 20 14:39:12 mesa kernel: PCI: Found enabled HT MSI Mapping on 
0000:00:00.0
Mar 20 14:39:12 mesa kernel: PCI: MSI quirk detected. 
PCI_BUS_FLAGS_NO_MSI set for 0000:08:0a.0 subordinate bus.
Mar 20 14:39:12 mesa kernel: PCI: MSI quirk detected. 
PCI_BUS_FLAGS_NO_MSI set for 0000:08:0b.0 subordinate bus.
Mar 20 14:39:12 mesa kernel: PCI: Setting latency timer of device 
0000:00:0e.0 to 64
Mar 20 14:39:12 mesa kernel: assign_interrupt_mode Found MSI capability
Mar 20 14:39:12 mesa kernel: Allocate Port Service[0000:00:0e.0:pcie00]
Mar 20 14:39:12 mesa kernel: vga16fb: initializing
Mar 20 14:39:12 mesa kernel: vga16fb: mapped to 0xffff8100000a0000
Mar 20 14:39:12 mesa kernel: fb0: VGA16 VGA frame buffer device
Mar 20 14:39:12 mesa kernel: input: Power Button (FF) as /class/input/input0
Mar 20 14:39:12 mesa kernel: ACPI: Power Button (FF) [PWRF]
Mar 20 14:39:12 mesa kernel: input: Power Button (CM) as /class/input/input1
Mar 20 14:39:12 mesa kernel: ACPI: Power Button (CM) [PWRB]
Mar 20 14:39:12 mesa kernel: Real Time Clock Driver v1.12ac
Mar 20 14:39:12 mesa kernel: Linux agpgart interface v0.101 (c) Dave Jones
Mar 20 14:39:12 mesa kernel: Serial: 8250/16550 driver $Revision: 1.90 $ 
4 ports, IRQ sharing enabled
Mar 20 14:39:12 mesa kernel: serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is 
a 16550A
Mar 20 14:39:12 mesa kernel: serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is 
a 16550A
Mar 20 14:39:12 mesa kernel: 00:02: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
Mar 20 14:39:12 mesa kernel: 00:03: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
Mar 20 14:39:12 mesa kernel: RAMDISK driver initialized: 16 RAM disks of 
65536K size 1024 blocksize
Mar 20 14:39:12 mesa kernel: loop: loaded (max 8 devices)
Mar 20 14:39:12 mesa kernel: tg3.c:v3.72 (January 8, 2007)
Mar 20 14:39:12 mesa kernel: ACPI: PCI Interrupt 0000:0a:09.0[A] -> GSI 
28 (level, low) -> IRQ 28
Mar 20 14:39:12 mesa kernel: eth0: Tigon3 [partno(BCM95704A7) rev 2003 
PHY(5704)] (PCIX:133MHz:64-bit) 10/100/1000Base-T Ethernet 00:e0:81:34:55:d4
Mar 20 14:39:12 mesa kernel: eth0: RXcsums[1] LinkChgREG[0] MIirq[0] 
ASF[0] Split[0] WireSpeed[1] TSOcap[1]
Mar 20 14:39:12 mesa kernel: eth0: dma_rwctrl[769f4000] dma_mask[64-bit]
Mar 20 14:39:12 mesa kernel: ACPI: PCI Interrupt 0000:0a:09.1[B] -> GSI 
29 (level, low) -> IRQ 29
Mar 20 14:39:12 mesa kernel: eth1: Tigon3 [partno(BCM95704A7) rev 2003 
PHY(5704)] (PCIX:133MHz:64-bit) 10/100/1000Base-T Ethernet 00:e0:81:34:55:d5
Mar 20 14:39:12 mesa kernel: eth1: RXcsums[1] LinkChgREG[0] MIirq[0] 
ASF[0] Split[0] WireSpeed[1] TSOcap[1]
Mar 20 14:39:12 mesa kernel: eth1: dma_rwctrl[769f4000] dma_mask[64-bit]
Mar 20 14:39:12 mesa kernel: Uniform Multi-Platform E-IDE driver 
Revision: 7.00alpha2
Mar 20 14:39:12 mesa kernel: ide: Assuming 33MHz system bus speed for 
PIO modes; override with idebus=xx
Mar 20 14:39:12 mesa kernel: NFORCE-CK804: IDE controller at PCI slot 
0000:00:06.0
Mar 20 14:39:12 mesa kernel: NFORCE-CK804: chipset revision 242
Mar 20 14:39:12 mesa kernel: NFORCE-CK804: not 100%% native mode: will 
probe irqs later
Mar 20 14:39:12 mesa kernel: NFORCE-CK804: 0000:00:06.0 (rev f2) UDMA133 
controller
Mar 20 14:39:12 mesa kernel:     ide0: BM-DMA at 0x1400-0x1407, BIOS 
settings: hda:pio, hdb:pio
Mar 20 14:39:12 mesa kernel:     ide1: BM-DMA at 0x1408-0x140f, BIOS 
settings: hdc:pio, hdd:DMA
Mar 20 14:39:12 mesa kernel: Probing IDE interface ide0...
Mar 20 14:39:12 mesa kernel: Probing IDE interface ide1...
Mar 20 14:39:12 mesa kernel: hdd: CD-224E-N, ATAPI CD/DVD-ROM drive
Mar 20 14:39:12 mesa kernel: ide1 at 0x170-0x177,0x376 on irq 15
Mar 20 14:39:12 mesa kernel: sata_nv 0000:00:07.0: version 3.2
Mar 20 14:39:12 mesa kernel: ACPI: PCI Interrupt Link [LTID] enabled at 
IRQ 23
Mar 20 14:39:12 mesa kernel: ACPI: PCI Interrupt 0000:00:07.0[A] -> Link 
[LTID] -> GSI 23 (level, high) -> IRQ 23
Mar 20 14:39:12 mesa kernel: sata_nv 0000:00:07.0: Using ADMA mode
Mar 20 14:39:12 mesa kernel: PCI: Setting latency timer of device 
0000:00:07.0 to 64
Mar 20 14:39:12 mesa kernel: ata1: SATA max UDMA/133 cmd 
0xFFFFC20000004480 ctl 0xFFFFC200000044A0 bmdma 0x1410 irq 23
Mar 20 14:39:12 mesa kernel: ata2: SATA max UDMA/133 cmd 
0xFFFFC20000004580 ctl 0xFFFFC200000045A0 bmdma 0x1418 irq 23
Mar 20 14:39:12 mesa kernel: scsi0 : sata_nv
Mar 20 14:39:12 mesa kernel: ata1: SATA link up 3.0 Gbps (SStatus 123 
SControl 300)
Mar 20 14:39:12 mesa kernel: ata1.00: ATA-7, max UDMA/133, 976773168 
sectors: LBA48 NCQ (depth 31/32)
Mar 20 14:39:12 mesa kernel: ata1.00: ata1: dev 0 multi count 16
Mar 20 14:39:12 mesa kernel: ata1.00: configured for UDMA/133
Mar 20 14:39:12 mesa kernel: scsi1 : sata_nv
Mar 20 14:39:12 mesa kernel: ata2: SATA link up 3.0 Gbps (SStatus 123 
SControl 300)
Mar 20 14:39:12 mesa kernel: ata2.00: ATA-7, max UDMA/133, 976773168 
sectors: LBA48 NCQ (depth 31/32)
Mar 20 14:39:12 mesa kernel: ata2.00: ata2: dev 0 multi count 16
Mar 20 14:39:12 mesa kernel: ata2.00: configured for UDMA/133
Mar 20 14:39:12 mesa kernel: scsi 0:0:0:0: Direct-Access     ATA      
ST3500630AS      3.AA PQ: 0 ANSI: 5
Mar 20 14:39:12 mesa kernel: ata1: bounce limit 0xFFFFFFFFFFFFFFFF, 
segment boundary 0xFFFFFFFF, hw segs 61
Mar 20 14:39:12 mesa kernel: SCSI device sda: 976773168 512-byte hdwr 
sectors (500108 MB)
Mar 20 14:39:12 mesa kernel: sda: Write Protect is off
Mar 20 14:39:12 mesa kernel: sda: Mode Sense: 00 3a 00 00
Mar 20 14:39:12 mesa kernel: SCSI device sda: write cache: enabled, read 
cache: enabled, doesn't support DPO or FUA
Mar 20 14:39:12 mesa kernel: SCSI device sda: 976773168 512-byte hdwr 
sectors (500108 MB)
Mar 20 14:39:12 mesa kernel: sda: Write Protect is off
Mar 20 14:39:12 mesa kernel: sda: Mode Sense: 00 3a 00 00
Mar 20 14:39:12 mesa kernel: SCSI device sda: write cache: enabled, read 
cache: enabled, doesn't support DPO or FUA
Mar 20 14:39:12 mesa kernel:  sda: sda1 sda2 sda3
Mar 20 14:39:12 mesa kernel: sd 0:0:0:0: Attached scsi disk sda
Mar 20 14:39:12 mesa kernel: sd 0:0:0:0: Attached scsi generic sg0 type 0
Mar 20 14:39:12 mesa kernel: scsi 1:0:0:0: Direct-Access     ATA      
ST3500630AS      3.AA PQ: 0 ANSI: 5
Mar 20 14:39:12 mesa kernel: ata2: bounce limit 0xFFFFFFFFFFFFFFFF, 
segment boundary 0xFFFFFFFF, hw segs 61
Mar 20 14:39:12 mesa kernel: SCSI device sdb: 976773168 512-byte hdwr 
sectors (500108 MB)
Mar 20 14:39:12 mesa kernel: sdb: Write Protect is off
Mar 20 14:39:12 mesa kernel: sdb: Mode Sense: 00 3a 00 00
Mar 20 14:39:12 mesa kernel: SCSI device sdb: write cache: enabled, read 
cache: enabled, doesn't support DPO or FUA
Mar 20 14:39:12 mesa kernel: SCSI device sdb: 976773168 512-byte hdwr 
sectors (500108 MB)
Mar 20 14:39:12 mesa kernel: sdb: Write Protect is off
Mar 20 14:39:12 mesa kernel: sdb: Mode Sense: 00 3a 00 00
Mar 20 14:39:12 mesa kernel: SCSI device sdb: write cache: enabled, read 
cache: enabled, doesn't support DPO or FUA
Mar 20 14:39:12 mesa kernel:  sdb: sdb1 sdb2 sdb3
Mar 20 14:39:12 mesa kernel: sd 1:0:0:0: Attached scsi disk sdb
Mar 20 14:39:12 mesa kernel: sd 1:0:0:0: Attached scsi generic sg1 type 0
Mar 20 14:39:12 mesa kernel: ACPI: PCI Interrupt Link [LSI1] enabled at 
IRQ 22
Mar 20 14:39:12 mesa kernel: ACPI: PCI Interrupt 0000:00:08.0[A] -> Link 
[LSI1] -> GSI 22 (level, high) -> IRQ 22
Mar 20 14:39:12 mesa kernel: sata_nv 0000:00:08.0: Using ADMA mode
Mar 20 14:39:12 mesa kernel: PCI: Setting latency timer of device 
0000:00:08.0 to 64
Mar 20 14:39:12 mesa kernel: ata3: SATA max UDMA/133 cmd 
0xFFFFC20000006480 ctl 0xFFFFC200000064A0 bmdma 0x1420 irq 22
Mar 20 14:39:12 mesa kernel: ata4: SATA max UDMA/133 cmd 
0xFFFFC20000006580 ctl 0xFFFFC200000065A0 bmdma 0x1428 irq 22
Mar 20 14:39:12 mesa kernel: scsi2 : sata_nv
Mar 20 14:39:12 mesa kernel: ata3: SATA link up 3.0 Gbps (SStatus 123 
SControl 300)
Mar 20 14:39:12 mesa kernel: ata3.00: ATA-7, max UDMA/133, 976773168 
sectors: LBA48 NCQ (depth 31/32)
Mar 20 14:39:12 mesa kernel: ata3.00: ata3: dev 0 multi count 16
Mar 20 14:39:12 mesa kernel: ata3.00: configured for UDMA/133
Mar 20 14:39:12 mesa kernel: scsi3 : sata_nv
Mar 20 14:39:12 mesa kernel: ata4: SATA link down (SStatus 0 SControl 300)
Mar 20 14:39:12 mesa kernel: scsi 2:0:0:0: Direct-Access     ATA      
ST3500630AS      3.AA PQ: 0 ANSI: 5
Mar 20 14:39:12 mesa kernel: ata3: bounce limit 0xFFFFFFFFFFFFFFFF, 
segment boundary 0xFFFFFFFF, hw segs 61
Mar 20 14:39:12 mesa kernel: SCSI device sdc: 976773168 512-byte hdwr 
sectors (500108 MB)
Mar 20 14:39:12 mesa kernel: sdc: Write Protect is off
Mar 20 14:39:12 mesa kernel: sdc: Mode Sense: 00 3a 00 00
Mar 20 14:39:12 mesa kernel: SCSI device sdc: write cache: enabled, read 
cache: enabled, doesn't support DPO or FUA
Mar 20 14:39:12 mesa kernel: SCSI device sdc: 976773168 512-byte hdwr 
sectors (500108 MB)
Mar 20 14:39:12 mesa kernel: sdc: Write Protect is off
Mar 20 14:39:12 mesa kernel: sdc: Mode Sense: 00 3a 00 00
Mar 20 14:39:12 mesa kernel: SCSI device sdc: write cache: enabled, read 
cache: enabled, doesn't support DPO or FUA
Mar 20 14:39:12 mesa kernel:  sdc: sdc1 sdc2 sdc3
Mar 20 14:39:12 mesa kernel: sd 2:0:0:0: Attached scsi disk sdc
Mar 20 14:39:12 mesa kernel: sd 2:0:0:0: Attached scsi generic sg2 type 0
Mar 20 14:39:12 mesa kernel: ACPI: PCI Interrupt Link [LUS2] enabled at 
IRQ 21
Mar 20 14:39:12 mesa kernel: ACPI: PCI Interrupt 0000:00:02.1[B] -> Link 
[LUS2] -> GSI 21 (level, high) -> IRQ 21
Mar 20 14:39:12 mesa kernel: PCI: Setting latency timer of device 
0000:00:02.1 to 64
Mar 20 14:39:12 mesa kernel: ehci_hcd 0000:00:02.1: EHCI Host Controller
Mar 20 14:39:12 mesa kernel: ehci_hcd 0000:00:02.1: new USB bus 
registered, assigned bus number 1
Mar 20 14:39:12 mesa kernel: ehci_hcd 0000:00:02.1: debug port 1
Mar 20 14:39:12 mesa kernel: PCI: cache line size of 64 is not supported 
by device 0000:00:02.1
Mar 20 14:39:12 mesa kernel: ehci_hcd 0000:00:02.1: irq 21, io mem 
0xdd001000
Mar 20 14:39:12 mesa kernel: ehci_hcd 0000:00:02.1: USB 2.0 started, 
EHCI 1.00, driver 10 Dec 2004
Mar 20 14:39:12 mesa kernel: usb usb1: configuration #1 chosen from 1 choice
Mar 20 14:39:12 mesa kernel: hub 1-0:1.0: USB hub found
Mar 20 14:39:12 mesa kernel: hub 1-0:1.0: 10 ports detected
Mar 20 14:39:12 mesa kernel: ohci_hcd: 2006 August 04 USB 1.1 'Open' 
Host Controller (OHCI) Driver (PCI)
Mar 20 14:39:12 mesa kernel: ACPI: PCI Interrupt Link [LUS0] enabled at 
IRQ 20
Mar 20 14:39:12 mesa kernel: ACPI: PCI Interrupt 0000:00:02.0[A] -> Link 
[LUS0] -> GSI 20 (level, high) -> IRQ 20
Mar 20 14:39:12 mesa kernel: PCI: Setting latency timer of device 
0000:00:02.0 to 64
Mar 20 14:39:12 mesa kernel: ohci_hcd 0000:00:02.0: OHCI Host Controller
Mar 20 14:39:12 mesa kernel: ohci_hcd 0000:00:02.0: new USB bus 
registered, assigned bus number 2
Mar 20 14:39:12 mesa kernel: ohci_hcd 0000:00:02.0: irq 20, io mem 
0xdd000000
Mar 20 14:39:12 mesa kernel: usb usb2: configuration #1 chosen from 1 choice
Mar 20 14:39:12 mesa kernel: hub 2-0:1.0: USB hub found
Mar 20 14:39:12 mesa kernel: hub 2-0:1.0: 10 ports detected
Mar 20 14:39:12 mesa kernel: usbcore: registered new interface driver 
libusual
Mar 20 14:39:12 mesa kernel: PNP: PS/2 Controller 
[PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
Mar 20 14:39:12 mesa kernel: serio: i8042 KBD port at 0x60,0x64 irq 1
Mar 20 14:39:12 mesa kernel: mice: PS/2 mouse device common for all mice
Mar 20 14:39:12 mesa kernel: I2O subsystem v1.325
Mar 20 14:39:12 mesa kernel: i2o: max drivers = 8
Mar 20 14:39:12 mesa kernel: md: raid1 personality registered for level 1
Mar 20 14:39:12 mesa kernel: input: AT Translated Set 2 keyboard as 
/class/input/input2
Mar 20 14:39:12 mesa kernel: raid6: int64x1   1669 MB/s
Mar 20 14:39:12 mesa kernel: raid6: int64x2   2250 MB/s
Mar 20 14:39:12 mesa kernel: raid6: int64x4   2364 MB/s
Mar 20 14:39:12 mesa kernel: raid6: int64x8   1610 MB/s
Mar 20 14:39:12 mesa kernel: raid6: sse2x1    2273 MB/s
Mar 20 14:39:12 mesa kernel: raid6: sse2x2    2986 MB/s
Mar 20 14:39:12 mesa kernel: raid6: sse2x4    3203 MB/s
Mar 20 14:39:12 mesa kernel: raid6: using algorithm sse2x4 (3203 MB/s)
Mar 20 14:39:12 mesa kernel: md: raid6 personality registered for level 6
Mar 20 14:39:12 mesa kernel: md: raid5 personality registered for level 5
Mar 20 14:39:12 mesa kernel: md: raid4 personality registered for level 4
Mar 20 14:39:12 mesa kernel: raid5: automatically using best 
checksumming function: generic_sse
Mar 20 14:39:12 mesa kernel:    generic_sse:  5538.000 MB/sec
Mar 20 14:39:12 mesa kernel: raid5: using function: generic_sse 
(5538.000 MB/sec)
Mar 20 14:39:12 mesa kernel: device-mapper: ioctl: 4.11.0-ioctl 
(2006-10-12) initialised: dm-devel@redhat.com
Mar 20 14:39:12 mesa kernel: EDAC MC: Ver: 2.0.1 Mar 18 2007
Mar 20 14:39:12 mesa kernel: TCP cubic registered
Mar 20 14:39:12 mesa kernel: Initializing XFRM netlink socket
Mar 20 14:39:12 mesa kernel: NET: Registered protocol family 1
Mar 20 14:39:12 mesa kernel: NET: Registered protocol family 17
Mar 20 14:39:12 mesa kernel: NET: Registered protocol family 15
Mar 20 14:39:12 mesa kernel: ieee80211: 802.11 data/management/control 
stack, git-1.1.13
Mar 20 14:39:12 mesa kernel: ieee80211: Copyright (C) 2004-2005 Intel 
Corporation <jketreno@linux.intel.com>
Mar 20 14:39:12 mesa kernel: ieee80211_crypt: registered algorithm 'NULL'
Mar 20 14:39:12 mesa kernel: ieee80211_crypt: registered algorithm 'WEP'
Mar 20 14:39:12 mesa kernel: drivers/rtc/hctosys.c: unable to open rtc 
device (rtc0)
Mar 20 14:39:12 mesa kernel: md: Autodetecting RAID arrays.
Mar 20 14:39:12 mesa kernel: md: autorun ...
Mar 20 14:39:12 mesa kernel: md: considering sdc3 ...
Mar 20 14:39:12 mesa kernel: md:  adding sdc3 ...
Mar 20 14:39:12 mesa kernel: md: sdc2 has different UUID to sdc3
Mar 20 14:39:12 mesa kernel: md: sdc1 has different UUID to sdc3
Mar 20 14:39:12 mesa kernel: md:  adding sdb3 ...
Mar 20 14:39:12 mesa kernel: md: sdb2 has different UUID to sdc3
Mar 20 14:39:12 mesa kernel: md: sdb1 has different UUID to sdc3
Mar 20 14:39:12 mesa kernel: md:  adding sda3 ...
Mar 20 14:39:12 mesa kernel: md: sda2 has different UUID to sdc3
Mar 20 14:39:12 mesa kernel: md: sda1 has different UUID to sdc3
Mar 20 14:39:12 mesa kernel: md: created md2
Mar 20 14:39:12 mesa kernel: md: bind<sda3>
Mar 20 14:39:12 mesa kernel: md: bind<sdb3>
Mar 20 14:39:12 mesa kernel: md: bind<sdc3>
Mar 20 14:39:12 mesa kernel: md: running: <sdc3><sdb3><sda3>
Mar 20 14:39:12 mesa kernel: raid5: device sdc3 operational as raid disk 2
Mar 20 14:39:12 mesa kernel: raid5: device sdb3 operational as raid disk 1
Mar 20 14:39:12 mesa kernel: raid5: device sda3 operational as raid disk 0
Mar 20 14:39:12 mesa kernel: raid5: allocated 4262kB for md2
Mar 20 14:39:12 mesa kernel: raid5: raid level 6 set md2 active with 3 
out of 4 devices, algorithm 2
Mar 20 14:39:12 mesa kernel: RAID5 conf printout:
Mar 20 14:39:12 mesa kernel:  --- rd:4 wd:3
Mar 20 14:39:12 mesa kernel:  disk 0, o:1, dev:sda3
Mar 20 14:39:12 mesa kernel:  disk 1, o:1, dev:sdb3
Mar 20 14:39:12 mesa kernel:  disk 2, o:1, dev:sdc3
Mar 20 14:39:12 mesa kernel: md: considering sdc2 ...
Mar 20 14:39:12 mesa kernel: md:  adding sdc2 ...
Mar 20 14:39:12 mesa kernel: md: sdc1 has different UUID to sdc2
Mar 20 14:39:12 mesa kernel: md:  adding sdb2 ...
Mar 20 14:39:12 mesa kernel: md: sdb1 has different UUID to sdc2
Mar 20 14:39:12 mesa kernel: md:  adding sda2 ...
Mar 20 14:39:12 mesa kernel: md: sda1 has different UUID to sdc2
Mar 20 14:39:12 mesa kernel: md: created md1
Mar 20 14:39:12 mesa kernel: md: bind<sda2>
Mar 20 14:39:12 mesa kernel: md: bind<sdb2>
Mar 20 14:39:12 mesa kernel: md: bind<sdc2>
Mar 20 14:39:12 mesa kernel: md: running: <sdc2><sdb2><sda2>
Mar 20 14:39:12 mesa kernel: raid5: device sdc2 operational as raid disk 2
Mar 20 14:39:12 mesa kernel: raid5: device sdb2 operational as raid disk 1
Mar 20 14:39:12 mesa kernel: raid5: device sda2 operational as raid disk 0
Mar 20 14:39:12 mesa kernel: raid5: allocated 4262kB for md1
Mar 20 14:39:12 mesa kernel: raid5: raid level 6 set md1 active with 3 
out of 4 devices, algorithm 2
Mar 20 14:39:12 mesa kernel: RAID5 conf printout:
Mar 20 14:39:12 mesa kernel:  --- rd:4 wd:3
Mar 20 14:39:12 mesa kernel:  disk 0, o:1, dev:sda2
Mar 20 14:39:12 mesa kernel:  disk 1, o:1, dev:sdb2
Mar 20 14:39:12 mesa kernel:  disk 2, o:1, dev:sdc2
Mar 20 14:39:12 mesa kernel: md: considering sdc1 ...
Mar 20 14:39:12 mesa kernel: md:  adding sdc1 ...
Mar 20 14:39:12 mesa kernel: md:  adding sdb1 ...
Mar 20 14:39:12 mesa kernel: md:  adding sda1 ...
Mar 20 14:39:12 mesa kernel: md: created md0
Mar 20 14:39:12 mesa kernel: md: bind<sda1>
Mar 20 14:39:12 mesa kernel: md: bind<sdb1>
Mar 20 14:39:12 mesa kernel: md: bind<sdc1>
Mar 20 14:39:12 mesa kernel: md: running: <sdc1><sdb1><sda1>
Mar 20 14:39:12 mesa kernel: md: md0: raid array is not clean -- 
starting background reconstruction
Mar 20 14:39:12 mesa kernel: raid1: raid set md0 active with 3 out of 4 
mirrors
Mar 20 14:39:12 mesa kernel: md: ... autorun DONE.
Mar 20 14:39:12 mesa kernel: md: resync of RAID array md0
Mar 20 14:39:12 mesa kernel: md: minimum _guaranteed_  speed: 1000 
KB/sec/disk.
Mar 20 14:39:12 mesa kernel: md: using maximum available idle IO 
bandwidth (but not more than 200000 KB/sec) for resync.
Mar 20 14:39:12 mesa kernel: md: using 128k window, over a total of 
19534912 blocks.
Mar 20 14:39:12 mesa kernel: kjournald starting.  Commit interval 5 seconds
Mar 20 14:39:12 mesa kernel: EXT3-fs: mounted filesystem with ordered 
data mode.
Mar 20 14:39:12 mesa kernel: VFS: Mounted root (ext3 filesystem) readonly.
Mar 20 14:39:12 mesa kernel: Freeing unused kernel memory: 344k freed
Mar 20 14:39:12 mesa kernel: Floppy drive(s): fd0 is 1.44M
Mar 20 14:39:12 mesa kernel: FDC 0 is a post-1991 82077
Mar 20 14:39:12 mesa kernel: input: PC Speaker as /class/input/input3
Mar 20 14:39:12 mesa kernel: hdd: ATAPI 24X CD-ROM drive, 256kB Cache, 
UDMA(33)
Mar 20 14:39:12 mesa kernel: Uniform CD-ROM driver Revision: 3.20
Mar 20 14:39:12 mesa kernel: PM: Writing back config space on device 
0000:0a:09.0 at offset b (was 164814e4, writing 164414e4)
Mar 20 14:39:12 mesa kernel: PM: Writing back config space on device 
0000:0a:09.0 at offset 3 (was 804000, writing 804010)
Mar 20 14:39:12 mesa kernel: PM: Writing back config space on device 
0000:0a:09.0 at offset 2 (was 2000000, writing 2000003)
Mar 20 14:39:12 mesa kernel: PM: Writing back config space on device 
0000:0a:09.0 at offset 1 (was 2b00000, writing 2b00106)
Mar 20 14:39:12 mesa kernel: i2c_adapter i2c-0: nForce2 SMBus adapter at 
0x5000
Mar 20 14:39:12 mesa kernel: i2c_adapter i2c-1: nForce2 SMBus adapter at 
0x5040
Mar 20 14:39:12 mesa kernel: Adding 15631096k swap on /dev/md1.  
Priority:-1 extents:1 across:15631096k
Mar 20 14:39:12 mesa kernel: EXT3 FS on md0, internal journal
Mar 20 14:39:12 mesa kernel: NET: Registered protocol family 10
Mar 20 14:39:12 mesa kernel: lo: Disabled Privacy Extensions


dmesg at 1.5Gb/s operation



Linux version 2.6.20.3 (root@mesa) (gcc version 4.1.2 20060928 
(prerelease) (Ubuntu 4.1.1-13ubuntu5)) #1 SMP Sun Mar 18 03:41:44 EDT 2007
Command line: root=/dev/md0 ro
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009b800 (usable)
 BIOS-e820: 000000000009b800 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000d0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000007ff90000 (usable)
 BIOS-e820: 000000007ff90000 - 000000007ff99000 (ACPI data)
 BIOS-e820: 000000007ff99000 - 0000000080000000 (ACPI NVS)
 BIOS-e820: 0000000080000000 - 00000000cff80000 (usable)
 BIOS-e820: 00000000cff80000 - 00000000d0000000 (reserved)
 BIOS-e820: 00000000e0000000 - 00000000e8000000 (reserved)
 BIOS-e820: 00000000fec00000 - 00000000fec00400 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
 BIOS-e820: 00000000fff80000 - 0000000100000000 (reserved)
 BIOS-e820: 0000000100000000 - 0000000200000000 (usable)
Entering add_active_range(0, 0, 155) 0 entries of 3200 used
Entering add_active_range(0, 256, 524176) 1 entries of 3200 used
Entering add_active_range(0, 524288, 851840) 2 entries of 3200 used
Entering add_active_range(0, 1048576, 2097152) 3 entries of 3200 used
end_pfn_map = 2097152
DMI present.
ACPI: RSDP (v000 PTLTD                                 ) @ 
0x00000000000f7040
ACPI: RSDT (v001 PTLTD    RSDT   0x06040000  LTP 0x00000000) @ 
0x000000007ff9542f
ACPI: FADT (v001 NVIDIA CK8S     0x06040000 PTL_ 0x000f4240) @ 
0x000000007ff98d9a
ACPI: SRAT (v001 AMD    HAMMER   0x06040000 AMD  0x00000001) @ 
0x000000007ff98e0e
ACPI: SPCR (v001 PTLTD  $UCRTBL$ 0x06040000 PTL  0x00000001) @ 
0x000000007ff98ef6
ACPI: MADT (v001 PTLTD       APIC   0x06040000  LTP 0x00000000) @ 
0x000000007ff98f46
ACPI: BOOT (v001 PTLTD  $SBFTBL$ 0x06040000  LTP 0x00000001) @ 
0x000000007ff98fd8
ACPI: DSDT (v001 NVIDIA      CK8 0x06040000 MSFT 0x0100000e) @ 
0x0000000000000000
SRAT: PXM 0 -> APIC 0 -> Node 0
SRAT: PXM 0 -> APIC 1 -> Node 0
SRAT: PXM 1 -> APIC 2 -> Node 1
SRAT: PXM 1 -> APIC 3 -> Node 1
SRAT: Node 0 PXM 0 0-a0000
Entering add_active_range(0, 0, 155) 0 entries of 3200 used
SRAT: Node 0 PXM 0 0-d0000000
Entering add_active_range(0, 0, 155) 1 entries of 3200 used
Entering add_active_range(0, 256, 524176) 1 entries of 3200 used
Entering add_active_range(0, 524288, 851840) 2 entries of 3200 used
SRAT: Node 1 PXM 1 100000000-200000000
Entering add_active_range(1, 1048576, 2097152) 3 entries of 3200 used
NUMA: Using 32 for the hash shift.
Bootmem setup node 0 0000000000000000-00000000d0000000
Bootmem setup node 1 0000000100000000-0000000200000000
Zone PFN ranges:
  DMA             0 ->     4096
  DMA32        4096 ->  1048576
  Normal    1048576 ->  2097152
early_node_map[4] active PFN ranges
    0:        0 ->      155
    0:      256 ->   524176
    0:   524288 ->   851840
    1:  1048576 ->  2097152
On node 0 totalpages: 851627
  DMA zone: 56 pages used for memmap
  DMA zone: 1343 pages reserved
  DMA zone: 2596 pages, LIFO batch:0
  DMA32 zone: 11590 pages used for memmap
  DMA32 zone: 836042 pages, LIFO batch:31
  Normal zone: 0 pages used for memmap
On node 1 totalpages: 1048576
  DMA zone: 0 pages used for memmap
  DMA32 zone: 0 pages used for memmap
  Normal zone: 14336 pages used for memmap
  Normal zone: 1034240 pages, LIFO batch:31
Nvidia board detected. Ignoring ACPI timer override.
If you got timer trouble try acpi_use_timer_override
ACPI: PM-Timer IO Port: 0x8008
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
Processor #0 (Bootup-CPU)
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
Processor #1
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
Processor #2
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] enabled)
Processor #3
ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x03] high edge lint[0x1])
ACPI: IOAPIC (id[0x04] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 4, address 0xfec00000, GSI 0-23
ACPI: IOAPIC (id[0x05] address[0xdf200000] gsi_base[24])
IOAPIC[1]: apic_id 5, address 0xdf200000, GSI 24-27
ACPI: IOAPIC (id[0x06] address[0xdf201000] gsi_base[28])
IOAPIC[2]: apic_id 6, address 0xdf201000, GSI 28-31
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
ACPI: IRQ9 used by override.
Setting APIC routing to flat
Using ACPI (MADT) for SMP configuration information
Nosave address range: 000000000009b000 - 000000000009c000
Nosave address range: 000000000009c000 - 00000000000a0000
Nosave address range: 00000000000a0000 - 00000000000d0000
Nosave address range: 00000000000d0000 - 0000000000100000
Nosave address range: 000000007ff90000 - 000000007ff99000
Nosave address range: 000000007ff99000 - 0000000080000000
Nosave address range: 00000000cff80000 - 00000000d0000000
Nosave address range: 00000000d0000000 - 00000000e0000000
Nosave address range: 00000000e0000000 - 00000000e8000000
Nosave address range: 00000000e8000000 - 00000000fec00000
Nosave address range: 00000000fec00000 - 00000000fee00000
Nosave address range: 00000000fee00000 - 00000000fee01000
Nosave address range: 00000000fee01000 - 00000000fff80000
Nosave address range: 00000000fff80000 - 0000000100000000
Allocating PCI resources starting at ea000000 (gap: e8000000:16c00000)
PERCPU: Allocating 32768 bytes of per cpu data
Built 2 zonelists.  Total pages: 1872878
Kernel command line: root=/dev/md0 ro
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 32768 bytes)
Console: colour VGA+ 80x25
Dentry cache hash table entries: 1048576 (order: 11, 8388608 bytes)
Inode-cache hash table entries: 524288 (order: 10, 4194304 bytes)
Checking aperture...
CPU 0: aperture @ 0 size 32 MB
No AGP bridge found
Your BIOS doesn't leave a aperture memory hole
Please enable the IOMMU option in the BIOS setup
This costs you 64 MB of RAM
Mapping aperture over 65536 KB of RAM @ 8000000
Memory: 7413304k/8388608k available (3161k kernel code, 187508k 
reserved, 1297k data, 344k init)
Calibrating delay using timer specific routine.. 3618.36 BogoMIPS 
(lpj=18091843)
Mount-cache hash table entries: 256
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 1024K (64 bytes/line)
CPU 0/0 -> Node 0
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
Freeing SMP alternatives: 36k freed
ACPI: Core revision 20060707
Using local APIC timer interrupts.
result 12558056
Detected 12.558 MHz APIC timer.
Booting processor 1/4 APIC 0x1
Initializing CPU#1
Calibrating delay using timer specific routine.. 3616.73 BogoMIPS 
(lpj=18083693)
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 1024K (64 bytes/line)
CPU 1/1 -> Node 0
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
Dual Core AMD Opteron(tm) Processor 265 stepping 02
CPU 1: Syncing TSC to CPU 0.
CPU 1: synchronized TSC with CPU 0 (last diff 21 cycles, maxerr 514 cycles)
Booting processor 2/4 APIC 0x2
Initializing CPU#2
Calibrating delay using timer specific routine.. 3616.80 BogoMIPS 
(lpj=18084033)
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 1024K (64 bytes/line)
CPU 2/2 -> Node 1
CPU: Physical Processor ID: 1
CPU: Processor Core ID: 0
Dual Core AMD Opteron(tm) Processor 265 stepping 02
CPU 2: Syncing TSC to CPU 0.
CPU 2: synchronized TSC with CPU 0 (last diff -5 cycles, maxerr 1019 cycles)
Booting processor 3/4 APIC 0x3
Initializing CPU#3
Calibrating delay using timer specific routine.. 3616.76 BogoMIPS 
(lpj=18083802)
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 1024K (64 bytes/line)
CPU 3/3 -> Node 1
CPU: Physical Processor ID: 1
CPU: Processor Core ID: 1
Dual Core AMD Opteron(tm) Processor 265 stepping 02
CPU 3: Syncing TSC to CPU 0.
CPU 3: synchronized TSC with CPU 0 (last diff 7 cycles, maxerr 995 cycles)
Brought up 4 CPUs
testing NMI watchdog ... OK.
Disabling vsyscall due to use of PM timer
time.c: Using 3.579545 MHz WALL PM GTOD PM timer.
time.c: Detected 1808.359 MHz processor.
migration_cost=400,763
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: Using configuration type 1
ACPI: Interpreter enabled
ACPI: Using IOAPIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
PCI: Probing PCI hardware (bus 00)
ACPI: Assume root bridge [\_SB_.PCI0] bus is 0
Boot video device is 0000:01:07.0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P2P0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.XVR0._PRT]
ACPI: PCI Interrupt Link [LNK1] (IRQs 16 17 18 19) *0
ACPI: PCI Interrupt Link [LNK2] (IRQs 16 17 18 19) *0
ACPI: PCI Interrupt Link [LNK3] (IRQs 16 17 18 19) *0
ACPI: PCI Interrupt Link [LNK4] (IRQs 16 17 18 19) *0, disabled.
ACPI: PCI Interrupt Link [LNK5] (IRQs 16 17 18 19) *0, disabled.
ACPI: PCI Interrupt Link [LSMB] (IRQs 20 21 22 23) *0, disabled.
ACPI: PCI Interrupt Link [LUS0] (IRQs 20 21 22 23) *0
ACPI: PCI Interrupt Link [LUS2] (IRQs 20 21 22 23) *0
ACPI: PCI Interrupt Link [LMAC] (IRQs 20 21 22 23) *0, disabled.
ACPI: PCI Interrupt Link [LACI] (IRQs 20 21 22 23) *0, disabled.
ACPI: PCI Interrupt Link [LMCI] (IRQs 20 21 22 23) *0, disabled.
ACPI: PCI Interrupt Link [LPID] (IRQs 20 21 22 23) *0, disabled.
ACPI: PCI Interrupt Link [LTID] (IRQs 20 21 22 23) *0
ACPI: PCI Interrupt Link [LSI1] (IRQs 20 21 22 23) *0, disabled.
ACPI: PCI Interrupt Link [APCP] (IRQs 20 21 22 23) *0, disabled.
ACPI: PCI Root Bridge [PCI2] (0000:08)
PCI: Probing PCI hardware (bus 08)
ACPI: Assume root bridge [\_SB_.PCI0] bus is 0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI2.G0PA._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI2.G0PB._PRT]
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
pnp: PnP ACPI: found 15 devices
SCSI subsystem initialized
libata version 2.00 loaded.
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a 
report
PCI-DMA: Disabling AGP.
PCI-DMA: aperture base @ 8000000 size 65536 KB
PCI-DMA: using GART IOMMU.
PCI-DMA: Reserving 64MB of IOMMU area in the AGP aperture
pnp: 00:08: ioport range 0x8000-0x807f could not be reserved
pnp: 00:08: ioport range 0x8080-0x80ff has been reserved
pnp: 00:08: ioport range 0x8400-0x847f has been reserved
pnp: 00:08: ioport range 0x8480-0x84ff has been reserved
pnp: 00:08: ioport range 0x8800-0x887f has been reserved
pnp: 00:08: ioport range 0x8880-0x88ff has been reserved
pnp: 00:08: ioport range 0x5000-0x503f has been reserved
pnp: 00:08: ioport range 0x5040-0x507f has been reserved
PCI: Bridge: 0000:00:09.0
  IO window: 2000-2fff
  MEM window: dd100000-deffffff
  PREFETCH window: ea000000-ea0fffff
PCI: Bridge: 0000:00:0e.0
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Setting latency timer of device 0000:00:09.0 to 64
PCI: Setting latency timer of device 0000:00:0e.0 to 64
PCI: Bridge: 0000:08:0a.0
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Bridge: 0000:08:0b.0
  IO window: disabled.
  MEM window: df300000-df3fffff
  PREFETCH window: ea100000-ea1fffff
NET: Registered protocol family 2
IP route cache hash table entries: 262144 (order: 9, 2097152 bytes)
TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
TCP: Hash tables configured (established 262144 bind 65536)
TCP reno registered
Simple Boot Flag at 0x36 set to 0x1
audit: initializing netlink socket (disabled)
audit(1174423416.270:1): initialized
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
SGI XFS with ACLs, security attributes, large block/inode numbers, no 
debug enabled
SGI XFS Quota Management subsystem
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
PCI: Found disabled HT MSI Mapping on 0000:00:0e.0
PCI: Found enabled HT MSI Mapping on 0000:00:00.0
PCI: MSI quirk detected. PCI_BUS_FLAGS_NO_MSI set for 0000:08:0a.0 
subordinate bus.
PCI: MSI quirk detected. PCI_BUS_FLAGS_NO_MSI set for 0000:08:0b.0 
subordinate bus.
PCI: Setting latency timer of device 0000:00:0e.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:0e.0:pcie00]
vga16fb: initializing
vga16fb: mapped to 0xffff8100000a0000
fb0: VGA16 VGA frame buffer device
input: Power Button (FF) as /class/input/input0
ACPI: Power Button (FF) [PWRF]
input: Power Button (CM) as /class/input/input1
ACPI: Power Button (CM) [PWRB]
Real Time Clock Driver v1.12ac
Linux agpgart interface v0.101 (c) Dave Jones
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
00:02: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
00:03: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
RAMDISK driver initialized: 16 RAM disks of 65536K size 1024 blocksize
loop: loaded (max 8 devices)
tg3.c:v3.72 (January 8, 2007)
ACPI: PCI Interrupt 0000:0a:09.0[A] -> GSI 28 (level, low) -> IRQ 28
eth0: Tigon3 [partno(BCM95704A7) rev 2003 PHY(5704)] 
(PCIX:133MHz:64-bit) 10/100/1000Base-T Ethernet 00:e0:81:34:55:d4
eth0: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] Split[0] WireSpeed[1] 
TSOcap[1]
eth0: dma_rwctrl[769f4000] dma_mask[64-bit]
ACPI: PCI Interrupt 0000:0a:09.1[B] -> GSI 29 (level, low) -> IRQ 29
eth1: Tigon3 [partno(BCM95704A7) rev 2003 PHY(5704)] 
(PCIX:133MHz:64-bit) 10/100/1000Base-T Ethernet 00:e0:81:34:55:d5
eth1: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] Split[0] WireSpeed[1] 
TSOcap[1]
eth1: dma_rwctrl[769f4000] dma_mask[64-bit]
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
NFORCE-CK804: IDE controller at PCI slot 0000:00:06.0
NFORCE-CK804: chipset revision 242
NFORCE-CK804: not 100% native mode: will probe irqs later
NFORCE-CK804: 0000:00:06.0 (rev f2) UDMA133 controller
    ide0: BM-DMA at 0x1400-0x1407, BIOS settings: hda:pio, hdb:pio
    ide1: BM-DMA at 0x1408-0x140f, BIOS settings: hdc:pio, hdd:DMA
Probing IDE interface ide0...
Probing IDE interface ide1...
hdd: CD-224E-N, ATAPI CD/DVD-ROM drive
ide1 at 0x170-0x177,0x376 on irq 15
sata_nv 0000:00:07.0: version 3.2
ACPI: PCI Interrupt Link [LTID] enabled at IRQ 23
ACPI: PCI Interrupt 0000:00:07.0[A] -> Link [LTID] -> GSI 23 (level, 
high) -> IRQ 23
sata_nv 0000:00:07.0: Using ADMA mode
PCI: Setting latency timer of device 0000:00:07.0 to 64
ata1: SATA max UDMA/133 cmd 0xFFFFC20000004480 ctl 0xFFFFC200000044A0 
bmdma 0x1410 irq 23
ata2: SATA max UDMA/133 cmd 0xFFFFC20000004580 ctl 0xFFFFC200000045A0 
bmdma 0x1418 irq 23
scsi0 : sata_nv
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1.00: ATA-7, max UDMA/133, 976773168 sectors: LBA48 NCQ (depth 31/32)
ata1.00: ata1: dev 0 multi count 16
ata1.00: configured for UDMA/133
scsi1 : sata_nv
ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata2.00: ATA-7, max UDMA/133, 976773168 sectors: LBA48 NCQ (depth 31/32)
ata2.00: ata2: dev 0 multi count 16
ata2.00: configured for UDMA/133
scsi 0:0:0:0: Direct-Access     ATA      ST3500630AS      3.AA PQ: 0 ANSI: 5
ata1: bounce limit 0xFFFFFFFFFFFFFFFF, segment boundary 0xFFFFFFFF, hw 
segs 61
SCSI device sda: 976773168 512-byte hdwr sectors (500108 MB)
sda: Write Protect is off
sda: Mode Sense: 00 3a 00 00
SCSI device sda: write cache: enabled, read cache: enabled, doesn't 
support DPO or FUA
SCSI device sda: 976773168 512-byte hdwr sectors (500108 MB)
sda: Write Protect is off
sda: Mode Sense: 00 3a 00 00
SCSI device sda: write cache: enabled, read cache: enabled, doesn't 
support DPO or FUA
 sda: sda1 sda2 sda3
sd 0:0:0:0: Attached scsi disk sda
sd 0:0:0:0: Attached scsi generic sg0 type 0
scsi 1:0:0:0: Direct-Access     ATA      ST3500630AS      3.AA PQ: 0 ANSI: 5
ata2: bounce limit 0xFFFFFFFFFFFFFFFF, segment boundary 0xFFFFFFFF, hw 
segs 61
SCSI device sdb: 976773168 512-byte hdwr sectors (500108 MB)
sdb: Write Protect is off
sdb: Mode Sense: 00 3a 00 00
SCSI device sdb: write cache: enabled, read cache: enabled, doesn't 
support DPO or FUA
SCSI device sdb: 976773168 512-byte hdwr sectors (500108 MB)
sdb: Write Protect is off
sdb: Mode Sense: 00 3a 00 00
SCSI device sdb: write cache: enabled, read cache: enabled, doesn't 
support DPO or FUA
 sdb: sdb1 sdb2 sdb3
sd 1:0:0:0: Attached scsi disk sdb
sd 1:0:0:0: Attached scsi generic sg1 type 0
ACPI: PCI Interrupt Link [LSI1] enabled at IRQ 22
ACPI: PCI Interrupt 0000:00:08.0[A] -> Link [LSI1] -> GSI 22 (level, 
high) -> IRQ 22
sata_nv 0000:00:08.0: Using ADMA mode
PCI: Setting latency timer of device 0000:00:08.0 to 64
ata3: SATA max UDMA/133 cmd 0xFFFFC20000006480 ctl 0xFFFFC200000064A0 
bmdma 0x1420 irq 22
ata4: SATA max UDMA/133 cmd 0xFFFFC20000006580 ctl 0xFFFFC200000065A0 
bmdma 0x1428 irq 22
scsi2 : sata_nv
ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata3.00: ATA-7, max UDMA/133, 976773168 sectors: LBA48 NCQ (depth 31/32)
ata3.00: ata3: dev 0 multi count 16
ata3.00: configured for UDMA/133
scsi3 : sata_nv
ata4: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata4.00: ATA-7, max UDMA/133, 976773168 sectors: LBA48 NCQ (depth 31/32)
ata4.00: ata4: dev 0 multi count 16
ata4.00: configured for UDMA/133
scsi 2:0:0:0: Direct-Access     ATA      ST3500630AS      3.AA PQ: 0 ANSI: 5
ata3: bounce limit 0xFFFFFFFFFFFFFFFF, segment boundary 0xFFFFFFFF, hw 
segs 61
SCSI device sdc: 976773168 512-byte hdwr sectors (500108 MB)
sdc: Write Protect is off
sdc: Mode Sense: 00 3a 00 00
SCSI device sdc: write cache: enabled, read cache: enabled, doesn't 
support DPO or FUA
SCSI device sdc: 976773168 512-byte hdwr sectors (500108 MB)
sdc: Write Protect is off
sdc: Mode Sense: 00 3a 00 00
SCSI device sdc: write cache: enabled, read cache: enabled, doesn't 
support DPO or FUA
 sdc: sdc1 sdc2 sdc3
sd 2:0:0:0: Attached scsi disk sdc
sd 2:0:0:0: Attached scsi generic sg2 type 0
scsi 3:0:0:0: Direct-Access     ATA      ST3500630AS      3.AA PQ: 0 ANSI: 5
ata4: bounce limit 0xFFFFFFFFFFFFFFFF, segment boundary 0xFFFFFFFF, hw 
segs 61
SCSI device sdd: 976773168 512-byte hdwr sectors (500108 MB)
sdd: Write Protect is off
sdd: Mode Sense: 00 3a 00 00
SCSI device sdd: write cache: enabled, read cache: enabled, doesn't 
support DPO or FUA
SCSI device sdd: 976773168 512-byte hdwr sectors (500108 MB)
sdd: Write Protect is off
sdd: Mode Sense: 00 3a 00 00
SCSI device sdd: write cache: enabled, read cache: enabled, doesn't 
support DPO or FUA
 sdd: sdd1 sdd2 sdd3
sd 3:0:0:0: Attached scsi disk sdd
sd 3:0:0:0: Attached scsi generic sg3 type 0
ACPI: PCI Interrupt Link [LUS2] enabled at IRQ 21
ACPI: PCI Interrupt 0000:00:02.1[B] -> Link [LUS2] -> GSI 21 (level, 
high) -> IRQ 21
PCI: Setting latency timer of device 0000:00:02.1 to 64
ehci_hcd 0000:00:02.1: EHCI Host Controller
ehci_hcd 0000:00:02.1: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:02.1: debug port 1
PCI: cache line size of 64 is not supported by device 0000:00:02.1
ehci_hcd 0000:00:02.1: irq 21, io mem 0xdd001000
ehci_hcd 0000:00:02.1: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 10 ports detected
ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver (PCI)
ACPI: PCI Interrupt Link [LUS0] enabled at IRQ 20
ACPI: PCI Interrupt 0000:00:02.0[A] -> Link [LUS0] -> GSI 20 (level, 
high) -> IRQ 20
PCI: Setting latency timer of device 0000:00:02.0 to 64
ohci_hcd 0000:00:02.0: OHCI Host Controller
ohci_hcd 0000:00:02.0: new USB bus registered, assigned bus number 2
ohci_hcd 0000:00:02.0: irq 20, io mem 0xdd000000
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 10 ports detected
usbcore: registered new interface driver libusual
PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
mice: PS/2 mouse device common for all mice
I2O subsystem v1.325
i2o: max drivers = 8
md: raid1 personality registered for level 1
input: AT Translated Set 2 keyboard as /class/input/input2
raid6: int64x1   1660 MB/s
raid6: int64x2   2241 MB/s
raid6: int64x4   2333 MB/s
raid6: int64x8   1620 MB/s
raid6: sse2x1    2303 MB/s
raid6: sse2x2    2999 MB/s
raid6: sse2x4    3260 MB/s
raid6: using algorithm sse2x4 (3260 MB/s)
md: raid6 personality registered for level 6
md: raid5 personality registered for level 5
md: raid4 personality registered for level 4
raid5: automatically using best checksumming function: generic_sse
   generic_sse:  5538.000 MB/sec
raid5: using function: generic_sse (5538.000 MB/sec)
device-mapper: ioctl: 4.11.0-ioctl (2006-10-12) initialised: 
dm-devel@redhat.com
EDAC MC: Ver: 2.0.1 Mar 18 2007
TCP cubic registered
Initializing XFRM netlink socket
NET: Registered protocol family 1
NET: Registered protocol family 17
NET: Registered protocol family 15
ieee80211: 802.11 data/management/control stack, git-1.1.13
ieee80211: Copyright (C) 2004-2005 Intel Corporation 
<jketreno@linux.intel.com>
ieee80211_crypt: registered algorithm 'NULL'
ieee80211_crypt: registered algorithm 'WEP'
drivers/rtc/hctosys.c: unable to open rtc device (rtc0)
md: Autodetecting RAID arrays.
md: autorun ...
md: considering sdd3 ...
md:  adding sdd3 ...
md: sdd2 has different UUID to sdd3
md: sdd1 has different UUID to sdd3
md:  adding sdc3 ...
md: sdc2 has different UUID to sdd3
md: sdc1 has different UUID to sdd3
md:  adding sdb3 ...
md: sdb2 has different UUID to sdd3
md: sdb1 has different UUID to sdd3
md:  adding sda3 ...
md: sda2 has different UUID to sdd3
md: sda1 has different UUID to sdd3
md: created md2
md: bind<sda3>
md: bind<sdb3>
md: bind<sdc3>
md: bind<sdd3>
md: running: <sdd3><sdc3><sdb3><sda3>
raid5: device sdc3 operational as raid disk 2
raid5: device sdb3 operational as raid disk 1
raid5: device sda3 operational as raid disk 0
raid5: allocated 4262kB for md2
raid5: raid level 6 set md2 active with 3 out of 4 devices, algorithm 2
RAID5 conf printout:
 --- rd:4 wd:3
 disk 0, o:1, dev:sda3
 disk 1, o:1, dev:sdb3
 disk 2, o:1, dev:sdc3
md: considering sdd2 ...
RAID5 conf printout:
 --- rd:4 wd:3
 disk 0, o:1, dev:sda3
 disk 1, o:1, dev:sdb3
 disk 2, o:1, dev:sdc3
 disk 3, o:1, dev:sdd3
md: recovery of RAID array md2
md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
md: using maximum available idle IO bandwidth (but not more than 200000 
KB/sec) for recovery.
md: using 128k window, over a total of 461033280 blocks.
md:  adding sdd2 ...
md: sdd1 has different UUID to sdd2
md:  adding sdc2 ...
md: sdc1 has different UUID to sdd2
md:  adding sdb2 ...
md: sdb1 has different UUID to sdd2
md:  adding sda2 ...
md: sda1 has different UUID to sdd2
md: created md1
md: bind<sda2>
md: bind<sdb2>
md: bind<sdc2>
md: bind<sdd2>
md: running: <sdd2><sdc2><sdb2><sda2>
raid5: device sdd2 operational as raid disk 3
raid5: device sdc2 operational as raid disk 2
raid5: device sdb2 operational as raid disk 1
raid5: device sda2 operational as raid disk 0
raid5: allocated 4262kB for md1
raid5: raid level 6 set md1 active with 4 out of 4 devices, algorithm 2
RAID5 conf printout:
 --- rd:4 wd:4
 disk 0, o:1, dev:sda2
 disk 1, o:1, dev:sdb2
 disk 2, o:1, dev:sdc2
 disk 3, o:1, dev:sdd2
md: considering sdd1 ...
md:  adding sdd1 ...
md:  adding sdc1 ...
md:  adding sdb1 ...
md:  adding sda1 ...
md: created md0
md: bind<sda1>
md: bind<sdb1>
md: bind<sdc1>
md: bind<sdd1>
md: running: <sdd1><sdc1><sdb1><sda1>
raid1: raid set md0 active with 4 out of 4 mirrors
md: ... autorun DONE.
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
VFS: Mounted root (ext3 filesystem) readonly.
Freeing unused kernel memory: 344k freed
Floppy drive(s): fd0 is 1.44M
FDC 0 is a post-1991 82077
input: PC Speaker as /class/input/input3
PM: Writing back config space on device 0000:0a:09.0 at offset b (was 
164814e4, writing 164414e4)
PM: Writing back config space on device 0000:0a:09.0 at offset 3 (was 
804000, writing 804010)
PM: Writing back config space on device 0000:0a:09.0 at offset 2 (was 
2000000, writing 2000003)
PM: Writing back config space on device 0000:0a:09.0 at offset 1 (was 
2b00000, writing 2b00106)
hdd: ATAPI 24X CD-ROM drive, 256kB Cache, UDMA(33)
Uniform CD-ROM driver Revision: 3.20
i2c_adapter i2c-0: nForce2 SMBus adapter at 0x5000
i2c_adapter i2c-1: nForce2 SMBus adapter at 0x5040
Adding 15631096k swap on /dev/md1.  Priority:-1 extents:1 across:15631096k
EXT3 FS on md0, internal journal
tg3: eth0: Link is up at 100 Mbps, full duplex.
tg3: eth0: Flow control is off for TX and off for RX.
NET: Registered protocol family 10
lo: Disabled Privacy Extensions



