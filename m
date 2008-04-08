Return-Path: <linux-kernel-owner+w=401wt.eu-S1754491AbYDHJwv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754491AbYDHJwv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 05:52:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751756AbYDHJwn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 05:52:43 -0400
Received: from py-out-1112.google.com ([64.233.166.183]:29724 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751686AbYDHJwm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 05:52:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=SpP7M+ExPetwSYHxlevxt0CLkyKMQ2Vf6qnbGyOWEOVyEJSShej3w2s/0yX2iRQSeiwHOjBKKVfWLCmgmsC6JnG32NgyFPp3vS7y4yGflP4SDShLPWX96dU2uCUgXJk6tz3ly2IfHF/Ogw5Kg9Nu0oFkrFwBEBlgGk9x/OpKPio=
Message-ID: <bc64b4640804080252q6e295eeege7004013406ad3d8@mail.gmail.com>
Date: Tue, 8 Apr 2008 13:52:41 +0400
From: Dmitry <dbaryshkov@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCH 6/6] Clocklib: use correct name for 3,6MHz clock
Cc: linux-kernel@vger.kernel.org, haavard.skinnemoen@atmel.com,
       rmk+lkml@arm.linux.org.uk, lethal@linux-sh.org, philipp.zabel@gmail.com,
       pavel@ucw.cz, tony@atomide.com, paul@pwsan.com
In-Reply-To: <20080407160155.5e6d77f0.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080403132142.GA26882@doriath.ww600.siemens.net>
	 <20080403132411.GA27017@doriath.ww600.siemens.net>
	 <20080407160155.5e6d77f0.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/4/8, Andrew Morton <akpm@linux-foundation.org>:
> On Thu, 3 Apr 2008 17:24:11 +0400
>  Dmitry Baryshkov <dbaryshkov@gmail.com> wrote:
>
>  > Signed-off-by: Dmitry Baryshkov <dbaryshkov@gmail.com>
>  > ---
>  >  arch/arm/common/sa1111.c |    2 +-
>  >  1 files changed, 1 insertions(+), 1 deletions(-)
>  >
>  > diff --git a/arch/arm/common/sa1111.c b/arch/arm/common/sa1111.c
>  > index eb06d0b..282a4d9 100644
>  > --- a/arch/arm/common/sa1111.c
>  > +++ b/arch/arm/common/sa1111.c
>  > @@ -627,7 +627,7 @@ __sa1111_probe(struct device *me, struct resource *mem, int irq)
>  >       if (!sachip)
>  >               return -ENOMEM;
>  >
>  > -     sachip->clk = clk_get(me, "GPIO27_CLK");
>  > +     sachip->clk = clk_get(me, "3_6MHz_CLK");
>  >       if (!sachip->clk) {
>  >               ret = PTR_ERR(sachip->clk);
>  >               goto err_free;
>
>
> Again, there's just not enough information for us (well: me) to be able to
>  evaluate this patch.
>
>  For example, if the current name is "incorrect" then why shouldn't we fix
>  it in 2.6.25?  2.6.24?  etc.
>
>

The name GPIO27_CLK came from sa1100 arm sub-arch. There the 3.6 MHz
clock was provided via GPIO 27. The PXA clocks code have copied the
name for the clock (as it's used by sa1111 companion chip that can be
used with both sa1100 and pxa). However on pxa the 3.6MHz clock is
provided by different PIN. So the name GPIO27_CLK is misleading and
incorrect for PXA.

In my patchset I've changed the name of the clock to correct
GPIO11_CLK and have made both sa1100 and pxa provide common clock name
("3_6MHz_CLK").

This isn't a matter of userspace interfaces or communication. It's a
matter of logic and self-correctness.

If you wish I can put this information in the patch header.

-- 
With best wishes
Dmitry
