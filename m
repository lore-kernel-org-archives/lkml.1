Return-Path: <linux-kernel-owner+w=401wt.eu-S1758827AbZJMCca@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758827AbZJMCca (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 22:32:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758738AbZJMCc3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 22:32:29 -0400
Received: from thunk.org ([69.25.196.29]:43641 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758725AbZJMCc2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 22:32:28 -0400
Date: Mon, 12 Oct 2009 22:31:46 -0400
From: Theodore Tso <tytso@mit.edu>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: "Carlos R. Mafra" <crmafra2@gmail.com>, Eric Anholt <eric@anholt.net>,
       linux-kernel@vger.kernel.org, Keith Packard <keithp@keithp.com>
Subject: Re: 2.6.32 regression (bisected): Video tearing/glitching with
	T400 laptops
Message-ID: <20091013023146.GA8414@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Jesse Barnes <jbarnes@virtuousgeek.org>,
	"Carlos R. Mafra" <crmafra2@gmail.com>,
	Eric Anholt <eric@anholt.net>, linux-kernel@vger.kernel.org,
	Keith Packard <keithp@keithp.com>
References: <E1Mtqnb-0002x7-TJ@closure.thunk.org> <20091008103620.5e5aae66@jbarnes-g45> <20091010204106.GA8251@mit.edu> <20091012095438.1e82b54f@jbarnes-g45> <20091012184651.GA4603@Pilar.aei.mpg.de> <20091012120510.16bd1194@jbarnes-g45>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091012120510.16bd1194@jbarnes-g45>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 12, 2009 at 12:05:10PM -0700, Jesse Barnes wrote:
> On Mon, 12 Oct 2009 20:46:51 +0200
> "Carlos R. Mafra" <crmafra2@gmail.com> wrote:
> 
> > On Mon 12.Oct'09 at  9:54:38 -0700, Jesse Barnes wrote:
> > > > 
> > > > Nope, unfortunately, it's not helping on my T400 laptop.  I'm
> > > > still getting huge amounts of glitching and tearing with this
> > > > patch applied against -rc3.
> > > > 
> > > > What I'm using for now to fix up my system is this patch.
> > > > 
> > > 
> > > How about this one?  I have one more idea to try out if this doesn't
> > > work (hacking on it now).
> > 
> > I was also experiencing something very similar to Theodore's bug 
> > report and, at least for me, the patch below fixed the issue (the
> > previous one also had no effect).
> 
> Cool, good to hear.  Hopefully Ted and Keith will confirm too.

Hmm, the amount of tearing seems to be a bit less frequent, but it's
definitely still happening with this patch applied.  Sorry....

	   	 	   	     - Ted


> -- 
> Jesse Barnes, Intel Open Source Technology Center
> 
> diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
> index 7a5fb79..1451945 100644
> --- a/drivers/gpu/drm/i915/intel_display.c
> +++ b/drivers/gpu/drm/i915/intel_display.c
> @@ -1047,7 +1047,7 @@ static void g4x_enable_fbc(struct drm_crtc *crtc, unsigned long interval)
>  	dev_priv->cfb_fence = obj_priv->fence_reg;
>  	dev_priv->cfb_plane = intel_crtc->plane;
>  
> -	dpfc_ctl = plane | DPFC_SR_EN | DPFC_CTL_LIMIT_1X;
> +	dpfc_ctl = plane | DPFC_CTL_LIMIT_1X;
>  	if (obj_priv->tiling_mode != I915_TILING_NONE) {
>  		dpfc_ctl |= DPFC_CTL_FENCE_EN | dev_priv->cfb_fence;
>  		I915_WRITE(DPFC_CHICKEN, DPFC_HT_MODIFY);
