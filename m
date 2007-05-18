Return-Path: <linux-kernel-owner+w=401wt.eu-S1759966AbXERTdK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759966AbXERTdK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 15:33:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753742AbXERTc6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 15:32:58 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:21233 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752277AbXERTc5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 15:32:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:content-transfer-encoding:in-reply-to:user-agent;
        b=PZltwIIj0DqbW5RwnY9Ogp7rR1jKO52tgKSO6FlLRgf96/c7x91i7YUk8/VdGdzYe4FZtpz1HBJtUAVkkmydVNhPtWBnytVOorZ7pxIghNONLyx3euj0Hs7iLqaFrtC1Nx+roAFc8PeFAFOHSpPQJjb1kSqoIf1NGR6teNGIOOI=
Date: Fri, 18 May 2007 21:33:02 +0200
From: Luca Tettamanti <kronos.it@gmail.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Jesse Barnes <jesse.barnes@intel.com>, linux-kernel@vger.kernel.org,
       James Simmons <jsimmons@pentafluge.infradead.org>,
       Dave Airlie <airlied@gmail.com>,
       "Antonino A. Daplas" <adaplas@gmail.com>,
       dri-devel@lists.sourceforge.net
Subject: Re: [PATCH 2/3] drm modesetting core
Message-ID: <20070518193302.GA11609@dreamland.darkstar.lan>
References: <200705171423.46748.jesse.barnes@intel.com> <200705171537.46639.jesse.barnes@intel.com> <20070517234135.GA18012@dreamland.darkstar.lan> <200705171804.54626.jbarnes@virtuousgeek.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200705171804.54626.jbarnes@virtuousgeek.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Il Thu, May 17, 2007 at 06:04:54PM -0700, Jesse Barnes ha scritto: 
> On Thursday, May 17, 2007, Luca Tettamanti wrote:
> > Il Thu, May 17, 2007 at 03:37:45PM -0700, Jesse Barnes ha scritto:
> > > This patch adds the core of the new DRM based modesetting system.
> >
> > A couple of comments on drm_fb since I'm somewhat familiar with fb code:
> > > new file mode 100644
> > > index 0000000..0d06792
> > > --- /dev/null
> > > +++ b/linux-core/drm_edid.c
> > > @@ -0,0 +1,467 @@
> > > +/*
> > > + * Copyright (c) 2007 Intel Corporation
> > > + *   Jesse Barnes <jesse.barnes@intel.com>
> > > + *
> > > + * DDC probing routines (drm_ddc_read & drm_do_probe_ddc_edid)
> > > originally from
> > > + * FB layer.
> >
> > Hum, why are you duplicating them here? fbmon.c has the
> > infrastructure for parsing and even fixing known-broken EDIDs.
> 
> Yeah, there's more sharing that could be done... though I don't think the 
> fb layer has the bits to actually grab EDIDs.

There are the I2C functions (fb_do_probe_ddc_edid, fb_ddc_read - I wrote
them for the radeon driver, but now are available for general use) which
will issue the read command; fbmon.c has the stuff for parsing the EDID;
you usualy build a DB of supported modes which is then used to validate
the mode requested by the user. Of course each driver has to implement
the I2C adapter.

> Also, DRM is shared with BSD...

Your patch already uses 'struct i2c_adapter' in drm_edid.c, is it
portable?

Luca
-- 
"Vorrei morire ucciso dagli agi. Vorrei che di me si dicesse: ``Com'è
morto?'' ``Gli è scoppiato il portafogli''" -- Marcello Marchesi
