Return-Path: <linux-kernel-owner+w=401wt.eu-S1755618AbYHSWcK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755618AbYHSWcK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 18:32:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751665AbYHSWb4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 18:31:56 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:52600 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751364AbYHSWbz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 18:31:55 -0400
Date: Tue, 19 Aug 2008 15:31:00 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Adrian Bunk <bunk@kernel.org>
Cc: Dave Airlie <airlied@linux.ie>, lkml <linux-kernel@vger.kernel.org>,
       akpm <akpm@linux-foundation.org>
Subject: Re: [RFC: -next patch] don't allow FB_SIS=m, DRM_SIS=y
Message-Id: <20080819153100.3bc3d8ef.randy.dunlap@oracle.com>
In-Reply-To: <20080813215728.GD7071@cs181140183.pp.htv.fi>
References: <20080807083228.0fc40405.randy.dunlap@oracle.com>
	<alpine.DEB.0.82.0808080008050.13875@skynet.skynet.ie>
	<20080807175552.67d5385d.randy.dunlap@oracle.com>
	<alpine.DEB.0.82.0808080309270.13875@skynet.skynet.ie>
	<20080812125906.GC13910@cs181140183.pp.htv.fi>
	<alpine.DEB.0.82.0808122236130.13090@skynet.skynet.ie>
	<20080813215728.GD7071@cs181140183.pp.htv.fi>
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

On Thu, 14 Aug 2008 00:57:28 +0300 Adrian Bunk wrote:

> On Tue, Aug 12, 2008 at 10:37:00PM +0100, Dave Airlie wrote:
> > 
> > > > 
> > > > Maybe the other way around, I don't want DRM_SIS influencing whether 
> > > > FB_SIS is on or off, if the user wants sisfb on, then when they select it, 
> > > > DRM_SIS should be built in the same way. But if sisfb isn't selected by 
> > > > the user, then selecting DRM_SIS shouldn't enable it.
> > > 
> > > If FB_SIS=m, should DRM_SIS=y be allowed or should in this case DRM_SIS 
> > > be restricted to n/m?
> > 
> > Probably not. if FB_SIS is selected at all, DRM_SIS should match it, if 
> > FB_SIS isn't selected, DRM_SIS should not select it.
> 
> I assume FB_SIS=y, DRM_SIS=m should still be possible?
> 
> If this assumption is correct the fix is below.
> 
> > Dave.
> 
> cu
> Adrian
> 
> 
> <--  snip  -->
> 
> 
> FB_SIS=m, DRM_SIS=y is not a legal configuration.
> 
> Reported-by: Randy Dunlap <randy.dunlap@oracle.com>
> Signed-off-by: Adrian Bunk <bunk@kernel.org>
> 
> ---
> c303119b9561e13be97f3d4b0d7eaa6930fc21d8 
> diff --git a/drivers/gpu/drm/Kconfig b/drivers/gpu/drm/Kconfig
> index 610d6fd..bf9003e 100644
> --- a/drivers/gpu/drm/Kconfig
> +++ b/drivers/gpu/drm/Kconfig
> @@ -87,6 +87,7 @@ config DRM_MGA
>  config DRM_SIS
>  	tristate "SiS video cards"
>  	depends on DRM && AGP
> +	depends on FB_SIS || FB_SIS=n
>  	help
>  	  Choose this option if you have a SiS 630 or compatible video
>            chipset. If M is selected the module will be called sis. AGP
> 
> --

Thanks, Adrian.

I don't know if that's the proper fix, but something needs to be fixed/merged.  :(


---
~Randy
Linux Plumbers Conference, 17-19 September 2008, Portland, Oregon USA
http://linuxplumbersconf.org/
