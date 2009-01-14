Return-Path: <linux-kernel-owner+w=401wt.eu-S1765275AbZANRZh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765275AbZANRZh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 12:25:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763887AbZANRZ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 12:25:27 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:7524 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762454AbZANRZ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 12:25:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=nb3WPpFK7S3dsj0iH3NyOkKHIS1IMaXCseS/YfX2TBjh5snB2za0iynUu07iAYX7kH
         PXtWUPVrjpB+dxP2u2L3PjllMFUujDRKKwFBZIzLjjZBiXUgy/Ox2rukM0hD5EEd0Max
         R4SKNNwdU7mA6fe/VT3622R0FbBRoBnjUTR4c=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Subject: Re: [PATCH 7/9] ide: move ->rqsize init from init_irq() to ide_init_port()
Date: Wed, 14 Jan 2009 18:25:21 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.28-06859-gede6f5a-dirty; KDE/4.1.3; i686; ; )
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20090106183520.21193.63704.sendpatchset@localhost.localdomain> <20090106183602.21193.67001.sendpatchset@localhost.localdomain> <496A5D64.6030007@ru.mvista.com>
In-Reply-To: <496A5D64.6030007@ru.mvista.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901141825.21896.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 11 January 2009, Sergei Shtylyov wrote:
> Hello.
> 
> Bartlomiej Zolnierkiewicz wrote:
> 
> > Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> >   
> 
> > Index: b/drivers/ide/ide-probe.c
> > ===================================================================
> > --- a/drivers/ide/ide-probe.c
> > +++ b/drivers/ide/ide-probe.c
> >   
> [...]
> > @@ -1242,6 +1234,13 @@ static void ide_init_port(ide_hwif_t *hw
> >  
> >  	if (d->max_sectors)
> >  		hwif->rqsize = d->max_sectors;
> > +	else {
> > +		if ((hwif->host_flags & IDE_HFLAG_NO_LBA48) ||
> > +		    (hwif->host_flags & IDE_HFLAG_NO_LBA48_DMA))
> >   
> 
>    Er, why not:
> 
> 		if (hwif->host_flags &
> 		    (IDE_HFLAG_NO_LBA48 | IDE_HFLAG_NO_LBA48_DMA))

IMO it is harder to read
