Return-Path: <linux-kernel-owner+w=401wt.eu-S1755767AbXIMOtk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755767AbXIMOtk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 10:49:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750905AbXIMOtd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 10:49:33 -0400
Received: from de01egw02.freescale.net ([192.88.165.103]:58721 "EHLO
	de01egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751016AbXIMOtc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 10:49:32 -0400
Date: Thu, 13 Sep 2007 09:49:19 -0500
From: Scott Wood <scottwood@freescale.com>
To: Zhang Wei-r63237 <Wei.Zhang@freescale.com>
Cc: dan.j.williams@intel.com, paulus@samba.org, shannon.nelson@intel.com,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] Add DMA engine driver for Freescale MPC85xxprocessors.
Message-ID: <20070913144919.GB32043@ld0162-tx32.am.freescale.net>
References: <11891624582950-git-send-email-wei.zhang@freescale.com> <20070907223553.GA18599@freescale.com> <46B96294322F7D458F9648B60E15112C85D8A5@zch01exm26.fsl.freescale.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46B96294322F7D458F9648B60E15112C85D8A5@zch01exm26.fsl.freescale.net>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 13, 2007 at 03:13:06AM -0700, Zhang Wei-r63237 wrote:
> > After dropping the lock, you can no longer assume that your 
> > iterator is
> > still valid; you need to work off of the list head.
> > 
> 
> list_for_each_entry_safe() is used here. I think the safe should be ok.
> :P

Nope.  The safety is against the particular item you're iterating on
being removed; it doesn't protect against the *next* entry being removed
when you drop the lock.

> > Why not use an array of channels?
> 
> The list is used in dma engine core file. And it's possible that there
> are not all channel listed in dts and array.

I'm not sure I understand what you mean by the latter comment...

> > You could have the features be part of the match struct, so 
> > you don't have
> > to do extra strcmps.
> > 
> 
> Can I use the data field of struct of_device_id?

Yes, that's what it's there for. :-)

> > > +static struct of_device_id of_fsl_dma_ids[] = {
> > > +	{ .compatible = "fsl,dma", },
> > > +};
> > 
> > Why do we need to bind to the parent node at all?
> 
> Yes, the MPC83xx should get interrupt source from DMA device register.

You don't need to bind to it for that, though -- just call of_get_parent
from the channel probe.  Though it might be easier to bind to the parent
to ensure that you only register the IRQ once.

-Scott
