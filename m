Return-Path: <linux-kernel-owner+w=401wt.eu-S1755044AbYC1UJ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755044AbYC1UJ0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 16:09:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754587AbYC1UIk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 16:08:40 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:1324 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753787AbYC1UIj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 16:08:39 -0400
Date: Fri, 28 Mar 2008 15:40:04 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Jesse Barnes <jesse.barnes@intel.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Dave Airlie <airlied@linux.ie>
Subject: Re: [PATCH] don't suspend/resume 8xx chips
Message-ID: <20080328144003.GF4404@ucw.cz>
References: <200803261628.12336.jesse.barnes@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200803261628.12336.jesse.barnes@intel.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2008-03-26 16:28:12, Jesse Barnes wrote:
> Recent testing has turned up some bugs in the new Intel suspend/resume code 
> for old, 8xx chipsets.  So for 2.6.25 it probably makes sense to apply this 
> patch, which should prevent the new code from getting called on those 
> chipsets.  We should have this fixed soon, but not in time for 2.6.25 
> unfortunately.  Note that this patch (along with the suspend/resume code in 
> general) could use more testing.
> 
> Signed-off-by:  Jesse Barnes <jesse.barnes@intel.com>
> 
> diff --git a/drivers/char/drm/i915_dma.c b/drivers/char/drm/i915_dma.c
> index e9d6663..6964a28 100644
> --- a/drivers/char/drm/i915_dma.c
> +++ b/drivers/char/drm/i915_dma.c
> @@ -762,6 +762,11 @@ int i915_driver_load(struct drm_device *dev, unsigned 
> long
>         unsigned long base, size;
>         int ret = 0, mmio_bar = IS_I9XX(dev) ? 0 : 1;
> 
> +       if (!IS_I9XX(dev)) {
> +               dev->driver->suspend = NULL;
> +               dev->driver->resume = NULL;
> +       }
> +

Are you sure your driver needs no state saving?

Maybe register suspend that printks, returns error?
							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
