Return-Path: <linux-kernel-owner+w=401wt.eu-S1759561AbZE1JTc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759561AbZE1JTc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 05:19:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754312AbZE1JTY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 05:19:24 -0400
Received: from cs20.apochromatic.org ([204.152.189.161]:64199 "EHLO
	cs20.apochromatic.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753584AbZE1JTX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 05:19:23 -0400
Date: Thu, 28 May 2009 10:19:24 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Wolfgang =?iso-8859-1?Q?M=FCes?= <wolfgang.mues@auerswald.de>
Cc: Pierre Ossman <pierre@ossman.eu>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Mike Frysinger <vapier.adi@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mmc_spi: do propper retry managment in the block layer
	- 3rd try
Message-ID: <20090528091924.GB1860@console-pimps.org>
References: <200905261311.45725.wolfgang.mues@auerswald.de> <20090527214933.64eafeb5@mjolnir.ossman.eu> <200905281028.29256.wolfgang.mues@auerswald.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200905281028.29256.wolfgang.mues@auerswald.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 28, 2009 at 10:28:29AM +0200, Wolfgang Mües wrote:
> Pierre,
> 
> Am Mittwoch, 27. Mai 2009 schrieb Pierre Ossman:
>

[...]

> > > +		/* Do retries for all sort of transmission errors */
> > > +		switch (error) {
> > >
> > > -		/*
> > > -		 * A block was successfully transferred.
> > > +		case 0:	/* no error: continue, reset error variables */
> > > +			disable_multi = 0;
> > > +			retries = 3;
> > > +			break;
> > > +
> > > +		/* Card has not understand command. As we do only send
> > > +		 * valid commands, this must be a transmission error. */
> > > +		case -EPROTO:	/* fall through */
> >
> > This indicates a layering problem. The host driver should not be aware
> > of anything but pure bit errors.
> >
> > Also, this special meaning should be documented in core.h should we
> > decide to keep it.
> 
> This is not MY error code. EPROTO is send from mmc_spi_writeblock(), and I 
> have listed it here because it is a transmission error.
> 
> So there seems to be contrary objections: Matt Flemming has requested that the 
> exact cause of error is reported by the driver (because otherwise the caller 
> will loose information), and you requested to distinguish only between 
> transmission errors and the rest.
> 
> Matt Flemming has pointed out that further changes in the code will request to 
> get the exact cause of error in the block layer, and that error codes might 
> have interpreted different according to the command class, so IMHO it is 
> better to transport the exact error cause into block.c and do the error 
> handling here, according to the type of request.
> 

When I said "report the correct error" I was objecting to using EILSEQ
as The One True Error Code based on the fact that a transmission error
may, or may not, have occurred.

That is not contrary to Pierre's comments. I was not advocating
layering violations ;-)
