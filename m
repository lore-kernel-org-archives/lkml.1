Return-Path: <linux-kernel-owner+w=401wt.eu-S1755002AbZCKRCB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755002AbZCKRCB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 13:02:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754241AbZCKRBE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 13:01:04 -0400
Received: from ey-out-2122.google.com ([74.125.78.24]:64794 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753886AbZCKRA7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 13:00:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=C9xYtM1sxYXh+Ykmcn0wft7p5TRb2LgZzd7zFuUUmPgWKlDJKptrlSPrj28skiAEmL
         NOxwNrq5L+NNb3fdL/ROOI+URkG+L9kkaw3sC3Cml9UulvY0p28JcUmI5Nfr9px0tTR4
         RvFiuJedkf96FqVKFvc49ERqEXmNnh2oQNZR0=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Subject: Re: [PATCH 08/10] ide: move ide_map_sg() call out from ->dma_setup method
Date: Wed, 11 Mar 2009 17:36:25 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc7-next-20090310; KDE/4.2.0; i686; ; )
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20090220171139.25429.26702.sendpatchset@localhost.localdomain> <20090220171236.25429.25264.sendpatchset@localhost.localdomain> <49B52AE3.1030209@ru.mvista.com>
In-Reply-To: <49B52AE3.1030209@ru.mvista.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200903111736.26177.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 09 March 2009, Sergei Shtylyov wrote:
> Bartlomiej Zolnierkiewicz wrote:
> 
> > Move ide_map_sg() call from ->dma_setup implementations
> > and ide_destroy_dmatable() one from *_build_dmatable() to
> > ide_dma_prepare().
> >
> > There should be no functional changes caused by this patch.
> >
> > Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> >   
> [...]
> > Index: b/drivers/ide/au1xxx-ide.c
> > ===================================================================
> > --- a/drivers/ide/au1xxx-ide.c
> > +++ b/drivers/ide/au1xxx-ide.c
> > @@ -272,9 +272,7 @@ static int auide_build_dmatable(ide_driv
> >  	if (count)
> >  		return 1;
> >  
> > - use_pio_instead:
> > -	ide_destroy_dmatable(drive);
> > -
> > +use_pio_instead:
> >   
> 
>    Could you please get rid of goto and label too, while at it?

Sorry but since this patch has been already merged it would be too much
work/noise for too little gain IMO.
