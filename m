Return-Path: <linux-kernel-owner+w=401wt.eu-S1757348AbZA2Hrs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757348AbZA2Hrs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 02:47:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752924AbZA2Hri
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 02:47:38 -0500
Received: from utopia.booyaka.com ([72.9.107.138]:54869 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752779AbZA2Hrh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 02:47:37 -0500
Date: Thu, 29 Jan 2009 00:47:36 -0700 (MST)
From: Paul Walmsley <paul@pwsan.com>
To: "Woodruff, Richard" <r-woodruff2@ti.com>
cc: "linux-arm-kernel@lists.arm.linux.org.uk" 
	<linux-arm-kernel@lists.arm.linux.org.uk>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       Tony Lindgren <tony@atomide.com>
Subject: RE: [PATCH B 06/10] OMAP3 pwrdm: add CORE SAR handling (for USBTLL
 module)
In-Reply-To: <13B9B4C6EF24D648824FF11BE89671620376DEB7A5@dlee02.ent.ti.com>
Message-ID: <alpine.DEB.2.00.0901290042020.32081@utopia.booyaka.com>
References: <20090128024301.27240.39391.stgit@localhost.localdomain> <20090128024421.27240.95450.stgit@localhost.localdomain> <13B9B4C6EF24D648824FF11BE89671620376DEB7A5@dlee02.ent.ti.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Richard,

On Wed, 28 Jan 2009, Woodruff, Richard wrote:

> > 34xx TRM Delta G->H notes that the CORE powerdomain has a hardware
> > save-and-restore (SAR) control bit for the USBTLL module, similar to
> > the USBHOST powerdomain SAR bit.  Split the existing core_34xx struct
> > powerdomain into two structs, one for ES1 and one for ES2, and add the
> > PWRDM_HAS_HDWR_SAR flag to the ES2 powerdomain.
> >
> > Signed-off-by: Paul Walmsley <paul@pwsan.com>
> > Signed-off-by: Tony Lindgren <tony@atomide.com>
> > +
> > +/* No wkdeps or sleepdeps for 34xx core apparently */
> > +static struct powerdomain core_34xx_es2_pwrdm = {
> > +     .name             = "core_pwrdm",
> > +     .prcm_offs        = CORE_MOD,
> > +     .omap_chip        = OMAP_CHIP_INIT(CHIP_IS_OMAP3430ES2),
> >       .pwrsts           = PWRSTS_OFF_RET_ON,
> >       .dep_bit          = OMAP3430_EN_CORE_SHIFT,
> > +     .flags            = PWRDM_HAS_HDWR_SAR, /* for USBTLL only */
> >       .banks            = 2,
> >       .pwrsts_mem_ret   = {
> >               [0] = PWRSTS_OFF_RET,    /* MEM1RETSTATE */
> 
> TLLSAR is not functional till ES3.1 (and beyound).  Is it possible to flag it this way?

Yes, it's easy in this case.  Thanks for the note.  I will send along an 
updated patch for this.

> If you try and use it your system will deadlock on 2nd OFF mode transition due to hardware bug.


- Paul
