Return-Path: <linux-kernel-owner+w=401wt.eu-S1758287AbYDGXFt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758287AbYDGXFt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 19:05:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755472AbYDGXFm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 19:05:42 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:44424 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753275AbYDGXFl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 19:05:41 -0400
Date: Tue, 8 Apr 2008 00:04:34 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Dmitry Baryshkov <dbaryshkov@gmail.com>, linux-kernel@vger.kernel.org,
       haavard.skinnemoen@atmel.com, lethal@linux-sh.org,
       philipp.zabel@gmail.com, pavel@ucw.cz, tony@atomide.com, paul@pwsan.com
Subject: Re: [PATCH 5/6] Clocklib: Use correct clock for IrDA on pxa
Message-ID: <20080407230434.GA525@flint.arm.linux.org.uk>
References: <20080403132142.GA26882@doriath.ww600.siemens.net> <20080403132402.GA27008@doriath.ww600.siemens.net> <20080407160029.f1f9ce4f.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080407160029.f1f9ce4f.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 07, 2008 at 04:00:29PM -0700, Andrew Morton wrote:
> On Thu, 3 Apr 2008 17:24:02 +0400
> Dmitry Baryshkov <dbaryshkov@gmail.com> wrote:
> 
> > Signed-off-by: Dmitry Baryshkov <dbaryshkov@gmail.com>
> > ---
> >  drivers/net/irda/pxaficp_ir.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/drivers/net/irda/pxaficp_ir.c b/drivers/net/irda/pxaficp_ir.c
> > index 8c09344..36d2ec0 100644
> > --- a/drivers/net/irda/pxaficp_ir.c
> > +++ b/drivers/net/irda/pxaficp_ir.c
> > @@ -814,7 +814,7 @@ static int pxa_irda_probe(struct platform_device *pdev)
> >  	si->dev = &pdev->dev;
> >  	si->pdata = pdev->dev.platform_data;
> >  
> > -	si->sir_clk = clk_get(&pdev->dev, "UARTCLK");
> > +	si->sir_clk = clk_get(&pdev->dev, "SIRCLK");
> >  	si->fir_clk = clk_get(&pdev->dev, "FICPCLK");
> >  	if (IS_ERR(si->sir_clk) || IS_ERR(si->fir_clk)) {
> >  		err = PTR_ERR(IS_ERR(si->sir_clk) ? si->sir_clk : si->fir_clk);
> 
> When fixing a bug, please describe what the bug is, and how the patch fixes
> it.
> 
> A patch needs to be very very obvious to be able to get away with no
> changelog, and this one is not very very obvious.

It's not a bug fix - it's a stupidity of the clock lib that the API
doesn't really require.

I've not made up my mind what to do with this stuff, but if it requires
drivers to work around its short comings, then I'm not in favour of it.

(We have the above code working as is.)

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
