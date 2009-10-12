Return-Path: <linux-kernel-owner+w=401wt.eu-S932990AbZJLTGK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932990AbZJLTGK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 15:06:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757944AbZJLTGJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 15:06:09 -0400
Received: from outbound-mail-140.bluehost.com ([67.222.39.30]:59838 "HELO
	outbound-mail-140.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757914AbZJLTGI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 15:06:08 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=uPSryHx7AtQI8LCTUKcWI7DeR1sRZ+974FbScLKic25KczabfADcxslsTQw2V0S7d4mVOSyHPisvmsKo7gFMelVTKuKSHusxiLnNn1O4aw7ksM0WQYrJo/I/wncHRW2v;
Date: Mon, 12 Oct 2009 12:05:10 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "Carlos R. Mafra" <crmafra2@gmail.com>
Cc: Theodore Tso <tytso@mit.edu>, Eric Anholt <eric@anholt.net>,
       linux-kernel@vger.kernel.org, Keith Packard <keithp@keithp.com>
Subject: Re: 2.6.32 regression (bisected): Video tearing/glitching with T400
 laptops
Message-ID: <20091012120510.16bd1194@jbarnes-g45>
In-Reply-To: <20091012184651.GA4603@Pilar.aei.mpg.de>
References: <E1Mtqnb-0002x7-TJ@closure.thunk.org>
	<20091008103620.5e5aae66@jbarnes-g45>
	<20091010204106.GA8251@mit.edu>
	<20091012095438.1e82b54f@jbarnes-g45>
	<20091012184651.GA4603@Pilar.aei.mpg.de>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.17.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Oct 2009 20:46:51 +0200
"Carlos R. Mafra" <crmafra2@gmail.com> wrote:

> On Mon 12.Oct'09 at  9:54:38 -0700, Jesse Barnes wrote:
> > > 
> > > Nope, unfortunately, it's not helping on my T400 laptop.  I'm
> > > still getting huge amounts of glitching and tearing with this
> > > patch applied against -rc3.
> > > 
> > > What I'm using for now to fix up my system is this patch.
> > > 
> > 
> > How about this one?  I have one more idea to try out if this doesn't
> > work (hacking on it now).
> 
> I was also experiencing something very similar to Theodore's bug 
> report and, at least for me, the patch below fixed the issue (the
> previous one also had no effect).

Cool, good to hear.  Hopefully Ted and Keith will confirm too.

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
