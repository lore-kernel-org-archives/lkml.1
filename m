Return-Path: <linux-kernel-owner+w=401wt.eu-S1752436AbYG3Uj5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752436AbYG3Uj5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 16:39:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750935AbYG3Ujr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 16:39:47 -0400
Received: from mk-outboundfilter-4.mail.uk.tiscali.com ([212.74.114.32]:42737
	"EHLO mk-outboundfilter-4.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750898AbYG3Ujq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 16:39:46 -0400
X-Trace: 117263869/mk-outboundfilter-2.mail.uk.tiscali.com/F2S/$F2S-NILDRAM-ACCEPTED/f2s-nildram-customers/195.149.44.6
X-SBRS: None
X-RemoteIP: 195.149.44.6
X-IP-MAIL-FROM: alistair@devzero.co.uk
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ArcEAIBukEjDlSwG/2dsb2JhbACBW4lEpnQ
X-IronPort-AV: E=Sophos;i="4.31,281,1215385200"; 
   d="scan'208";a="117263869"
X-IP-Direction: IN
From: Alistair John Strachan <alistair@devzero.co.uk>
To: Simen Timian Thoresen <simentt@dolphinics.no>
Subject: Re: Misidentification and failing revalidations of ide dvd-roms with libata
Date: Wed, 30 Jul 2008 21:39:40 +0100
User-Agent: KMail/1.10.0 (Linux/2.6.27-rc1-damocles; KDE/4.1.0; x86_64; ; )
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
References: <48838593.8020007@dolphinics.no> <200807272147.42264.alistair@devzero.co.uk> <4890A563.70609@dolphinics.no>
In-Reply-To: <4890A563.70609@dolphinics.no>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807302139.40841.alistair@devzero.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 30 July 2008 18:31:15 Simen Timian Thoresen wrote:
> Alistair John Strachan wrote:
> > I used Alan's nForce4 pata driver for a year or so and didn't have any
> > problems. OTOH maybe at this stage it's worth checking whether amd74xx
> > (old IDE) breaks in similar ways?
>
> from dmesg, I have this;
>
> [   17.647757] pata_amd 0000:00:06.0: version 0.3.10
> [   17.650097] scsi0 : pata_amd
> [   17.650229] scsi1 : pata_amd
> (that's the one, right?)
>
> ...so the driver exists in the running kernel. Would I have to build my
> own kernel, or is there some way to have this driver take hold instead
> of libata? ...or can I do something in modprobe.conf to use the other
> driver?

I have no clue what your distributor has enabled or disabled. The easiest way 
would be to ignore your distribution kernel and just build your own one.

You'll probably need to disable pata_amd (from "Serial ATA (prod) and Parallel 
ATA (experimental) drivers") and enable amd74xx (from "ATA/ATAPI/MFM/RLL 
support -> Enhanced IDE/MFM/RLL disk/cdrom/tape/floppy support -> AMD and 
nVidia IDE support (NEW)"). Note that you'll also need ide-cd for this 
subsystem.

As for DMA, I know there were issues with ATAPI on nForce 4 chipsets, but I 
don't really know the specifics. Could you try sata_nv.adma=0 on the kernel 
cmdline? This is probably a red herring though, as I'm not sure what relation 
the sata_nv driver has to pata_amd.

-- 
Cheers,
Alistair.
