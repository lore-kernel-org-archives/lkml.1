Return-Path: <linux-kernel-owner+w=401wt.eu-S1753000AbZBCJ61@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753000AbZBCJ61 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 04:58:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751423AbZBCJ6T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 04:58:19 -0500
Received: from gir.skynet.ie ([193.1.99.77]:52343 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751358AbZBCJ6S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 04:58:18 -0500
Date: Tue, 3 Feb 2009 09:58:16 +0000 (GMT)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: Andrew Morton <akpm@linux-foundation.org>
cc: Daniel Vetter <daniel@ffwll.ch>, linux-kernel@vger.kernel.org,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, dri-devel@lists.sourceforge.net
Subject: Re: + drivers-gpu-drm-i915-intel_lvdsc-fix-locking-snafu.patch added
 to -mm tree
In-Reply-To: <20090202224448.b19eaca4.akpm@linux-foundation.org>
Message-ID: <alpine.DEB.2.00.0902030955420.31073@skynet.skynet.ie>
References: <200901292050.n0TKol5b015605@imap1.linux-foundation.org> <200901291324.17624.jbarnes@virtuousgeek.org> <20090129134825.620e3f84.akpm@linux-foundation.org> <20090131152508.GA4668@viiv.ffwll.ch> <20090202224448.b19eaca4.akpm@linux-foundation.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2 Feb 2009, Andrew Morton wrote:

> (cc's added)
> 
> On Sat, 31 Jan 2009 16:25:08 +0100 Daniel Vetter <daniel@ffwll.ch> wrote:
> 
> > On Thu, Jan 29, 2009 at 01:48:25PM -0800, Andrew Morton wrote:
> > > On Thu, 29 Jan 2009 13:24:17 -0800
> > > Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
> > > > On Thursday, January 29, 2009 12:50 pm akpm@linux-foundation.org wrote:
> 
> So I assume that it would make sense to track this as a post-2.6.28
> regression?
> 

>From ac048e1734699dd98f4bdf4daf2b9592d4a4d38e Mon Sep 17 00:00:00 2001
From: Dave Airlie <airlied@redhat.com>
Date: Tue, 3 Feb 2009 19:05:12 +1000
Subject: [PATCH] i915: fix unneeded locking in i915 LVDS get modes code.

This code is always called under the lock from the higher layers,
so need to go locking it here.

Signed-off-by: Dave Airlie <airlied@redhat.com>
---
 drivers/gpu/drm/i915/intel_lvds.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_lvds.c b/drivers/gpu/drm/i915/intel_lvds.c
index b36a521..cf8da64 100644
--- a/drivers/gpu/drm/i915/intel_lvds.c
+++ b/drivers/gpu/drm/i915/intel_lvds.c
@@ -311,10 +311,8 @@ static int intel_lvds_get_modes(struct drm_connector *connector)
 	if (dev_priv->panel_fixed_mode != NULL) {
 		struct drm_display_mode *mode;
 
-		mutex_lock(&dev->mode_config.mutex);
 		mode = drm_mode_duplicate(dev, dev_priv->panel_fixed_mode);
 		drm_mode_probed_add(connector, mode);
-		mutex_unlock(&dev->mode_config.mutex);
 
 		return 1;
 	}
-- 
1.6.0.6

