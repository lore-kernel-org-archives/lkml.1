Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933020Ab0BDAbt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 19:31:49 -0500
Received: from mail-qy0-f201.google.com ([209.85.221.201]:46916 "EHLO
	mail-qy0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932096Ab0BDAbr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 19:31:47 -0500
X-Greylist: delayed 384 seconds by postgrey-1.27 at vger.kernel.org; Wed, 03 Feb 2010 19:31:47 EST
Date: Wed, 3 Feb 2010 16:25:18 -0800
From: Amit Kucheria <amit.kucheria@canonical.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: List Linux Kernel <linux-kernel@vger.kernel.org>,
       linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk,
       s.hauer@pengutronix.de, valentin.longchamp@epfl.ch, daniel@caiaq.de,
       Dinh.Nguyen@freescale.com, r.herring@freescale.com,
       bryan.wu@canonical.com
Subject: Re: [PATCHv2 03/11] mxc: Fix Drive Strength Field in the IOMUX
 controller
Message-ID: <20100204002518.GB5274@k2>
Mail-Followup-To: Grant Likely <grant.likely@secretlab.ca>,
	List Linux Kernel <linux-kernel@vger.kernel.org>,
	linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk,
	s.hauer@pengutronix.de, valentin.longchamp@epfl.ch, daniel@caiaq.de,
	Dinh.Nguyen@freescale.com, r.herring@freescale.com,
	bryan.wu@canonical.com
References: <cover.1265173246.git.amit.kucheria@verdurent.com>
 <0511204199ab83aed2340e70a4639500c0528dab.1265173480.git.amit.kucheria@canonical.com>
 <cover.1265173480.git.amit.kucheria@canonical.com>
 <9fa7a3c70c46a1f776c6520051481cff6525ef02.1265173480.git.amit.kucheria@canonical.com>
 <ccc89dd7a6035abf5a78680404a2b30b9e025353.1265173480.git.amit.kucheria@canonical.com>
 <fa686aa41002030827m16efb947uc798cd538a6f786c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <fa686aa41002030827m16efb947uc798cd538a6f786c@mail.gmail.com>
X-URL: http://www.verdurent.com/
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10 Feb 03, Grant Likely wrote:
> On Tue, Feb 2, 2010 at 10:16 PM, Amit Kucheria
> <amit.kucheria@canonical.com> wrote:
> > i.MX51 defines 4 values:
> >
> > 00: Low Drive Strength
> > 01: Medium Drive Strength
> > 10: High Drive Strength
> > 11: Max Drive Strength
> >
> > Signed-off-by: Amit Kucheria <amit.kucheria@canonical.com>
> > ---
> >  arch/arm/plat-mxc/include/mach/iomux-v3.h |    8 +++++---
> >  1 files changed, 5 insertions(+), 3 deletions(-)
> >
> > diff --git a/arch/arm/plat-mxc/include/mach/iomux-v3.h b/arch/arm/plat-mxc/include/mach/iomux-v3.h
> > index 1deda01..f2f73d3 100644
> > --- a/arch/arm/plat-mxc/include/mach/iomux-v3.h
> > +++ b/arch/arm/plat-mxc/include/mach/iomux-v3.h
> > @@ -81,11 +81,13 @@ struct pad_desc {
> >
> >  #define PAD_CTL_ODE                    (1 << 3)
> >
> > -#define PAD_CTL_DSE_STANDARD           (0 << 1)
> > -#define PAD_CTL_DSE_HIGH               (1 << 1)
> > -#define PAD_CTL_DSE_MAX                        (2 << 1)
> > +#define PAD_CTL_DSE_LOW                        (0 << 1)
> > +#define PAD_CTL_DSE_MED                        (1 << 1)
> > +#define PAD_CTL_DSE_HIGH               (2 << 1)
> > +#define PAD_CTL_DSE_MAX                        (3 << 1)
> >
> >  #define PAD_CTL_SRE_FAST               (1 << 0)
> > +#define PAD_CTL_SRE_SLOW               (0 << 0)
> 
> Shouldn't the addition/change of #defines be done in patches that
> actually use them?

I'll merge it into patch 5 that adds the core support for i.MX5. I kept it
separate because the #defines are a (standalone) property of the IOMUX
controller regardless of whether they are used by i.MX5 or not.

Thanks for all the reviews.

/Amit

-- 
-------------------------------------------------------------------------
Amit Kucheria,				 Kernel Developer, Verdurent
-------------------------------------------------------------------------
