Return-Path: <linux-kernel-owner+w=401wt.eu-S1755040AbXLSSAV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755040AbXLSSAV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 13:00:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752518AbXLSSAK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 13:00:10 -0500
Received: from ganesha.gnumonks.org ([213.95.27.120]:55637 "EHLO
	ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752760AbXLSSAI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 13:00:08 -0500
Date: Wed, 19 Dec 2007 18:53:34 +0100
From: Harald Welte <laforge@openmoko.org>
To: Pierre Ossman <drzeus-mmc@drzeus.cx>
Cc: linux-kernel@vger.kernel.org, tk@maintech.de, ben-linux@fluff.org
Subject: Re: [PATCH] Samsung S3C24xx SD/MMC driver
Message-ID: <20071219175334.GY29882@prithivi.gnumonks.org>
References: <20071219142213.GD29882@prithivi.gnumonks.org> <20071219175433.1ca7cd79@poseidon.drzeus.cx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071219175433.1ca7cd79@poseidon.drzeus.cx>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pierre,

thanks for your comments.

On Wed, Dec 19, 2007 at 05:54:33PM +0100, Pierre Ossman wrote:
> Well, my biggest beef with this driver is the excessive debug code. I
> did a cleanup in an older version of the driver, but it shouldn't be
> to difficult to do the same for this one. I've included my patch for
> reference.

ok, I'll re-work the patch according to your sample and re-submit.

The debugging was needed during development, and might still be needed
to debug some weird issues.

btw: OpenMoko is currently working on an ar6k wifi driver on top of the 
new mainline kernel SDIO support using the s3c_mci host controller
driver as basis.  So within not-too-distant-time we should also be able
to have SDIO working and tested on s3c_mci.

> > Index: linux-2.6/drivers/mmc/host/s3cmci.c
> > ===================================================================
> > --- /dev/null
> > +++ linux-2.6/drivers/mmc/host/s3cmci.c
> 
> > +#include <linux/mmc/mmc.h>
> 
> This is always a warning sign. It should never be needed in a host driver.

ok, will see how to remove it.

> > +	*words = sg->length >> 2;
> > +	*pointer = page_address(sg_page(sg)) + sg->offset;
> > +
> 
> The length might not be a multiple of four. And it might also be
> completely unaligned. Make sure you can either handle such requests,
> or fail them with -EINVAL.

ok, will update before submitting the next version.
-- 
- Harald Welte <laforge@openmoko.org>          	        http://openmoko.org/
============================================================================
Software for the world's first truly open Free Software mobile phone
