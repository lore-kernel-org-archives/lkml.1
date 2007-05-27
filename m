Return-Path: <linux-kernel-owner+w=401wt.eu-S1757702AbXE0PBb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757702AbXE0PBb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2007 11:01:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753859AbXE0PBW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 May 2007 11:01:22 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:27058 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753566AbXE0PBV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2007 11:01:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=UUZsIqaxsotRWn62zxxHzHVcHoLvvPYmUI0mrzgp0aCQmfaFFanLPLojTm0yw6pk7RYViF+KzMupe1Lvvr7B+JMS3BGbN5O/vLx3KG99VL/3ZNTIINbNsGRnIMJLMhMzVVEUxXQ3EUfmZP1xV3Rq79twX6kzJz0a+WIeUUZJgzY=
Message-ID: <9d2cd630705270801m2826be60p3f802c502b26c531@mail.gmail.com>
Date: Sun, 27 May 2007 17:01:19 +0200
From: "Gregor Jasny" <gjasny@googlemail.com>
To: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Re: Linux v2.6.22-rc3
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Jeff Garzik" <jgarzik@pobox.com>, linux-ide@vger.kernel.org,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>
In-Reply-To: <alpine.LFD.0.98.0705252008210.26602@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.LFD.0.98.0705252008210.26602@woody.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

2007/5/26, Linus Torvalds <torvalds@linux-foundation.org>:
> What more could you possibly want? Some ATA updates? USB suspend problem

22-rc3 broke the CDROM in my Dell notebook.  After I've switched to
libata som time ago, I've got some delays/timeouts during boot [1].
But the drive works as expected. With 2.6.22-rc3 I've got the
following messages during bootup:

[   19.343211] ata_piix 0000:00:07.1: version 2.11
[   19.343598] scsi0 : ata_piix
[   19.344068] scsi1 : ata_piix
[   19.344426] ata1: PATA max UDMA/33 cmd 0x000101f0 ctl 0x000103f6
bmdma 0x00010860 irq 14
[   19.345135] ata2: PATA max UDMA/33 cmd 0x00010170 ctl 0x00010376
bmdma 0x00010868 irq 15
[    0.653333] Marking TSC unstable due to: possible TSC halt in C2.
[    0.656666] Time: acpi_pm clocksource has been installed.
[    0.656666] Switched to NOHz mode on CPU #0
[    0.779999] ata1.00: ata_hpa_resize 1: sectors = 78242976,
hpa_sectors = 78242976
[    0.779999] ata1.00: ATA-7: SAMSUNG MP0402H, UC100-14, max UDMA/100
[    0.796666] ata1.00: 78242976 sectors, multi 8: LBA48
[    0.816666] ata1.00: ata_hpa_resize 1: sectors = 78242976,
hpa_sectors = 78242976
[    0.829999] ata1.00: configured for UDMA/33
[    1.376666] Clocksource tsc unstable (delta = -496149826 ns)
[   10.866665] ata2: SRST failed (errno=-16)
[   20.899997] ata2: SRST failed (errno=-16)
[   55.946661] ata2: SRST failed (errno=-16)
[   60.966660] ata2: SRST failed (errno=-16)
[   60.979993] ata2: reset failed, giving up
[   60.993327] scsi 0:0:0:0: Direct-Access     ATA      SAMSUNG
MP0402H  UC10 PQ: 0 ANSI: 5
[   61.009993] sd 0:0:0:0: [sda] 78242976 512-byte hardware sectors (40060 MB)
[   61.023327] sd 0:0:0:0: [sda] Write Protect is off
[   61.039993] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   61.039993] sd 0:0:0:0: [sda] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[   61.056660] sd 0:0:0:0: [sda] 78242976 512-byte hardware sectors (40060 MB)
[   61.069993] sd 0:0:0:0: [sda] Write Protect is off
[   61.086660] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   61.086660] sd 0:0:0:0: [sda] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[   61.103327]  sda: sda1 sda2 sda3 sda4
[   61.546660] sd 0:0:0:0: [sda] Attached SCSI disk
[   61.563327] sd 0:0:0:0: Attached scsi generic sg0 type 0

AFAIR the drive, a  SAMSUNG CD-ROM SN-124, is somehow misbehaving and
listed with ATA_HORKAGE_NODMA in the dma blacklist.

Is there a patch I can apply?

Thanks,
Gregor

[1] http://lkml.org/lkml/2007/3/1/243
