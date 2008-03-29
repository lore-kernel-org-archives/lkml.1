Return-Path: <linux-kernel-owner+w=401wt.eu-S1753908AbYC2Pzz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753908AbYC2Pzz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2008 11:55:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752163AbYC2Pzt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Mar 2008 11:55:49 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:59537 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752038AbYC2Pzs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2008 11:55:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=rrvXX5UWKwkJyfmYy3wzKXkIc30CC7sLpq62ABKZIO5hBm42vXPjhhk1WglTFFZwWHGycaeRKIro8BJdO8Lc7O4mA7p1j5fbdQQzKWxbQq0d0/Vs8/sGCbpeefYIMSRnqk3YsbJEmTC9cgwi7mMn5al6OGsdx1EpWQvZ7xARC7M=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Subject: Re: [PATCH 15/18] ide: remove broken/dangerous HDIO_[UNREGISTER,SCAN]_HWIF ioctls
Date: Sat, 29 Mar 2008 17:03:24 +0100
User-Agent: KMail/1.9.9
Cc: linux-ide@vger.kernel.org, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
References: <20080208004421.17746.32557.sendpatchset@localhost.localdomain> <20080208004606.17746.90799.sendpatchset@localhost.localdomain> <47EBDBAA.2020308@ru.mvista.com>
In-Reply-To: <47EBDBAA.2020308@ru.mvista.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803291703.25050.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 27 March 2008, Sergei Shtylyov wrote:

[...]

> > Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> 
> Acked-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>

Thanks for reviewing it.

> > Index: b/drivers/ide/ide-pnp.c
> > ===================================================================
> > --- a/drivers/ide/ide-pnp.c
> > +++ b/drivers/ide/ide-pnp.c
> [...]
> > @@ -655,52 +530,6 @@ void ide_init_port_hw(ide_hwif_t *hwif, 
> >  }
> >  EXPORT_SYMBOL_GPL(ide_init_port_hw);
> >  
> > -/**
> > - *	ide_register_hw		-	register IDE interface
> > - *	@hw: hardware registers
> > - *	@quirkproc: quirkproc function
> > - *	@hwifp: pointer to returned hwif
> > - *
> > - *	Register an IDE interface, specifying exactly the registers etc.
> > - *
> > - *	Returns -1 on error.
> > - */
> > -
> > -static int ide_register_hw(hw_regs_t *hw, void (*quirkproc)(ide_drive_t *),
> > -			   ide_hwif_t **hwifp)
> > -{
> > -	int index, retry = 1;
> > -	ide_hwif_t *hwif;
> > -	u8 idx[4] = { 0xff, 0xff, 0xff, 0xff };
> > -
> > -	do {
> > -		hwif = ide_find_port(hw->io_ports[IDE_DATA_OFFSET]);
> > -		index = hwif->index;
> > -		if (hwif)
> > -			goto found;
> 
>     Hm, I remember there was a patch that fixed the above bug where hwif is 
> dereferenced before being checked for NULL, I wonder how come it was lost?

It has been already merged into Linus' tree
(commit 0c6025d44448bd688dfd351a09bc620aafa4d1ff).

Thanks,
Bart
