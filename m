Return-Path: <linux-kernel-owner+w=401wt.eu-S1761630AbXERVGR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761630AbXERVGR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 17:06:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754537AbXERVGI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 17:06:08 -0400
Received: from mga03.intel.com ([143.182.124.21]:11853 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754072AbXERVGH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 17:06:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.14,553,1170662400"; 
   d="scan'208";a="229655945"
From: Jesse Barnes <jesse.barnes@intel.com>
To: Luca Tettamanti <kronos.it@gmail.com>
Subject: Re: [PATCH 2/3] drm modesetting core
Date: Fri, 18 May 2007 14:06:05 -0700
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org,
       James Simmons <jsimmons@pentafluge.infradead.org>,
       Dave Airlie <airlied@gmail.com>,
       "Antonino A. Daplas" <adaplas@gmail.com>,
       dri-devel@lists.sourceforge.net
References: <200705171423.46748.jesse.barnes@intel.com> <200705171804.54626.jbarnes@virtuousgeek.org> <20070518193302.GA11609@dreamland.darkstar.lan>
In-Reply-To: <20070518193302.GA11609@dreamland.darkstar.lan>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705181406.06690.jesse.barnes@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, May 18, 2007 12:33 pm Luca Tettamanti wrote:
> > Yeah, there's more sharing that could be done... though I don't
> > think the fb layer has the bits to actually grab EDIDs.
>
> There are the I2C functions (fb_do_probe_ddc_edid, fb_ddc_read - I
> wrote them for the radeon driver, but now are available for general
> use) which will issue the read command; fbmon.c has the stuff for
> parsing the EDID; you usualy build a DB of supported modes which is
> then used to validate the mode requested by the user. Of course each
> driver has to implement the I2C adapter.

I'll take a look at fbmon... I've seen the fb_ddc_read stuff but didn't 
see many drivers using it heavily.  I think it makes sense to reuse 
your code where possible (in fact some earlier versions of the code 
made more use of FB stuff but was removed or rewritten for various 
reasons).

> > Also, DRM is shared with BSD...
>
> Your patch already uses 'struct i2c_adapter' in drm_edid.c, is it
> portable?

I'm not sure how portable that will be.  But regardless, if Linux has 
some of this code already, I'd like to reuse it.  I'll go head and see 
what I can rip out.

In fact, I've received some comments pushing me towards moving the core 
code (crtc, mode management) to drivers/video instead of DRM.  That 
might make sense, especially if we can just use/extend the FB layer's 
mode tracking structures.

Thanks,
Jesse
