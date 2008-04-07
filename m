Return-Path: <linux-kernel-owner+w=401wt.eu-S1759035AbYDGXHg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759035AbYDGXHg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 19:07:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754282AbYDGXHU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 19:07:20 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:37867 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753491AbYDGXHT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 19:07:19 -0400
Date: Tue, 8 Apr 2008 00:06:40 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Dmitry Baryshkov <dbaryshkov@gmail.com>, linux-kernel@vger.kernel.org,
       haavard.skinnemoen@atmel.com, lethal@linux-sh.org,
       philipp.zabel@gmail.com, pavel@ucw.cz, tony@atomide.com, paul@pwsan.com
Subject: Re: [PATCH 6/6] Clocklib: use correct name for 3,6MHz clock
Message-ID: <20080407230640.GB525@flint.arm.linux.org.uk>
References: <20080403132142.GA26882@doriath.ww600.siemens.net> <20080403132411.GA27017@doriath.ww600.siemens.net> <20080407160155.5e6d77f0.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080407160155.5e6d77f0.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 07, 2008 at 04:01:55PM -0700, Andrew Morton wrote:
> On Thu, 3 Apr 2008 17:24:11 +0400
> Dmitry Baryshkov <dbaryshkov@gmail.com> wrote:
> > Signed-off-by: Dmitry Baryshkov <dbaryshkov@gmail.com>
> > ---
> >  arch/arm/common/sa1111.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/arch/arm/common/sa1111.c b/arch/arm/common/sa1111.c
> > index eb06d0b..282a4d9 100644
> > --- a/arch/arm/common/sa1111.c
> > +++ b/arch/arm/common/sa1111.c
> > @@ -627,7 +627,7 @@ __sa1111_probe(struct device *me, struct resource *mem, int irq)
> >  	if (!sachip)
> >  		return -ENOMEM;
> >  
> > -	sachip->clk = clk_get(me, "GPIO27_CLK");
> > +	sachip->clk = clk_get(me, "3_6MHz_CLK");
> >  	if (!sachip->clk) {
> >  		ret = PTR_ERR(sachip->clk);
> >  		goto err_free;
> 
> Again, there's just not enough information for us (well: me) to be able to
> evaluate this patch.
> 
> For example, if the current name is "incorrect" then why shouldn't we fix
> it in 2.6.25?  2.6.24?  etc.

I don't see any reason for this change.  Except maybe someone wanted
a nicer name to be exposed to userland.  I don't see the point of
exposing what's supposed to be a kernel _internal_ API to userland
and then having an issue with those names being exported there.

To put it another way: I don't ever want to have to think about
userland issues when dealing with device clocking interfaces.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
