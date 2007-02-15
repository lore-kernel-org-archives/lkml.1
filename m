Return-Path: <linux-kernel-owner+w=401wt.eu-S965402AbXBOIsw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965402AbXBOIsw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 03:48:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965405AbXBOIsw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 03:48:52 -0500
Received: from wr-out-0506.google.com ([64.233.184.233]:58389 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965402AbXBOIsv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 03:48:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=eEbCvUua1HmpsiQGLJYqtEe+Q2/nIAWDu0tUumDan8AVkL10sQnZHUTHBI152uad2RaSq9m/Ds4USzGph/JxunHN0vVy4NsIMjGvcnFKkdnyxcfFYfjvxijQWcyMFoo6IHpuBdmyX/XNLO0V2r4brQpxBgl/YLqBN28nYPui2Fg=
Message-ID: <8d158e1f0702150048x4eb73acawc3c3b87d0d80a6d4@mail.gmail.com>
Date: Thu, 15 Feb 2007 09:48:49 +0100
From: "Patrick Ale" <patrick.ale@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: [LIBATA] drives not detected
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Good morning all,

Yesterday I replaced a Sil680 PCI add-on card for a Promise 2027x PCI
add-on card.


Now, when I boot up, I miss two drives, exactly the two connected to
this promise card.
I have another onboard Promise controller which works just fine, so
the driver gets loaded properly, and since i see all my other disks
but these two I think we can rule out a misconfiguration of the kernel
config this time ;-)

This is a snippet from my dmesg

pata_pdc2027x 0000:00:0b.0: version 0.74-ac5
ACPI: PCI Interrupt 0000:00:0b.0[A] -> GSI 19 (level, low) -> IRQ 20
pata_pdc2027x 0000:00:0b.0: PLL input clock 16799 kHz
ata7: PATA max UDMA/133 cmd 0xf98a17c0 ctl 0xf98a1fda bmdma 0xf98a1000 irq 20
ata8: PATA max UDMA/133 cmd 0xf98a15c0 ctl 0xf98a1dda bmdma 0xf98a1008 irq 20
scsi7 : pata_pdc2027x
scsi8 : pata_pdc2027x
ATA: abnormal status 0x8 on port 0xf98a15df


As you can see, scsi8 gives an abnormal status, which as we got
pointed out this week is just a cosmetic error for "No drive
attached/detected" and it's very right in that finding.

But what about scsi7? no warning/error about no disks being attached
nor a disk detection.

To state the obvious: I see the disks being detected by the Promise
BIOS when I boot the system,Primaiy master and Primaiy slave.

Here is the lspci -vvv regarding the controller

00:0b.0 Mass storage controller: Promise Technology, Inc. 20269 (rev
02) (prog-if 85)
        Subsystem: Promise Technology, Inc. Ultra133TX2
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=slow >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 32 (1000ns min, 4500ns max), Cache Line Size: 32 bytes
        Interrupt: pin A routed to IRQ 20
        Region 0: I/O ports at 9400 [size=8]
        Region 1: I/O ports at 9800 [size=4]
        Region 2: I/O ports at 9c00 [size=8]
        Region 3: I/O ports at a000 [size=4]
        Region 4: I/O ports at a400 [size=16]
        Region 5: Memory at eb000000 (32-bit, non-prefetchable) [size=16K]
        [virtual] Expansion ROM at ea100000 [disabled] [size=16K]
        Capabilities: [60] Power Management version 1
                Flags: PMEClk- DSI+ D1+ D2- AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-



Take care all!

Patrick
