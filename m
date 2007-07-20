Return-Path: <linux-kernel-owner+w=401wt.eu-S1761913AbXGTN0g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761913AbXGTN0g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 09:26:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756138AbXGTN03
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 09:26:29 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:6744 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755335AbXGTN02 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 09:26:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=BHvuXM5I8TWUsJLU6X0sD8wq4NGxUPoHJp4uIFIe5cS85r+nQKwYV0ySRUltE4rkc3Z9Td0my0zJMqJSnGeiqf6h4oSlusySmtrfN2sco2v9/0BEsG4a7/rAcnbEvHjB0L6ux7QCyJIpBzveY/pdwMuHEfVTGFnAfbkZetjKEAM=
Message-ID: <94a0d4530707200626r2b50146bs55e268033ceab4b0@mail.gmail.com>
Date: Fri, 20 Jul 2007 16:26:26 +0300
From: "Felipe Contreras" <felipe.contreras@gmail.com>
To: lkml <linux-kernel@vger.kernel.org>
Subject: ata_piix broken in 2.6.22
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Since I updated to 2.6.22 everything has been slower and I think this
is the reason:

ata_piix 0000:00:1f.2: version 2.11
ata_piix 0000:00:1f.2: MAP [ P0 P2 IDE IDE ]
ACPI: PCI Interrupt 0000:00:1f.2[B] -> GSI 16 (level, low) -> IRQ 16
ata_piix 0000:00:1f.2: 0x1F0 IDE port busy
ata_piix 0000:00:1f.2: 0x170 IDE port busy
ata_piix 0000:00:1f.2: no available legacy port

I tried to apply the patch d583bc18812f8da52bf25eef9cd111e5fd46a6ab,
but I get a similar error:

ata_piix 0000:00:1f.2: version 2.11
ata_piix 0000:00:1f.2: MAP [ P0 P2 IDE IDE ]
ACPI: PCI Interrupt 0000:00:1f.2[B] -> GSI 16 (level, low) -> IRQ 16
PCI: Unable to reserve I/O region #1:8@1f0 for device 0000:00:1f.2
ata_piix 0000:00:1f.2: failed to request/iomap BARs for port 0 (errno=-16)
PCI: Unable to reserve I/O region #3:8@170 for device 0000:00:1f.2
ata_piix 0000:00:1f.2: failed to request/iomap BARs for port 1 (errno=-16)
ata_piix 0000:00:1f.2: no available native port

I think I'm not the only one with that problem:
http://www.dellcommunity.com/supportforums/board/message?board.id=sw_linux&thread.id=10825

Any hints?

-- 
Felipe Contreras
