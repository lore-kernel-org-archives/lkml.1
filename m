Return-Path: <linux-kernel-owner+w=401wt.eu-S1755519AbXE3Wol@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755519AbXE3Wol (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 18:44:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752468AbXE3Woe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 18:44:34 -0400
Received: from an-out-0708.google.com ([209.85.132.247]:14460 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751017AbXE3Wod (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 18:44:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=Ilz2xTKDY0hoYRU1y8kDB8JTyhhvd9cGTzBaPxvpuPJQ1p9UZ5xxg9J7WaYtN0I2Wf4YMgy7wrN8nYyj+sd6GJKkG9TkU/uxqnpB9c6c69sG+8jzcz2MpGR0e3RTJmfnLTcWDHCW4uJkYR+gWPEermR5SmAGlaMeq8fSsZyPVyU=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: "Daniel J Blueman" <daniel.blueman@gmail.com>
Subject: Re: Compact Flash performance...
Date: Thu, 31 May 2007 00:56:56 +0200
User-Agent: KMail/1.9.6
Cc: linux-ide@vger.kernel.org, "Linux Kernel" <linux-kernel@vger.kernel.org>,
       Jeff Garzik <jeff@garzik.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>
References: <6278d2220705301510y2d81f69eu38fb778d32de05e1@mail.gmail.com>
In-Reply-To: <6278d2220705301510y2d81f69eu38fb778d32de05e1@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200705310056.56449.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

Since you are using libata ata_piix driver and not IDE piix one
Jeff and/or Alan are the right people to ask this question...

Anyway...

On Thursday 31 May 2007, Daniel J Blueman wrote:
> I have a SanDisk Extreme IV 4GB CF card, capable of 40MB/s read, but
> am seeing 30MB/s read [1], connected directly to the IDE bus on my
> ICH8 controller.
> 
> How can I find out if this would be a timing or configuration issue?
> On 2.6.20.5 [2], the 120nS timing looks to be right [3], but perhaps

multi-word DMA cycle timing seems to be configured OK

Shouldn't really matter since it is for multi-word DMA transfers
and this device is using UDMA transfers.

> no multi-word transfer is hurting here...alas, it can't be enabled
> with the libata subsystem and 'hdparm -m', so what else?

-m is for multi sector PIO transfers and probably won't help here

Everything (except harmless "abnormal status" garbage) seems fine.

Where does the max 40MB/s come from?  Were you able to get this device to
work with this speed using some other controller and/or other OS-es?

Thanks,
Bart

> Daniel
> 
> --- [1]
> 
> # hdparm -t /dev/sdb
> /dev/sdb:
>  Timing buffered disk reads:   94 MB in  3.05 seconds =  30.79 MB/sec
> 
> --- [2]
> 
> ata7: PATA max UDMA/100 cmd 0x000000000001bc00 ctl 0x000000000001b882
> bmdma 0x000000000001b400 irq 17
> ata7.00: CFA: SanDisk SDCFX-4096, HDX 4.04, max UDMA/66
> ata7.00: 8027712 sectors, multi 0: LBA
> ata7.00: configured for UDMA/66
> ATA: abnormal status 0x7F on port 0x000000000001b807
> scsi 6:0:0:0: Direct-Access     ATA      SanDisk SDCFX-40 HDX  PQ: 0 ANSI: 5
> SCSI device sdb: 8027712 512-byte hdwr sectors (4110 MB)
> sdb: Write Protect is off
> sdb: Mode Sense: 00 3a 00 00
> SCSI device sdb: write cache: disabled, read cache: enabled, doesn't
> support DPO or FUA
> SCSI device sdb: 8027712 512-byte hdwr sectors (4110 MB)
> sdb: sdb1
> sd 6:0:0:0: Attached scsi removable disk sdb
> 
> --- [3]
> 
> # hdparm -I /dev/sdb
> 
> /dev/sdb:
> 
> CompactFlash ATA device, with removable media
>         Model Number:       SanDisk SDCFX-4096
>         Serial Number:      116802D2807J3335
>         Firmware Revision:  HDX 4.04
> Standards:
>         Supported: 4
>         Likely used: 4
> Configuration:
>         Logical         max     current
>         cylinders       7964    7964
>         heads           16      16
>         sectors/track   63      63
>         --
>         CHS current addressable sectors:    8027712
>         LBA    user addressable sectors:    8027712
>         device size with M = 1024*1024:        3919 MBytes
>         device size with M = 1000*1000:        4110 MBytes (4 GB)
> Capabilities:
>         LBA, IORDY(may be)(cannot be disabled)
>         Standby timer values: spec'd by Vendor
>         R/W multiple sector transfer: Max = 4   Current = 0
>         DMA: mdma0 mdma1 mdma2 udma0 udma1 udma2 udma3 *udma4
>              Cycle time: min=120ns recommended=120ns
>         PIO: pio0 pio1 pio2 pio3 pio4
>              Cycle time: no flow control=120ns  IORDY flow control=120ns
> Commands/features:
>         Enabled Supported:
>                 Write cache
>            *    CFA feature set
> -- 
> Daniel J Blueman
