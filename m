Return-Path: <linux-kernel-owner+w=401wt.eu-S1751705AbZG3O35@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751705AbZG3O35 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 10:29:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751318AbZG3O35
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 10:29:57 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:37417 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750759AbZG3O34 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 10:29:56 -0400
Date: Thu, 30 Jul 2009 16:29:54 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linuxppc-dev@ozlabs.org, alsa-devel@alsa-project.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 5/5] sound/aoa: Add kmalloc NULL tests
In-Reply-To: <1248963420.16129.0.camel@johannes.local>
Message-ID: <Pine.LNX.4.64.0907301627260.8734@ask.diku.dk>
References: <Pine.LNX.4.64.0907301610550.8734@ask.diku.dk>
 <1248963420.16129.0.camel@johannes.local>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Jul 2009, Johannes Berg wrote:

> On Thu, 2009-07-30 at 16:11 +0200, Julia Lawall wrote:
> > From: Julia Lawall <julia@diku.dk>
> > 
> > Check that the result of kzalloc is not NULL before a dereference.
> 
> >  		irq_client = kzalloc(sizeof(struct pmf_irq_client),
> >  				     GFP_KERNEL);
> > +		if (!irq_client) {
> > +			err = -ENOMEM;
> > +			printk(KERN_ERR "snd-aoa: gpio layer failed to"
> > +				" register %s irq (%d)\n", name, err);
> > +			goto out_unlock;
> > +		}
> 
> Looks good, thanks, but I'd really drop the printk if only to not have
> the string there, that doesn't really seem interesting.

The printk is based on similar error handling code a few lines later:

               if (err) {
                        printk(KERN_ERR "snd-aoa: gpio layer failed to"
                                        " register %s irq (%d)\n", name, 
err);
                        kfree(irq_client);
                        goto out_unlock;
                }

Should the printk be removed in this case as well?  Or is it ok to fail 
silently in one case and not in the other?

julia
