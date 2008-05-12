Return-Path: <linux-kernel-owner+w=401wt.eu-S1756049AbYELW2w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756049AbYELW2w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 18:28:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754397AbYELW2n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 18:28:43 -0400
Received: from mta5.adelphia.net ([68.168.78.187]:46100 "EHLO
	mta5.adelphia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754039AbYELW2m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 18:28:42 -0400
X-Greylist: delayed 1080 seconds by postgrey-1.27 at vger.kernel.org; Mon, 12 May 2008 18:28:42 EDT
Message-ID: <4828C05E.1010201@comcast.net>
Date: Mon, 12 May 2008 18:10:38 -0400
From: Bradley Chapman <kakadu84@comcast.net>
Reply-To: kakadu84@comcast.net
User-Agent: Mozilla-Thunderbird 2.0.0.9 (X11/20080109)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Command-line tools for stress-testing SATA hard disks (and libata)
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Please CC me on replies.)

I have a new(ish) 160GB Maxtor SATA hard disk that recently cracked up 
and failed with lots of ext3 filesystem errors; beforehand, it had 
started to become flaky and was stalling under certain I/O conditions, 
emitting DRDY ABRTs to the libata layer and forcing constant link 
resets. At the moment, the disk appears to be unbootable - GRUB fails to 
load the stage 2 loader and hangs after loading stage1.5.
Unfortunately, these problems were reproduced on tainted 2.6.24 and 
2.6.25 kernels (specifically, fglrx was doing the tainting). Ergo, I'm 
not formally reporting this as a libata problem (yet).

Can anyone here recommend a command-line disk benchmark or stress test 
utility that doesn't need to be run in X (allowing me to test with 
untainted kernels) and would be capable of producing a variety of I/O 
access patterns that could trigger the errors I've seen during normal 
usage? I've since replaced the SATA cable and switched the hard disk to 
a different SATA PHY port, and when I mount individual partitions and 
access files, the libata layer appears to behave.

Brad

P.S: The 2.6.25.3 libata reports the potentially broken disk as follows:

sata_nv 0000:00:0d.0: version 3.5
...
ata4: SATA max UDMA/133 cmd 0x970 ctl 0xb70 bmdma 0xe008 irq 23
...
ata4: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata4.00: ATA-7: MAXTOR STM3160815AS, 3.AAD, max UDMA/133
ata4.00: 312581808 sectors, multi 1: LBA48 NCQ (depth 0/32)
ata4.00: configured for UDMA/133
scsi 3:0:0:0: Direct-Access     ATA      MAXTOR STM316081 3.AA PQ: 0 ANSI: 5
sd 3:0:0:0: [sdb] 312581808 512-byte hardware sectors (160042 MB)
sd 3:0:0:0: [sdb] Write Protect is off
sd 3:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 3:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't 
support DPO or FUA
sd 3:0:0:0: [sdb] 312581808 512-byte hardware sectors (160042 MB)
sd 3:0:0:0: [sdb] Write Protect is off
sd 3:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 3:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't 
support DPO or FUA
  sdb: sdb1 sdb2 sdb3 sdb4 < sdb5 sdb6 sdb7 sdb8 sdb9 sdb10 >
sd 3:0:0:0: [sdb] Attached SCSI disk
