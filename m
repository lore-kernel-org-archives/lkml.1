Return-Path: <linux-kernel-owner+w=401wt.eu-S1752904AbYCIHii@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752904AbYCIHii (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2008 03:38:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751849AbYCIHi3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Mar 2008 03:38:29 -0400
Received: from smtp04.mtu.ru ([62.5.255.51]:55345 "EHLO smtp04.mtu.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751809AbYCIHi2 (ORCPT <rfc822; linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2008 03:38:28 -0400
From: Andrey Borzenkov <arvidjaar@mail.ru>
Subject: Re: [Regression] 2.6.25-rc4-git3: Handling of audio CDs broken on pata_ali
To: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
Date: Sun, 09 Mar 2008 10:38:23 +0300
References: <200803082246.47987.rjw@sisk.pl>
User-Agent: KNode/0.10.9
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
Message-Id: <20080309073824.902DC82CF2E@smtp04.mtu.ru>
X-DCC-STREAM-Metrics: smtp04.mtu.ru 10002; Body=0 Fuz1=0 Fuz2=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:

> Hi,
> 
> On one of my test boxes I'm unable to do just about anything with audio
> CDs using the current -git (2.6.24 is fine in that respect on the same
> box).
> 
> When an audio CD is inserted into the drive, I get the following errors in
> dmesg and nothing more happens (quite obviously):
> 
> ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
> ata1.00: cmd a0/01:00:00:10:00/00:00:00:00:00/a0 tag 0 dma 16400 in
>          cdb 42 02 40 01 00 00 00 00  10 00 00 00 00 00 00 00
>          res 40/00:00:00:18:00/00:00:00:00:00/a0 Emask 0x4 (timeout)
> ata1.00: status: { DRDY }
> ata1: soft resetting link
> ata1.00: configured for UDMA/33
> ata1: EH complete
> ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
> ata1.00: cmd a0/01:00:00:10:00/00:00:00:00:00/a0 tag 0 dma 16400 in
>          cdb 42 02 40 01 00 00 00 00  10 00 00 00 00 00 00 00
>          res 40/00:00:00:18:00/00:00:00:00:00/a0 Emask 0x4 (timeout)
> ata1.00: status: { DRDY }
> ata1: port is slow to respond, please be patient (Status 0x80)
> ata1: device not ready (errno=-16), forcing hardreset
> ata1: soft resetting link
> ata1.00: qc timeout (cmd 0xa1)
> ata1.00: failed to IDENTIFY (I/O error, err_mask=0x4)
> ata1.00: revalidation failed (errno=-5)
> ata1: failed to recover some devices, retrying in 5 secs
> ata1: port is slow to respond, please be patient (Status 0x80)
> ata1: device not ready (errno=-16), forcing hardreset
> ata1: soft resetting link
> ata1.00: qc timeout (cmd 0xa1)
> ata1.00: failed to IDENTIFY (I/O error, err_mask=0x4)
> ata1.00: revalidation failed (errno=-5)
> ata1: failed to recover some devices, retrying in 5 secs
> ata1: port is slow to respond, please be patient (Status 0x80)
> ata1: device not ready (errno=-16), forcing hardreset
> ata1: soft resetting link
> ata1.00: qc timeout (cmd 0xa1)
> ata1.00: failed to IDENTIFY (I/O error, err_mask=0x4)
> ata1.00: revalidation failed (errno=-5)
> ata1.00: disabled
> 
> where ata1 is:
> 
> scsi0 : pata_ali
> scsi1 : pata_ali

Oh, is it only with audio CDs? I am unable to use DVD on pata_ali in DMA at
all. Have you tried to disable ATAPI DMA (libata.dma=1)?


> ata1: PATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 0xff00 irq 14
> ata2: PATA max UDMA/133 cmd 0x170 ctl 0x376 bmdma 0xff08 irq 15
> ata1.00: ATAPI: TSSTcorpCD/DVDW SH-S182M, SB03, max UDMA/33
> ata1.00: configured for UDMA/33
> scsi 0:0:0:0: CD-ROM            TSSTcorp CD/DVDW SH-S182M SB03 PQ: 0 ANSI:
> 5
> 
> (full dmesg attached).
> 
> I can't reproduce this problem on my other test boxes, so I think it's
> related to pata_ali rather than anything else.
> 
> In principle I can try to find the commit that caused this problem to
> occur, but that would be rather tedious, so if anyone has any ideas of
> what's up, please let me know.
> 
> Thanks,
> Rafael


