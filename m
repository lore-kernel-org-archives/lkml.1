Return-Path: <linux-kernel-owner+w=401wt.eu-S934298AbXILVXg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934298AbXILVXg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 17:23:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966846AbXILVUl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 17:20:41 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:12068 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966759AbXILVUi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 17:20:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=jMG3HkgvmbaCyauhtBFxdih4P6xweSIO4HaoKCDy5ZqMwTe2brzWMW2JRitYwZdhXBOXEFOpq9DMv50EFs2+jhOv05AV142J2Q8Ky2QSsuYpb8o0ugAbM069h1eG2LAJ3WPzyZDVCW4D5BTN7SprHKAf9nBhEI8e6suzw2we68s=
Date: Thu, 13 Sep 2007 01:20:25 +0400
From: Sergey Dolgov <dolgovs@gmail.com>
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: Tejun Heo <htejun@gmail.com>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
Subject: Re: ata_piix, laptop cdrom, ICH7: EH, limiting speed to PIO
Message-ID: <20070912212025.GB2620@slk.laptop>
References: <20070911212030.GA2817@slk.laptop> <6bffcb0e0709120933p6d58127fv3c85076fe41daaca@mail.gmail.com> <20070912200706.GA2620@slk.laptop> <46E849B7.9040402@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46E849B7.9040402@googlemail.com>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 12, 2007 at 10:19:03PM +0200, Michal Piotrowski wrote:
> Sergey Dolgov pisze:
> > Hi Michal,
> > 
> > On Wed, Sep 12, 2007 at 06:33:20PM +0200, Michal Piotrowski wrote:
> >> Hi Sergey,
> >>
> >> On 11/09/2007, Sergey Dolgov <dolgovs@gmail.com> wrote:
> >>> Hi!
> >>>
> >>> On my hp nx7300 laptop, 2 following scenarios can happen during bootup
> >>> (see attachments for the full logs): the "good" one [1] and the one
> >>> where multiple EHs lead to limiting the speed [2].
> >>>
> >>> [1] one is more rare, but it seems to be persistent over reboots: once
> >>> it happened, just rebooting the machine always results in behaviour
> >>> like [1].
> >>>
> >>> [1] results in a working cdrom from the start. An attempt to use cdrom
> >>> after [2] happened results in even more EHs, resulting in "configured
> >>> for PIO4", after which the cdrom is finaly working.
> >>>
> >>> The version I'm using is 2.6.23-rc6, but the same used to happen with
> >>> the previous rc's, and probably with 2.6.22 too (I can check).
> >> It would be great if you could check it.
> > 
> > I've just built 2.6.22.6 with basically the same configuration, and
> > the behaviour is just the same, i.e. both [1] and [2] still can
> > happen.
> 
> Ok, thanks.
> 
> BTW please check cables and PCU.

What's a PCU? BTW, this only happens when using libata of course. The
old CONFIG_IDE stuff works fine every time.

> 
> > 
> >>> [1]:
> >>>
> >>>    [   13.026676] ata_piix 0000:00:1f.1: version 2.12
> >>>    [   13.026701] ACPI: PCI Interrupt 0000:00:1f.1[A] -> GSI 16 (level, low) -> IRQ 16
> >>>    [   13.026898] PCI: Setting latency timer of device 0000:00:1f.1 to 64
> >>>    [   13.026994] scsi4 : ata_piix
> >>>    [   13.027209] scsi5 : ata_piix
> >>>    [   13.027385] ata5: PATA max UDMA/133 cmd 0x000101f0 ctl 0x000103f6 bmdma 0x000140a0 irq 14
> >>>    [   13.027484] ata6: PATA max UDMA/133 cmd 0x00010170 ctl 0x00010376 bmdma 0x000140a8 irq 15
> >>>    [   13.339308] ata5.00: ATAPI: HL-DT-ST DVDRAM GSA-T10N, PC05, max MWDMA2
> >>>    [   13.505922] ata5.00: configured for MWDMA2
> >>>    [   13.506026] ata6: port disabled. ignoring.
> >>>    [   13.509916] scsi 4:0:0:0: CD-ROM            HL-DT-ST DVDRAM GSA-T10N  PC05 PQ: 0 ANSI: 5
> >>>
> >>> [2]:
> >>>
> >>>    [   10.007152] ata_piix 0000:00:1f.1: version 2.12
> >>>    [   10.007178] ACPI: PCI Interrupt 0000:00:1f.1[A] -> GSI 16 (level, low) -> IRQ 16
> >>>    [   10.007369] PCI: Setting latency timer of device 0000:00:1f.1 to 64
> >>>    [   10.007464] scsi4 : ata_piix
> >>>    [   10.007680] scsi5 : ata_piix
> >>>    [   10.007856] ata5: PATA max UDMA/133 cmd 0x000101f0 ctl 0x000103f6 bmdma 0x000140a0 irq 14
> >>>    [   10.007956] ata6: PATA max UDMA/133 cmd 0x00010170 ctl 0x00010376 bmdma 0x000140a8 irq 15
> >>>    [   10.320462] ata5.00: ATAPI: HL-DT-ST DVDRAM GSA-T10N, PC05, max MWDMA2
> >>>    [   10.487077] ata5.00: configured for MWDMA2
> >>>    [   10.487181] ata6: port disabled. ignoring.
> >>>    [   15.985240] ata5.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
> >>>    [   15.985325] ata5.00: cmd a0/01:00:00:00:00/00:00:00:00:00/a0 tag 0 cdb 0x12 data 96 in
> >>>    [   15.985327]          res 40/00:02:00:24:00/00:00:00:00:00/a0 Emask 0x4 (timeout)
> >>>    [   15.985532] ata5: soft resetting port
> >>>    [   16.465489] ata5.00: configured for MWDMA2
> >>>    [   16.465571] ata5: EH complete
> >>>    [   21.963643] ata5.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
> >>>    [   21.963725] ata5.00: cmd a0/01:00:00:00:00/00:00:00:00:00/a0 tag 0 cdb 0x12 data 96 in
> >>>    [   21.963727]          res 40/00:02:00:24:00/00:00:00:00:00/a0 Emask 0x4 (timeout)
> >>>    [   21.963930] ata5: soft resetting port
> >>>    [   22.443900] ata5.00: configured for MWDMA2
> >>>    [   22.443979] ata5: EH complete
> >>>    [   27.942051] ata5.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
> >>>    [   27.942134] ata5.00: cmd a0/01:00:00:00:00/00:00:00:00:00/a0 tag 0 cdb 0x12 data 96 in
> >>>    [   27.942136]          res 40/00:02:00:24:00/00:00:00:00:00/a0 Emask 0x4 (timeout)
> >>>    [   27.942341] ata5: soft resetting port
> >>>    [   28.422309] ata5.00: configured for MWDMA2
> >>>    [   28.422389] ata5: EH complete
> >>>    [   33.920457] ata5.00: limiting speed to MWDMA1:PIO4
> >>>    [   33.920532] ata5.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
> >>>    [   33.920614] ata5.00: cmd a0/01:00:00:00:00/00:00:00:00:00/a0 tag 0 cdb 0x12 data 96 in
> >>>    [   33.920616]          res 40/00:02:00:24:00/00:00:00:00:00/a0 Emask 0x4 (timeout)
> >>>    [   33.920820] ata5: soft resetting port
> >>>    [   34.400708] ata5.00: configured for MWDMA1
> >>>    [   34.400790] ata5: EH complete
> >>>    [   34.400869] scsi scan: 96 byte inquiry failed.  Consider BLIST_INQUIRY_36 for this device
> >>>    [   34.402855] scsi 4:0:0:0: CD-ROM            HL-DT-ST DVDRAM GSA-T10N  PC05 PQ: 0 ANSI: 5
> >>>
> >>>
> > 
> > --
> > Sergey
> > 
> 
> Regards,
> Michal
> 
> -- 
> LOG
> http://www.stardust.webpages.pl/log/

--
Sergey
