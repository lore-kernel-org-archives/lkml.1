Return-Path: <linux-kernel-owner+w=401wt.eu-S1756395AbYLKBcl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756395AbYLKBcl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 20:32:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756099AbYLKBc2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 20:32:28 -0500
Received: from az33egw02.freescale.net ([192.88.158.103]:35516 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755871AbYLKBc1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 20:32:27 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 3/4 v2] i.MX31: framebuffer driver
Date: Wed, 10 Dec 2008 18:32:21 -0700
Message-ID: <DE2504B3A515524BBE6934369EFDC0DA06FBD7E5@az33exm20.fsl.freescale.net>
In-Reply-To: <Pine.LNX.4.64.0812101727270.4578@axis700.grange>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 3/4 v2] i.MX31: framebuffer driver
Thread-Index: Acla5zCuH9rUUGjtSn2CwyJtsbqBKAAHtriQ
References: <Pine.LNX.4.64.0812101122250.4578@axis700.grange> <Pine.LNX.4.64.0812101131530.4578@axis700.grange> <DE2504B3A515524BBE6934369EFDC0DA06FBD5E8@az33exm20.fsl.freescale.net> <Pine.LNX.4.64.0812101727270.4578@axis700.grange>
From: "Herring Robert" <R.Herring@freescale.com>
To: "Guennadi Liakhovetski" <g.liakhovetski@gmx.de>
Cc: <linux-fbdev-devel@lists.sourceforge.net>, <adaplas@gmail.com>,
       "Sascha Hauer" <s.hauer@pengutronix.de>,
       <linux-arm-kernel@lists.arm.linux.org.uk>,
       "Dan Williams" <dan.j.williams@intel.com>,
       <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Guennadi,

> -----Original Message-----
> From: Guennadi Liakhovetski [mailto:g.liakhovetski@gmx.de] 
> Sent: Wednesday, December 10, 2008 10:48 AM
> To: Herring Robert-RA7055
> Cc: linux-fbdev-devel@lists.sourceforge.net; 
> adaplas@gmail.com; Sascha Hauer; 
> linux-arm-kernel@lists.arm.linux.org.uk; Dan Williams; 
> linux-kernel@vger.kernel.org
> Subject: RE: [PATCH 3/4 v2] i.MX31: framebuffer driver
> 
> On Wed, 10 Dec 2008, Herring Robert wrote:
> 
> > You have obviously started with Freescale copyrighted GPL 
> code, but you
> > have not given credit or maintained our copyrights.
> 
> I did try to do this, at least in those files, which contain 
> significant 
> portions of Freescale code. If you feel that I missed it in 
> some specific 
> files please let me know, I'll happily add it, it was in no way my 
> intension to steal the authorschip. E.g.:
> 

Sorry, my mistake. I looked at the headers and missed the copyrights on
the C files.

> > > diff --git a/drivers/video/mx3fb.c b/drivers/video/mx3fb.c
> > > new file mode 100644
> > > index 0000000..e8084ae
> > > --- /dev/null
> > > +++ b/drivers/video/mx3fb.c
> > > @@ -0,0 +1,1843 @@
> > > +/*
> > > + * Copyright (C) 2008
> > > + * Guennadi Liakhovetski, DENX Software Engineering, <lg@denx.de>
> > > + *
> > > + * Copyright 2004-2007 Freescale Semiconductor, Inc. All 
> Rights Reserved.
> ...
> > > +MODULE_AUTHOR("Freescale Semiconductor, Inc.");
> 
> ...
> 
> From IPU IDMAC driver:
> 
> diff --git a/drivers/mfd/ipu/ipu_idmac.c b/drivers/mfd/ipu/ipu_idmac.c
> new file mode 100644
> index 0000000..939acbf
> --- /dev/null
> +++ b/drivers/mfd/ipu/ipu_idmac.c
> @@ -0,0 +1,1617 @@
> +/*
> + * Copyright (C) 2008
> + * Guennadi Liakhovetski, DENX Software Engineering, <lg@denx.de>
> + *
> + * Copyright (C) 2005-2007 Freescale Semiconductor, Inc. All 
> Rights Reserved.
> 
> Please tell me in which other files and in which form you'd 
> like to see 
> Freescale mentioned.
> 
> > The way you have structured the code moving the low-level 
> SDC setup to
> > the framebuffer will cause problems. There are lots of inter-module
> > dependencies that have to be handled in the correct order to avoid
> > hanging the h/w. For example, the SDC BG_EN has to be cleared before
> > disabling the IDMA channel.
> 
> I tried to preserve the hardware handling code and the 
> calling sequence. 
> For example, I think, this is exactly what I do in this driver - 
> sdc_disable_channel() first calls sdc_fb_uninit(), which clears the 
> SDC_COM_FG_EN bit in SDC_COM_CONF, and then idmac_terminate_all() is 
> called, which disables the IDMAC channel. Or have I 
> understood you wrong?
> 
> > This structure will also not allow reuse of framebuffer, 
> camera, and 
> > v4l2 output drivers with the next version of h/w.
> 
> Why? All the generic (IDMAC, interrupt controller) code is put in a 
> separate driver under drivers/mfd/ipu (see my patch 2/4), and only 
> Synchronous Display Controller and Display Interface handling 
> code is in 
> the framebuffer driver. And the generic code is also used by 
> the camera 
> driver, whose second version is also going to be submitted to 
> the V4L list 
> soon. As for the "next version of h/w" - sorry, obviously I 
> know nothing 
> about it, so I cannot programme for it.
> 
> Besides, please understand, that I can develop and submit 
> only parts that 
> I test. Having no smart displays I cannot develop, test and submit 
> Asynchronous Display Controller code, etc.
> 

Smart panels aren't too widely used anyway.

> May I also note, that if Freescale made the effort and 
> integrated their 
> sources into the mainline, we wouldn't have this discussion 
> now, the code 
> would be structured the way you see best (as long as it is 
> accepted by the 
> maintainers) and would support any versions of hardware you like.

Yes, I know and wish we were not in this situation.

Regards,
Rob
