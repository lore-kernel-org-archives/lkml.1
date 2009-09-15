Return-Path: <linux-kernel-owner+w=401wt.eu-S1754871AbZIOPre@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754871AbZIOPre (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 11:47:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754848AbZIOPra
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 11:47:30 -0400
Received: from mgw1.diku.dk ([130.225.96.91]:39377 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754820AbZIOPrZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 11:47:25 -0400
Date: Tue, 15 Sep 2009 17:47:26 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Cc: ralf@linux-mips.org, linux-mips@linux-mips.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 1/8] arch/mips/txx9: introduce missing kfree, iounmap
In-Reply-To: <20090916.004525.74746264.anemo@mba.ocn.ne.jp>
Message-ID: <Pine.LNX.4.64.0909151747120.8549@pc-004.diku.dk>
References: <20090914.003321.160496287.anemo@mba.ocn.ne.jp>
 <Pine.LNX.4.64.0909132113520.31000@ask.diku.dk> <Pine.LNX.4.64.0909150701170.11392@ask.diku.dk>
 <20090916.004525.74746264.anemo@mba.ocn.ne.jp>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Sep 2009, Atsushi Nemoto wrote:

> On Tue, 15 Sep 2009 07:03:42 +0200 (CEST), Julia Lawall <julia@diku.dk> wrote:
> > > +out_pdev:
> > > +	platform_device_put(pdev);
> > > +out_gpio:
> > > +	gpio_remove(&iocled->chip);
> > 
> > I just noticed that the prototype of gpio_remove has __must_check
> > I don't think there is anything to check here; since the thing is not 
> > fully initialized here, it is unlikely to be busy.  Should there be (void) 
> > in front of it?
> 
> The void casting does not silence the warning.  How about this?
> 
> 	if (gpiochip_remove(&iocled->chip))
> 		return;
> 
> In general, memory leak would be less serious than crash or data
> corruption ;)

OK, I will send an updated patch shortly.

julia
