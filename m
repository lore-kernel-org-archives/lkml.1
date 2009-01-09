Return-Path: <linux-kernel-owner+w=401wt.eu-S1755962AbZAINKU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755962AbZAINKU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 08:10:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752534AbZAINKE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 08:10:04 -0500
Received: from mtagate4.de.ibm.com ([195.212.29.153]:44357 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751521AbZAINKB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 08:10:01 -0500
From: Christian Borntraeger <borntraeger@de.ibm.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: todays git: WARNING: at drivers/ata/libata-sff.c:1017 ata_sff_hsm_move+0x45e/0x750()
Date: Fri, 9 Jan 2009 14:09:55 +0100
User-Agent: KMail/1.9.9
Cc: linux-ide@vger.kernel.org, Jeff Garzik <jgarzik@redhat.com>,
       lkml <linux-kernel@vger.kernel.org>
References: <200901091334.55823.borntraeger@de.ibm.com> <20090109124412.619330ea@lxorguk.ukuu.org.uk>
In-Reply-To: <20090109124412.619330ea@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200901091409.55628.borntraeger@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, 9. Januar 2009 schrieb Alan Cox:
> On Fri, 9 Jan 2009 13:34:55 +0100
> Christian Borntraeger <borntraeger@de.ibm.com> wrote:
> 
> > Hello,
> > 
> > with todays git I lots of these warnings:
> > 
> > [    1.246807] ata1.00: ATA-7: ST910021AS, 4.06, max UDMA/100
> > [    1.253066] ata1.00: 195371568 sectors, multi 16: LBA48
> > [    1.262561] ata2.00: ATAPI: HL-DT-ST DVDRAM GSA-U10N, 1.05, max UDMA/33
> > [    1.273159] ata1.00: configured for UDMA/100
> > [    1.275279] ata2.00: configured for UDMA/33
> > [    1.285546] scsi 0:0:0:0: Direct-Access     ATA      ST910021AS       4.06 PQ: 0 ANSI: 5
> > [    1.292049] sd 0:0:0:0: Attached scsi generic sg0 type 0
> > [    1.298427] sd 0:0:0:0: [sda] 195371568 512-byte hardware sectors: (100 GB/93.1 GiB)
> > [    1.299631] scsi 1:0:0:0: CD-ROM            HL-DT-ST DVDRAM GSA-U10N  1.05 PQ: 0 ANSI: 5
> > [    1.311059] sd 0:0:0:0: [sda] Write Protect is off
> > [    1.317409] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
> > [    1.317426] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> > [    1.318378] ------------[ cut here ]------------
> > [    1.318380] WARNING: at drivers/ata/libata-sff.c:1017 ata_sff_hsm_move+0x45e/0x750()
> > [    1.318381] Hardware name: 64575GG
> 
> Can you see if this goes away if you back out all Arjan's async stuff.
> Then if not can you back out my 32bit PIO patch and see if that is the
> trigger.
> 
> Alan

Sure.
Since I could not revert arjans patches without conflicts, I started 
checking out older versions. My first try was 
e427fe042cf90c0652eed9a85e57a8fd8af89890 (without PIO, with async patched)
was successful. The problem went away. So it was triggered by the 32bit PIO patch.
Do you still need a test result without the async patches?

Christian
