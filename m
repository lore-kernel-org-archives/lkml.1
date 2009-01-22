Return-Path: <linux-kernel-owner+w=401wt.eu-S1756403AbZAVOxM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756403AbZAVOxM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 09:53:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752333AbZAVOwz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 09:52:55 -0500
Received: from ey-out-2122.google.com ([74.125.78.26]:8299 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751714AbZAVOwy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 09:52:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=GSVKoZxDcHULCAlfPFAzwFCGwZuF0FeRDhE8kCayzTdhBoQPpawSIDptIvfAZkT/uv
         TGNVjMsilM7BHZXZtZvjWv5TEM4GzeMrhLmIv3x20jLXBkYflKT9vDDGQCY3+iMLfbDu
         FujrA0K3bOsK9viGonhEXM5/H7vP9EavZaB3U=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Subject: Re: [PATCH 7/9] ide: move ->rqsize init from init_irq() to ide_init_port()
Date: Thu, 22 Jan 2009 15:52:20 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.29-rc2-next-20090121; KDE/4.1.3; i686; ; )
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20090106183520.21193.63704.sendpatchset@localhost.localdomain> <496A5D64.6030007@ru.mvista.com> <200901141825.21896.bzolnier@gmail.com>
In-Reply-To: <200901141825.21896.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901221552.21060.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Wednesday 14 January 2009, Bartlomiej Zolnierkiewicz wrote:
> On Sunday 11 January 2009, Sergei Shtylyov wrote:
> > Hello.
> > 
> > Bartlomiej Zolnierkiewicz wrote:
> > 
> > > Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> > >   
> > 
> > > Index: b/drivers/ide/ide-probe.c
> > > ===================================================================
> > > --- a/drivers/ide/ide-probe.c
> > > +++ b/drivers/ide/ide-probe.c
> > >   
> > [...]
> > > @@ -1242,6 +1234,13 @@ static void ide_init_port(ide_hwif_t *hw
> > >  
> > >  	if (d->max_sectors)
> > >  		hwif->rqsize = d->max_sectors;
> > > +	else {
> > > +		if ((hwif->host_flags & IDE_HFLAG_NO_LBA48) ||
> > > +		    (hwif->host_flags & IDE_HFLAG_NO_LBA48_DMA))
> > >   
> > 
> >    Er, why not:
> > 
> > 		if (hwif->host_flags &
> > 		    (IDE_HFLAG_NO_LBA48 | IDE_HFLAG_NO_LBA48_DMA))
> 
> IMO it is harder to read

Sigh, why we were focused on subtle CodingStyle preferences we missed
the real issue...

This patch depends on fact that all host drivers use struct ide_port_info
which is not true yet (icside, buddha, ide_arm, ide-generic, ide-pnp and
macide still needs to be updated).  I dropped it from pata-2.6 for now...

Thanks,
Bart
