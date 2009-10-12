Return-Path: <linux-kernel-owner+w=401wt.eu-S932863AbZJLQzj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932863AbZJLQzj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 12:55:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932622AbZJLQzj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 12:55:39 -0400
Received: from outbound-mail-305.bluehost.com ([67.222.53.251]:45530 "HELO
	outbound-mail-305.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932613AbZJLQzi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 12:55:38 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=WyGYEEqbxi3IDJMMnOuYYmNysTga2mxfyR/u3GQH16fLdVJF4RNQxglI/KKxdP68OjAJ9YtB3x21XILhi3+tSCfDv8mSAxaDBr1ukX7uT/X30I0UAwHKAiL0uEXwg/p1;
Date: Mon, 12 Oct 2009 09:54:38 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Theodore Tso <tytso@mit.edu>
Cc: Eric Anholt <eric@anholt.net>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.32 regression (bisected): Video tearing/glitching with T400
 laptops
Message-ID: <20091012095438.1e82b54f@jbarnes-g45>
In-Reply-To: <20091010204106.GA8251@mit.edu>
References: <E1Mtqnb-0002x7-TJ@closure.thunk.org>
	<20091008103620.5e5aae66@jbarnes-g45>
	<20091010204106.GA8251@mit.edu>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.17.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 10 Oct 2009 16:41:06 -0400
Theodore Tso <tytso@mit.edu> wrote:

> On Thu, Oct 08, 2009 at 10:36:20AM -0700, Jesse Barnes wrote:
> > On Fri, 02 Oct 2009 18:40:27 -0400
> > "Theodore Ts'o" <tytso@mit.edu> wrote:
> > 
> > > Hi, 
> > > 
> > > In recent kernels, my X display (running with a KMS-enabled X
> > > server) has been very jittery and with lots of glitching and
> > > tearing --- sorry if this isn't the correct technical term, not
> > > sure what it is --- on my T400 Lenovo laptop.   It seems related
> > > to what is on the desktop, and moving the mouse does seem to
> > > affect the rate and percentage of the screen which jitters ---
> > > which is enough to be very distracting, although I can still read
> > > the contents of the windows where the screen is
> > > tearing/glitching/flashing.
> > > 
> > > I bisected it down to this commit:
> > 
> > Can you give this patch a try?  It seems to work for Keith at least,
> > and it sounds like he was seeing the same problem.
> 
> Nope, unfortunately, it's not helping on my T400 laptop.  I'm still
> getting huge amounts of glitching and tearing with this patch applied
> against -rc3.
> 
> What I'm using for now to fix up my system is this patch.
> 

How about this one?  I have one more idea to try out if this doesn't
work (hacking on it now).

Thanks,
-- 
Jesse Barnes, Intel Open Source Technology Center


diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
index 7a5fb79..1451945 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -1047,7 +1047,7 @@ static void g4x_enable_fbc(struct drm_crtc *crtc, unsigned long interval)
 	dev_priv->cfb_fence = obj_priv->fence_reg;
 	dev_priv->cfb_plane = intel_crtc->plane;
 
-	dpfc_ctl = plane | DPFC_SR_EN | DPFC_CTL_LIMIT_1X;
+	dpfc_ctl = plane | DPFC_CTL_LIMIT_1X;
 	if (obj_priv->tiling_mode != I915_TILING_NONE) {
 		dpfc_ctl |= DPFC_CTL_FENCE_EN | dev_priv->cfb_fence;
 		I915_WRITE(DPFC_CHICKEN, DPFC_HT_MODIFY);
