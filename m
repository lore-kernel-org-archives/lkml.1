Return-Path: <linux-kernel-owner+w=401wt.eu-S965097AbXHZBze@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965097AbXHZBze (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2007 21:55:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933980AbXHZBzZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Aug 2007 21:55:25 -0400
Received: from wa-out-1112.google.com ([209.85.146.177]:9271 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933607AbXHZBzY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2007 21:55:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=ZDzuzqx0K5MXfsdPUQeOG5tlGTy6RX4flZS2dcUP7tCJmSi/gpgr5SPK8RRjKjbSeNTXdCRmBWm6gUEljgsiue/pVAp6DBVqIsZqqcViC2ZUHpSBkVmpjX1LPDLqNj6ws8kE139sOCoPD3976wvnsFTfxw5FB180LAIwRY0tt6w=
Message-ID: <a2ebde260708251855j708d2b33hfce905f623597325@mail.gmail.com>
Date: Sun, 26 Aug 2007 09:55:22 +0800
From: "Dong Feng" <middle.fengdong@gmail.com>
To: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: 2.6.22.5 SATA Failure
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I have been using 2.6.21.1. It seems working well, that is, all my
disk partitions are mapped as "/dev/sda*" and the performance looks
good. After I upgrade to 2.6.22.5 with the exact same configuration,
all the disk device turn to "/dev/hda*" and the performance degrade
obviously.

While I boot with 2.6.21.1, the logs regarding disk are:

Aug 26 06:11:26 localhost kernel: ata_piix 0000:00:1f.2: MAP [ P0 P2 IDE IDE ]
Aug 26 06:11:26 localhost kernel: ACPI: PCI Interrupt 0000:00:1f.2[B]
-> GSI 17 (level, low) -> IRQ 17
Aug 26 06:11:26 localhost kernel: ata: 0x170 IDE port busy
Aug 26 06:11:26 localhost kernel: ata: conflict with ide1
Aug 26 06:11:26 localhost kernel: ata1: SATA max UDMA/133 cmd
0x000101f0 ctl 0x000103f6 bmdma 0x0001bfa0 irq 14
Aug 26 06:11:26 localhost kernel: ata2: DUMMY
Aug 26 06:11:26 localhost kernel: scsi0 : ata_piix
Aug 26 06:11:26 localhost kernel: ata1.00: ATA-7: ST9120821AS, 8.03,
max UDMA/133
Aug 26 06:11:26 localhost kernel: ata1.00: 234441648 sectors, multi 8:
LBA48 NCQ (depth 0/32)
Aug 26 06:11:26 localhost kernel: ata1.00: configured for UDMA/133
Aug 26 06:11:26 localhost kernel: scsi1 : ata_piix
Aug 26 06:11:26 localhost kernel: scsi 0:0:0:0: Direct-Access     ATA
    ST9120821AS      8.03 PQ: 0 ANSI: 5
Aug 26 06:11:26 localhost kernel: SCSI device sda: 234441648 512-byte
hdwr sectors (120034 MB)
Aug 26 06:11:26 localhost kernel: sda: Write Protect is off
Aug 26 06:11:26 localhost kernel: SCSI device sda: write cache:
enabled, read cache: enabled, doesn't support DPO or FUA
Aug 26 06:11:26 localhost kernel: SCSI device sda: 234441648 512-byte
hdwr sectors (120034 MB)
Aug 26 06:11:26 localhost kernel: sda: Write Protect is off
Aug 26 06:11:26 localhost kernel: SCSI device sda: write cache:
enabled, read cache: enabled, doesn't support DPO or FUA
Aug 26 06:11:26 localhost kernel:  sda: sda1 sda2 sda3 < sda5 sda6 sda7 >



While booting with 2.6.22.5, the logs are:

Aug 26 09:30:04 localhost kernel: ACPI: PCI Interrupt 0000:00:1f.2[B]
-> GSI 17 (level, low) -> IRQ 17
Aug 26 09:30:04 localhost kernel: ata_piix 0000:00:1f.2: 0x1F0 IDE port busy
Aug 26 09:30:04 localhost kernel: ata_piix 0000:00:1f.2: 0x170 IDE port busy
Aug 26 09:30:04 localhost kernel: ata_piix 0000:00:1f.2: no available
legacy port



It seems the dramatic change in libata.c incurs this failure.
