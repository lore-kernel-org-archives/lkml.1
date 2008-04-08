Return-Path: <linux-kernel-owner+w=401wt.eu-S1754351AbYDHJrr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754351AbYDHJrr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 05:47:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751881AbYDHJri
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 05:47:38 -0400
Received: from py-out-1112.google.com ([64.233.166.183]:19253 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751683AbYDHJrh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 05:47:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=TU51zV49SAiydOILRtZykVgyAd+WIKzOF0IBv97iH+JeLf5OFi6JfGQxuBQa6OVhl4S8t07RGH+iVMoqcqH9/ivxWRE/KheHSBUUuhu6V4nxFGB2TJ/Kpla31TeBy6i4UxWidHzwNgEtP/a//+5P/hkPzVxG9dkc/KCrbhlu5Fw=
Message-ID: <bc64b4640804080247s82ba84chd740c08b2fbb9b1a@mail.gmail.com>
Date: Tue, 8 Apr 2008 13:47:35 +0400
From: Dmitry <dbaryshkov@gmail.com>
To: "Russell King" <rmk+lkml@arm.linux.org.uk>
Subject: Re: [PATCH 5/6] Clocklib: Use correct clock for IrDA on pxa
Cc: "Andrew Morton" <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       haavard.skinnemoen@atmel.com, lethal@linux-sh.org,
       philipp.zabel@gmail.com, pavel@ucw.cz, tony@atomide.com, paul@pwsan.com
In-Reply-To: <20080407230434.GA525@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080403132142.GA26882@doriath.ww600.siemens.net>
	 <20080403132402.GA27008@doriath.ww600.siemens.net>
	 <20080407160029.f1f9ce4f.akpm@linux-foundation.org>
	 <20080407230434.GA525@flint.arm.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

2008/4/8, Russell King <rmk+lkml@arm.linux.org.uk>:
> On Mon, Apr 07, 2008 at 04:00:29PM -0700, Andrew Morton wrote:
>  > On Thu, 3 Apr 2008 17:24:02 +0400
>  > Dmitry Baryshkov <dbaryshkov@gmail.com> wrote:
>  >
>  > > Signed-off-by: Dmitry Baryshkov <dbaryshkov@gmail.com>
>  > > ---
>  > >  drivers/net/irda/pxaficp_ir.c |    2 +-
>  > >  1 files changed, 1 insertions(+), 1 deletions(-)
>  > >
>  > > diff --git a/drivers/net/irda/pxaficp_ir.c b/drivers/net/irda/pxaficp_ir.c
>  > > index 8c09344..36d2ec0 100644
>  > > --- a/drivers/net/irda/pxaficp_ir.c
>  > > +++ b/drivers/net/irda/pxaficp_ir.c
>  > > @@ -814,7 +814,7 @@ static int pxa_irda_probe(struct platform_device *pdev)
>  > >     si->dev = &pdev->dev;
>  > >     si->pdata = pdev->dev.platform_data;
>  > >
>  > > -   si->sir_clk = clk_get(&pdev->dev, "UARTCLK");
>  > > +   si->sir_clk = clk_get(&pdev->dev, "SIRCLK");
>  > >     si->fir_clk = clk_get(&pdev->dev, "FICPCLK");
>  > >     if (IS_ERR(si->sir_clk) || IS_ERR(si->fir_clk)) {
>  > >             err = PTR_ERR(IS_ERR(si->sir_clk) ? si->sir_clk : si->fir_clk);
>  >
>  > When fixing a bug, please describe what the bug is, and how the patch fixes
>  > it.
>  >
>  > A patch needs to be very very obvious to be able to get away with no
>  > changelog, and this one is not very very obvious.
>
>
> It's not a bug fix - it's a stupidity of the clock lib that the API
>  doesn't really require.
>
>  I've not made up my mind what to do with this stuff, but if it requires
>  drivers to work around its short comings, then I'm not in favour of it.
>
>  (We have the above code working as is.)

Yes, it works currently. But there are a few problems: we declare
STUART's UARTCLK with dev=NULL (all other UARTCLKs are declared with
proper devices).
Therefore,  I consider it as a hack and would like to remove it. As
the clocklib allows
to register multiple children clocks with different names, I'd propose
to separate UARTCLK
and SIRCLK functions of STUART clock. The UARTCLK will be used (as
usual) by the pxa uart driver. And IrDA will use SIRCLK.

-- 
With best wishes
Dmitry
