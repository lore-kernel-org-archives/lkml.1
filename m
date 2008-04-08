Return-Path: <linux-kernel-owner+w=401wt.eu-S1755970AbYDHTf2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755970AbYDHTf2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 15:35:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753879AbYDHTfT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 15:35:19 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:56903 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751912AbYDHTfR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 15:35:17 -0400
Date: Tue, 8 Apr 2008 20:35:02 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Dmitry <dbaryshkov@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       haavard.skinnemoen@atmel.com, lethal@linux-sh.org,
       philipp.zabel@gmail.com, pavel@ucw.cz, tony@atomide.com, paul@pwsan.com
Subject: Re: [PATCH 6/6] Clocklib: use correct name for 3,6MHz clock
Message-ID: <20080408193502.GB18053@flint.arm.linux.org.uk>
References: <20080403132142.GA26882@doriath.ww600.siemens.net> <20080403132411.GA27017@doriath.ww600.siemens.net> <20080407160155.5e6d77f0.akpm@linux-foundation.org> <bc64b4640804080252q6e295eeege7004013406ad3d8@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bc64b4640804080252q6e295eeege7004013406ad3d8@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 08, 2008 at 01:52:41PM +0400, Dmitry wrote:
> 2008/4/8, Andrew Morton <akpm@linux-foundation.org>:
> > On Thu, 3 Apr 2008 17:24:11 +0400
> >  Dmitry Baryshkov <dbaryshkov@gmail.com> wrote:
> >
> >  > Signed-off-by: Dmitry Baryshkov <dbaryshkov@gmail.com>
> >  > ---
> >  >  arch/arm/common/sa1111.c |    2 +-
> >  >  1 files changed, 1 insertions(+), 1 deletions(-)
> >  >
> >  > diff --git a/arch/arm/common/sa1111.c b/arch/arm/common/sa1111.c
> >  > index eb06d0b..282a4d9 100644
> >  > --- a/arch/arm/common/sa1111.c
> >  > +++ b/arch/arm/common/sa1111.c
> >  > @@ -627,7 +627,7 @@ __sa1111_probe(struct device *me, struct resource *mem, int irq)
> >  >       if (!sachip)
> >  >               return -ENOMEM;
> >  >
> >  > -     sachip->clk = clk_get(me, "GPIO27_CLK");
> >  > +     sachip->clk = clk_get(me, "3_6MHz_CLK");
> >  >       if (!sachip->clk) {
> >  >               ret = PTR_ERR(sachip->clk);
> >  >               goto err_free;
> >
> >
> > Again, there's just not enough information for us (well: me) to be able to
> >  evaluate this patch.
> >
> >  For example, if the current name is "incorrect" then why shouldn't we fix
> >  it in 2.6.25?  2.6.24?  etc.
> >
> >
> 
> The name GPIO27_CLK came from sa1100 arm sub-arch. There the 3.6 MHz
> clock was provided via GPIO 27. The PXA clocks code have copied the
> name for the clock (as it's used by sa1111 companion chip that can be
> used with both sa1100 and pxa). However on pxa the 3.6MHz clock is
> provided by different PIN. So the name GPIO27_CLK is misleading and
> incorrect for PXA.

So... what is the correct name.  Bear in mind what I said in the previous
reply this evening - which says that it should be the name used by the
SA1111.  Look in the data sheet - the pin itself to which the 3.6MHz
clock is supplised will have a name.  That's the name which should be
used.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
