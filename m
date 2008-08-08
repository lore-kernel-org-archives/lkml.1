Return-Path: <linux-kernel-owner+w=401wt.eu-S1754917AbYHHBCn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754917AbYHHBCn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 21:02:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751351AbYHHBCg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 21:02:36 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:14908 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751287AbYHHBCf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 21:02:35 -0400
Date: Thu, 7 Aug 2008 17:55:52 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Dave Airlie <airlied@linux.ie>
Cc: lkml <linux-kernel@vger.kernel.org>, akpm <akpm@linux-foundation.org>
Subject: Re: [PATCH -next] drm: sis depends on FB_SIS
Message-Id: <20080807175552.67d5385d.randy.dunlap@oracle.com>
In-Reply-To: <alpine.DEB.0.82.0808080008050.13875@skynet.skynet.ie>
References: <20080807083228.0fc40405.randy.dunlap@oracle.com>
	<alpine.DEB.0.82.0808080008050.13875@skynet.skynet.ie>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 Aug 2008 00:09:42 +0100 (IST) Dave Airlie wrote:

> 
> > From: Randy Dunlap <randy.dunlap@oracle.com>
> > cc: airlied@linux.ie
> > 
> > drm/sis calls mm functions in fb/sis, so make the former depend
> > on the latter.
> > 
> > This one happened with FB_SIS=m, AGP_SIS=y, DRM_SYS=y.
> > 
> > sis1.out:sis_mm.c:(.text+0x70014): undefined reference to `sis_free'
> > sis1.out:sis_mm.c:(.text+0x7002a): undefined reference to `sis_malloc'
> > 
> > Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> 
> NAK but I've no idea what the right answer is.

I sort of expected a NAK.  Is OK.


> If someone asks for sisfb then sis drm uses code from it, if they don't 
> ask for it it doesn't. So I want sisfb to be built in if its selected and 
> sis drm is built-in.

config DRM_SIS
	select FB_SIS

might do it.

> Maybe I should just rip the dependency out completely, but this patch will 
> break stuff badly, if someone was using the SIS DRM without sisfb.
> 
> Dave.
> 
>  > ---
> >  drivers/gpu/drm/Kconfig |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > --- linux-next-20080806.orig/drivers/gpu/drm/Kconfig
> > +++ linux-next-20080806/drivers/gpu/drm/Kconfig
> > @@ -86,7 +86,7 @@ config DRM_MGA
> >  
> >  config DRM_SIS
> >  	tristate "SiS video cards"
> > -	depends on DRM && AGP
> > +	depends on DRM && AGP && FB_SIS
> >  	help
> >  	  Choose this option if you have a SiS 630 or compatible video
> >            chipset. If M is selected the module will be called sis. AGP

---
~Randy
Linux Plumbers Conference, 17-19 September 2008, Portland, Oregon USA
http://linuxplumbersconf.org/
