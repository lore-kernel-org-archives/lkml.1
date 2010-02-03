Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932323Ab0BCJkW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 04:40:22 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:37770 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755769Ab0BCJkT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 04:40:19 -0500
Date: Wed, 3 Feb 2010 10:40:16 +0100
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Eric Miao <eric.y.miao@gmail.com>
Cc: Amit Kucheria <amit.kucheria@canonical.com>,
       List Linux Kernel <linux-kernel@vger.kernel.org>,
       linux@arm.linux.org.uk, Dinh.Nguyen@freescale.com,
       grant.likely@secretlab.ca, r.herring@freescale.com,
       linux-arm-kernel@lists.infradead.org, daniel@caiaq.de,
       bryan.wu@canonical.com, valentin.longchamp@epfl.ch
Subject: Re: [PATCHv2 03/11] mxc: Fix Drive Strength Field in the IOMUX
	controller
Message-ID: <20100203094016.GL6130@pengutronix.de>
References: <cover.1265173246.git.amit.kucheria@verdurent.com> <0511204199ab83aed2340e70a4639500c0528dab.1265173480.git.amit.kucheria@canonical.com> <cover.1265173480.git.amit.kucheria@canonical.com> <9fa7a3c70c46a1f776c6520051481cff6525ef02.1265173480.git.amit.kucheria@canonical.com> <ccc89dd7a6035abf5a78680404a2b30b9e025353.1265173480.git.amit.kucheria@canonical.com> <f17812d71002022229g4daef16fhe398c7bd76bad8e2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f17812d71002022229g4daef16fhe398c7bd76bad8e2@mail.gmail.com>
X-Sent-From: Pengutronix Entwicklungszentrum Nord - Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Impressum: Pengutronix - Industrial Linux Solutions Handelsregister:
	Amtsgericht Hildesheim, HRA 2686 Peiner Strasse 6-8, 31137
	Hildesheim, Germany Phone: +49-5121-206917-0 |  Fax:
	+49-5121-206917-5555 Inhaber: Dipl.-Ing. Robert Schwebel
X-Message-Flag: See Message Headers for Impressum
X-Uptime: 10:33:57 up 113 days, 22:23, 54 users,  load average: 1.22, 1.27,
	1.35
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 02, 2010 at 10:29:50PM -0800, Eric Miao wrote:
> On Tue, Feb 2, 2010 at 9:16 PM, Amit Kucheria
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
> 
> I'm seeing some changes in recent kernel with introduction of PAD_CTL_DRV_*,
> which also affects mx3, think it's a tough problem to keep backward
> compatibility
> now, one way out is to introduce maybe PAD_CTL_DRV_EXTREME specifically
> for imx51.

Given that the values are the same on i.MX3 and i.MX51 we could also
do a

#define PAD_CTL_DSE(x)	((x) << 1)

and add a comment for allowed values 0..2 for i.MX3 and 0..3 for i.MX51.

Sascha


-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
