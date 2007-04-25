Return-Path: <linux-kernel-owner+w=401wt.eu-S2993144AbXDYUkN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993144AbXDYUkN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 16:40:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993146AbXDYUkL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 16:40:11 -0400
Received: from dspnet.fr.eu.org ([213.186.44.138]:2439 "EHLO dspnet.fr.eu.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993143AbXDYUkI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 16:40:08 -0400
Date: Wed, 25 Apr 2007 22:40:06 +0200
From: Olivier Galibert <galibert@pobox.com>
To: Matt Sealey <matt@genesi-usa.com>
Cc: Kristen Carlson Accardi <kristen.c.accardi@intel.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, jeff@garzik.org,
       linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       linux-ide@vger.kernel.org, htejun@gmail.com
Subject: Re: [patch 1/7] libata: check for AN support
Message-ID: <20070425204006.GA17784@dspnet.fr.eu.org>
Mail-Followup-To: Olivier Galibert <galibert@pobox.com>,
	Matt Sealey <matt@genesi-usa.com>,
	Kristen Carlson Accardi <kristen.c.accardi@intel.com>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>, jeff@garzik.org,
	linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
	linux-ide@vger.kernel.org, htejun@gmail.com
References: <20070424074856.005152262@intel.com> <20070423165943.0cc67bc5.kristen.c.accardi@intel.com> <20070424090713.65657495@the-village.bc.nu> <20070424102304.GA58841@dspnet.fr.eu.org> <20070424084904.61932994.kristen.c.accardi@intel.com> <20070424180552.GA17319@dspnet.fr.eu.org> <20070424135327.8fe0b0ba.kristen.c.accardi@intel.com> <20070425004946.GA63747@dspnet.fr.eu.org> <20070425114002.1975da48.kristen.c.accardi@intel.com> <462FA923.5000301@genesi-usa.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <462FA923.5000301@genesi-usa.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 25, 2007 at 08:16:51PM +0100, Matt Sealey wrote:
> > +#define ata_id_has_AN(id)	\
> > +	( (((id)[76] != 0x0000) && ((id)[76] != 0xffff)) && \
> > +	  ((id)[78] & (1 << 5)) )
> 
> ??
> 
> > --- 2.6-git.orig/include/linux/libata.h
> > +++ 2.6-git/include/linux/libata.h
> > @@ -136,6 +136,7 @@ enum {
> >  	ATA_DFLAG_CDB_INTR	= (1 << 2), /* device asserts INTRQ when ready for CDB */
> >  	ATA_DFLAG_NCQ		= (1 << 3), /* device supports NCQ */
> >  	ATA_DFLAG_FLUSH_EXT	= (1 << 4), /* do FLUSH_EXT instead of FLUSH */
> > +	ATA_DFLAG_AN		= (1 << 5), /* device supports Async notification */
> >  	ATA_DFLAG_CFG_MASK	= (1 << 8) - 1,
> 
> Why don't the macros use the enums? It makes the code hard to read without
> painful cross-reference doesn't it? Surely (id)[76] & (ATA_DFLAG_AN) is a
> lot more readable than 1 << 5 - even if the flag is obviously that, a lot
> of values and registers can have 1 << 5 as a flag and mean a lot of different
> things.

The two being 32 is just a coincidence.  One is a hardware register
bit, the other the signification of the bits of ata_device->flags.

  OG.

