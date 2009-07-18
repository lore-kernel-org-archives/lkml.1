Return-Path: <linux-kernel-owner+w=401wt.eu-S1754766AbZGRBWT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754766AbZGRBWT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jul 2009 21:22:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753755AbZGRBWQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Jul 2009 21:22:16 -0400
Received: from outbound-mail-315.bluehost.com ([67.222.54.8]:39947 "HELO
	outbound-mail-315.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752283AbZGRBWQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jul 2009 21:22:16 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=ZiJ3T+DW1ymDu6/JdmkBuBH3h/oGF3vNKDxbpQG5cYm4UyzU4ucjvBWwe232SLspzAo9bzv5Q9b/0CmWWXJtGpwj9RgSbFGNP0p1igBugD0hkPZ9QtGS7K0v6kCLe5jt;
Date: Fri, 17 Jul 2009 18:22:12 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: airlied@linux.ie, linux-kernel@vger.kernel.org,
       linux-fbdev-devel@lists.sourceforge.net
Subject: Re: [PATCH] fb/intelfb: conflict with DRM_I915 and hide by default
Message-ID: <20090717182212.4675d0e1@jbarnes-g45>
In-Reply-To: <20090717171326.4a71d8e3.akpm@linux-foundation.org>
References: <20090703112446.5a69971b@jbarnes-g45>
	<20090717171326.4a71d8e3.akpm@linux-foundation.org>
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 17 Jul 2009 17:13:26 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Fri, 3 Jul 2009 11:24:46 -0700
> Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
> 
> > Users get confused by this driver.  It's really a special purpose
> > embedded driver, and causes a lot of problems if enabled.  So hide
> > it under EMBEDDED by default, and make sure it doesn't get enabled
> > with the i915 DRM driver.
> > 
> > Dave, I'm hoping you can feed this to Linus through your tree.  It's
> > appropriate for 2.6.31 I think.
> > 
> > Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
> > 
> > diff --git a/drivers/video/Kconfig b/drivers/video/Kconfig
> > index d6d65ef..ec12f7a 100644
> > --- a/drivers/video/Kconfig
> > +++ b/drivers/video/Kconfig
> > @@ -1117,12 +1117,13 @@ config FB_CARILLO_RANCH
> >  
> >  config FB_INTEL
> >  	tristate "Intel
> > 830M/845G/852GM/855GM/865G/915G/945G/945GM/965G/965GM support
> > (EXPERIMENTAL)"
> > -	depends on EXPERIMENTAL && FB && PCI && X86 && AGP_INTEL
> > +	depends on EXPERIMENTAL && FB && PCI && X86 && AGP_INTEL
> > && EMBEDDED select FB_MODE_HELPERS
> >  	select FB_CFB_FILLRECT
> >  	select FB_CFB_COPYAREA
> >  	select FB_CFB_IMAGEBLIT
> >  	select FB_BOOT_VESA_SUPPORT if FB_INTEL = y
> > +	depends on !DRM_I915
> >  	help
> >  	  This driver supports the on-board graphics built in to
> > the Intel
> > 830M/845G/852GM/855GM/865G/915G/915GM/945G/945GM/965G/965GM
> > chipsets.
> 
> Nothing happened?
> 
> I'll merge this next week(ish) unless given a reason not to.

It's in Dave's tree, pull requested to Linus already, so it should land
soon.

-- 
Jesse Barnes, Intel Open Source Technology Center
