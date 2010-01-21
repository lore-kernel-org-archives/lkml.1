Return-Path: <linux-kernel-owner+w=401wt.eu-S1753651Ab0AUQvX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753651Ab0AUQvX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 11:51:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752869Ab0AUQvX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 11:51:23 -0500
Received: from mail-fx0-f220.google.com ([209.85.220.220]:33345 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751650Ab0AUQvW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 11:51:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=rIud9MLWJhEeU+u2ajrOOtHPbUKKuEpuCn6TUd+j8/HiXsG9EVeWmh2ggyXxg2IsfG
         /lhNryz5oEaFTJjpPEUVRJR43JAPW3pmUhiQYjwblyoZNHJ85i3sLkTTCzvg9sc38SSM
         Xs/eYu3Ki89UycGkKw4yzrBJ0mEj71V5gbffs=
Message-ID: <4B5885F7.2020007@gmail.com>
Date: Thu, 21 Jan 2010 11:51:03 -0500
From: Chandra Nepali <edu4madh@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: port multiplier problem
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have a disk array of 12 disks. The interface card has two sil3726 port 
multiplier for 10 disks (5 disks in each port multiplier) and 2 direct 
sata connectors. The host controller is sil3124. It was connected to 
suse 10.4 and working fine.

There was a high voltage accident (high voltage to disk array only, not 
computer) and because of that we replaced the power supply of this disk 
array. Now, we are getting some problem, disks are not being 
recognized,. So, I connected it to Fedora 12 (To correct if it is 
because of some bugs) with driver sil24. Here are few things that I have 
tested.

1) If I connect only one disk to direct sata connector, it works fine.
2) If I connect two disks to both direct sata connectors, it won't work.
3) If I connect  one disk to one direct sata and one disk directly to 
host controller, it works.
3) If I connect one or more disk to PM, it won't work.
4) If I connect one disk to direct sata and one to PM, it won't work.

Below is the error from dmesg in case of failure:
==================================
aic7xxx 0000:03:04.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
scsi2 : Adaptec AIC7XXX EISA/VLB/PCI SCSI HBA DRIVER, Rev 7.0
        <Adaptec aic7899 Ultra160 SCSI adapter>
        aic7899: Ultra160 Wide Channel A, SCSI Id=7, 32/253 SCBs

sata_sil24 0000:03:02.0: version 1.1
sata_sil24 0000:03:02.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
scsi3 : sata_sil24
scsi4 : sata_sil24
scsi5 : sata_sil24
scsi6 : sata_sil24
ata3: SATA max UDMA/100 host m128@0xea009000 port 0xea000000 irq 18
ata4: SATA max UDMA/100 host m128@0xea009000 port 0xea002000 irq 18
ata5: SATA max UDMA/100 host m128@0xea009000 port 0xea004000 irq 18
ata6: SATA max UDMA/100 host m128@0xea009000 port 0xea006000 irq 18
aic7xxx 0000:03:04.1: PCI INT B -> GSI 18 (level, low) -> IRQ 18
ata3: SATA link down (SStatus 0 SControl 0)
ata4: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
ata4.15: Port Multiplier 1.1, 0x1095:0x3726 r23, 6 ports, feat 0x1/0x9
ata4.00: hard resetting link
ata4.00: SATA link down (SStatus 0 SControl 10)
ata4.01: hard resetting link
ata4.01: SATA link down (SStatus 0 SControl 320)
ata4.02: hard resetting link
ata4.02: SATA link down (SStatus 0 SControl 320)
ata4.03: hard resetting link
ata4.03: SATA link down (SStatus 0 SControl 320)
ata4.04: hard resetting link
ata4.04: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata4.05: hard resetting link
ata4.05: SATA link up 1.5 Gbps (SStatus 113 SControl 320)
ata4.04: failed to IDENTIFY (I/O error, err_mask=0x11)
ata4.15: hard resetting link
ata4.15: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
...........................
...........................
===================================

I appreciate your help.

Thanks
Manojg
