Return-Path: <linux-kernel-owner+w=401wt.eu-S1751304AbZL0WHx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751304AbZL0WHx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Dec 2009 17:07:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751131AbZL0WHw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Dec 2009 17:07:52 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:33267 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750973AbZL0WHw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Dec 2009 17:07:52 -0500
Date: Sun, 27 Dec 2009 23:07:48 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: linux@arm.linux.org.uk, linux-arm-kernel@lists.infradead.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 1/5] arch/arm: Correct NULL test
In-Reply-To: <20091227215106.GA18317@pengutronix.de>
Message-ID: <Pine.LNX.4.64.0912272307310.20548@ask.diku.dk>
References: <Pine.LNX.4.64.0912272226360.20548@ask.diku.dk>
 <20091227215106.GA18317@pengutronix.de>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-511516320-821148813-1261951668=:20548"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---511516320-821148813-1261951668=:20548
Content-Type: TEXT/PLAIN; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT

On Sun, 27 Dec 2009, Uwe Kleine-König wrote:

> On Sun, Dec 27, 2009 at 10:26:54PM +0100, Julia Lawall wrote:
> > From: Julia Lawall <julia@diku.dk>
> > 
> > Test the just-allocated value for NULL rather than some other value.
> > 
> > The semantic patch that makes this change is as follows:
> > (http://coccinelle.lip6.fr/)
> > 
> > // <smpl>
> > ....
> > // </smpl>
> > 
> > Signed-off-by: Julia Lawall <julia@diku.dk>
> > 
> > ---
> >  arch/arm/plat-pxa/dma.c |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff -u -p a/arch/arm/plat-pxa/dma.c b/arch/arm/plat-pxa/dma.c
> > --- a/arch/arm/plat-pxa/dma.c
> > +++ b/arch/arm/plat-pxa/dma.c
> > @@ -244,7 +244,7 @@ static void pxa_dma_init_debugfs(void)
> >  
> >  	dbgfs_chan = kmalloc(sizeof(*dbgfs_state) * num_dma_channels,
> >  			     GFP_KERNEL);
> > -	if (!dbgfs_state)
> > +	if (!dbgfs_chan)
> >  		goto err_alloc;
> Shouldn't the malloc line read:
> 
> 	... = kmalloc(sizeof(*dbgfs_chan) * ...)
> 	                      ^^^^^^^^^^
> 
> ?

Good point, thanks.  I will send a revised patch.

julia
---511516320-821148813-1261951668=:20548--
