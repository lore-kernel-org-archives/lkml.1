Return-Path: <linux-kernel-owner+w=401wt.eu-S1755264AbZBSWyM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755264AbZBSWyM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 17:54:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756914AbZBSWxu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 17:53:50 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42414 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756396AbZBSWxt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 17:53:49 -0500
Date: Thu, 19 Feb 2009 14:53:05 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Nicolas Pitre <nico@cam.org>
Cc: drzeus-mmc@drzeus.cx, linux-kernel@vger.kernel.org, maen@marvell.com
Subject: Re: [PATCH] SDIO driver for Marvell SoCs
Message-Id: <20090219145305.01451253.akpm@linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.0902191625120.5511@xanadu.home>
References: <alpine.LFD.2.00.0902172338110.32550@xanadu.home>
	<20090219124418.dfc4dc9a.akpm@linux-foundation.org>
	<alpine.LFD.2.00.0902191625120.5511@xanadu.home>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Feb 2009 17:02:32 -0500 (EST)
Nicolas Pitre <nico@cam.org> wrote:

> On Thu, 19 Feb 2009, Andrew Morton wrote:
> 
> > On Tue, 17 Feb 2009 23:46:21 -0500 (EST)
> > Nicolas Pitre <nico@cam.org> wrote:
> > 
> > > From: Maen Suleiman <maen@marvell.com>
> > > 
> > > This supports MMC/SD/SDIO currently found on the Kirkwood 88F6281 and
> > > 88F6192 SoC controllers.
> > > 
> > > Signed-off-by: Nicolas Pitre <nico@marvell.com>
> > 
> > It would be nice to have Maen's signoff.
> 
> Sure, I can add it if this is Maen's wish.  Still, this single signoff 
> was made in conformity with option B of the Developer's Certificate of 
> Origin 1.1 as found in Documentation/SubmittingPatches.  It is actually 
> my duty at Marvell to act as such.

No, it's not required.  But "nice".

> > >
> > > ...
> > >
> > > +#define mvsd_write(offs, val)	writel(val, iobase + (offs))
> > > +#define mvsd_read(offs)		readl(iobase + (offs))
> > 
> > It's rather grotty to have a macro which secretly relies upon the
> > presence of a particularly-named local variable.
> 
> My call.  Otherwise the code becomes bloated with repeated iobase noise 
> everywhere, making many lines bust the 80 column limit imposed by the 
> checkpatch.pl.  The alternative is to split those statement on multiple 
> lines making things not prettier.  So, unless you want to help 
> maintaining this driver, I prefer this grottiness to remains as is.

For the record: you do not get to put bad code into Linux by telling
the person who points out that bad code that he needs to maintain a
fixed verion.  Just cut the sophomoric crap.

I don't care much - we have plenty of grotty code down in drivers/

> > > +
> > > +		if (host->gpio_card_detect) {
> > > +			free_irq(gpio_to_irq(host->gpio_card_detect), host);
> > > +			gpio_free(host->gpio_card_detect);
> > > +		}
> > > +		mmc_remove_host(mmc);
> > > +		free_irq(host->irq, host);
> > > +		if (host->gpio_write_protect)
> > > +			gpio_free(host->gpio_write_protect);
> > > +		del_timer_sync(&host->timer);
> > > +		mvsd_power_down(host);
> > > +		iounmap(host->base);
> > > +		release_resource(host->res);
> > > +		mmc_free_host(mmc);
> > 
> > Perhaps this function and the error path ("out:") in the preceding
> > function could share code.
> 
> Well, one is marked __init and the other __exit.  Having common code 
> would mean this needs to be in a non discardable section which is a 
> waste.

OK.  
