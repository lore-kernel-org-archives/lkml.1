Return-Path: <linux-kernel-owner+w=401wt.eu-S964842AbZLGRRz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964842AbZLGRRz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 12:17:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964833AbZLGRRw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 12:17:52 -0500
Received: from az33egw02.freescale.net ([192.88.158.103]:46606 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964800AbZLGRRu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 12:17:50 -0500
x-mimeole: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Subject: RE: [RFC][PATCH 03/10] arm: mxc: changes to common plat-mxc codeto add support for i.MX5
Date: Mon, 7 Dec 2009 10:17:52 -0700
Message-ID: <DE2504B3A515524BBE6934369EFDC0DA08C2A879@az33exm20.fsl.freescale.net>
In-Reply-To: <20091204105908.GJ15126@pengutronix.de>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [RFC][PATCH 03/10] arm: mxc: changes to common plat-mxc codeto add support for i.MX5
Thread-Index: Acp00NO49BEGr2hbSAed6OtZ7SxpoQCiSKlQ
References: <cover.1259893118.git.amit.kucheria@canonical.com> <58eb7d14c6cf56cbc874657dff5789c47116b49e.1259893118.git.amit.kucheria@canonical.com> <DE2504B3A515524BBE6934369EFDC0DA08C2A56C@az33exm20.fsl.freescale.net> <20091204083451.GG15126@pengutronix <20091204105908.GJ15126@pengutronix.de>
From: "Herring Robert-RA7055" <ra7055@freescale.com>
To: "Sascha Hauer" <s.hauer@pengutronix.de>,
       "Amit Kucheria" <amit.kucheria@canonical.com>
Cc: "List Linux Kernel" <linux-kernel@vger.kernel.org>,
       <linux-arm-kernel@lists.infradead.org>, <valentin.longchamp@epfl.ch>,
       <daniel@caiaq.de>, <grant.likely@secretlab.ca>,
       "Nguyen Dinh-R00091" <R00091@freescale.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sasha, Amit,

> -----Original Message-----
> From: Sascha Hauer [mailto:s.hauer@pengutronix.de] 
> Sent: Friday, December 04, 2009 4:59 AM
> To: Amit Kucheria
> Cc: Herring Robert-RA7055; List Linux Kernel; 
> linux-arm-kernel@lists.infradead.org; 
> valentin.longchamp@epfl.ch; daniel@caiaq.de; 
> grant.likely@secretlab.ca; Nguyen Dinh-R00091
> Subject: Re: [RFC][PATCH 03/10] arm: mxc: changes to common 
> plat-mxc codeto add support for i.MX5
> 
> On Fri, Dec 04, 2009 at 12:31:02PM +0200, Amit Kucheria wrote:
> > Some comments below:
> > 
> > On 09 Dec 04, Sascha Hauer wrote:
> > > On Thu, Dec 03, 2009 at 08:12:58PM -0700, Herring 
> Robert-RA7055 wrote:
> > > > Amit,
> > > > 
> > > > I would suggest you refactor the timer code into 
> version 1 and version 2
> > > > either as 2 separate files or with a timer_is_v2() 
> function rather than
> > > > the mess of cpu_is_X macros it currently has. 
> Essentially there are 2
> > > > versions of the timer hardware. Version 1 is found on 
> MX1/MXL and MX21.
> > > > Version 2 is found on MX25, MX27, MX31, MX35, MX37, 
> MX51, and future
> > > > parts. I will send you what we have done in our tree.
> > > Like this:
> > > 
> > > 
> > > commit ed6bbc59e3f6b33b48a0d5ac053220cd318ceee7
> > > Author: Sascha Hauer <s.hauer@pengutronix.de>
> > > Date:   Tue Nov 17 16:31:13 2009 +0100
> > > 
> > >     mxc timer: Add mx51 support
> > >     
> > >     Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
> > > 
> > > diff --git a/arch/arm/plat-mxc/time.c b/arch/arm/plat-mxc/time.c
> > > index 844567e..0c45509 100644
> > > --- a/arch/arm/plat-mxc/time.c
> > > +++ b/arch/arm/plat-mxc/time.c
> > > @@ -57,6 +57,9 @@
> > >  #define MX3_TCN			0x24
> > >  #define MX3_TCMP		0x10
> > >  
> > > +#define timer_is_v1()	(cpu_is_mx1() || cpu_is_mx27())
> >                                                         ^^^^
> >                                       Shouldn't this be 
> mx21 according to
> > 				      Rob's comment?
> 
> i.MX1, i.MX21 and i.MX27 are identical, at least that's what the code
> shows, so it should be:
> 
> #define timer_is_v1()      (cpu_is_mx1() || cpu_is_mx21() || 
> cpu_is_mx27())
> #define timer_is_v2()      (cpu_is_mx3() || cpu_is_mx25() || 
> cpu_is_mx51() || cpu_is_mxc91231())

Sorry, my mistake. Sasha is correct that MX27 is v1 and MX25 is v2.

timer_is_v1 is just !timer_is_v2, so really only one is needed. I would
define it like this to avoid having to change the timer code again for
any new chips:

#define timer_is_v2()   (!(cpu_is_mx1() || cpu_is_mx21() ||
cpu_is_mx27()))

Regards,
Rob
 
