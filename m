Return-Path: <linux-kernel-owner+w=401wt.eu-S1753358AbZBCLnS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753358AbZBCLnS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 06:43:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751755AbZBCLnH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 06:43:07 -0500
Received: from cable-static-49-187.intergga.ch ([157.161.49.187]:49654 "EHLO
	mail.ffwll.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750845AbZBCLnG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 06:43:06 -0500
X-Spam-Hammy: 0.000-+--HCc:D*org, 0.000-+--H*Ad:D*kernel.org, 
	0.000-+--H*Ad:D*vger.kernel.org
X-Spam-Spammy: 
Date: Tue, 3 Feb 2009 12:43:00 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: Dave Airlie <airlied@linux.ie>
Cc: Andrew Morton <akpm@linux-foundation.org>, Daniel Vetter <daniel@ffwll.ch>,
       linux-kernel@vger.kernel.org, Jesse Barnes <jbarnes@virtuousgeek.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, dri-devel@lists.sourceforge.net
Subject: Re: + drivers-gpu-drm-i915-intel_lvdsc-fix-locking-snafu.patch
	added to -mm tree
Message-ID: <20090203114300.GB4523@viiv.ffwll.ch>
Mail-Followup-To: Dave Airlie <airlied@linux.ie>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org,
	Jesse Barnes <jbarnes@virtuousgeek.org>,
	"Rafael J. Wysocki" <rjw@sisk.pl>, dri-devel@lists.sourceforge.net
References: <200901292050.n0TKol5b015605@imap1.linux-foundation.org> <200901291324.17624.jbarnes@virtuousgeek.org> <20090129134825.620e3f84.akpm@linux-foundation.org> <20090131152508.GA4668@viiv.ffwll.ch> <20090202224448.b19eaca4.akpm@linux-foundation.org> <alpine.DEB.2.00.0902030955420.31073@skynet.skynet.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0902030955420.31073@skynet.skynet.ie>
X-Operating-System: Linux viiv 2.6.29-rc2-00443-ge2a80a2 
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I can confirm that this patch fixes the problem. I tested with the locking
validator, and it looks like locking is now fine on my hardware.

Thanks everyone for tracking down this issue.

-Daniel

On Tue, Feb 03, 2009 at 09:58:16AM +0000, Dave Airlie wrote:
> On Mon, 2 Feb 2009, Andrew Morton wrote:
> 
> > (cc's added)
> > 
> > On Sat, 31 Jan 2009 16:25:08 +0100 Daniel Vetter <daniel@ffwll.ch> wrote:
> > 
> > > On Thu, Jan 29, 2009 at 01:48:25PM -0800, Andrew Morton wrote:
> > > > On Thu, 29 Jan 2009 13:24:17 -0800
> > > > Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
> > > > > On Thursday, January 29, 2009 12:50 pm akpm@linux-foundation.org wrote:
> > 
> > So I assume that it would make sense to track this as a post-2.6.28
> > regression?
> > 
> 
> From ac048e1734699dd98f4bdf4daf2b9592d4a4d38e Mon Sep 17 00:00:00 2001
> From: Dave Airlie <airlied@redhat.com>
> Date: Tue, 3 Feb 2009 19:05:12 +1000
> Subject: [PATCH] i915: fix unneeded locking in i915 LVDS get modes code.
> 
> This code is always called under the lock from the higher layers,
> so need to go locking it here.
> 
> Signed-off-by: Dave Airlie <airlied@redhat.com>
> ---
>  drivers/gpu/drm/i915/intel_lvds.c |    2 --
>  1 files changed, 0 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/gpu/drm/i915/intel_lvds.c b/drivers/gpu/drm/i915/intel_lvds.c
> index b36a521..cf8da64 100644
> --- a/drivers/gpu/drm/i915/intel_lvds.c
> +++ b/drivers/gpu/drm/i915/intel_lvds.c
> @@ -311,10 +311,8 @@ static int intel_lvds_get_modes(struct drm_connector *connector)
>  	if (dev_priv->panel_fixed_mode != NULL) {
>  		struct drm_display_mode *mode;
>  
> -		mutex_lock(&dev->mode_config.mutex);
>  		mode = drm_mode_duplicate(dev, dev_priv->panel_fixed_mode);
>  		drm_mode_probed_add(connector, mode);
> -		mutex_unlock(&dev->mode_config.mutex);
>  
>  		return 1;
>  	}
> -- 
> 1.6.0.6
> 

-- 
Daniel Vetter
E-Mail: daniel.vetter@ffwll.ch
Tel.: +41 (0)79 365 57 48
