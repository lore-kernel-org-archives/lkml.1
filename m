Return-Path: <linux-kernel-owner+w=401wt.eu-S1760458AbZFIKXZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760458AbZFIKXZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 06:23:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760279AbZFIKS5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 06:18:57 -0400
Received: from kroah.org ([198.145.64.141]:54670 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758845AbZFIKSz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 06:18:55 -0400
X-Mailbox-Line: From greg@blue.kroah.org Tue Jun  9 02:40:58 2009
Message-Id: <20090609094058.773848825@blue.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 09 Jun 2009 02:39:17 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Dave Airlie <airlied@redhat.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 29/87] drm/r128: fix r128 ioremaps to use ioremap_wc.
References: <20090609093848.204935043@blue.kroah.org>
Content-Disposition: inline; filename=drm-r128-fix-r128-ioremaps-to-use-ioremap_wc.patch
In-Reply-To: <20090609094451.GA26439@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.29-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Dave Airlie <airlied@redhat.com>

commit 42beefc0093725ec0f8cea340cc54c36ccaceea0 upstream.

This should allow r128 to start working again since PAT changes.

taken from F-11 kernel.

Signed-off-by: Dave Airlie <airlied@redhat.com>
Cc: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/r128/r128_cce.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/r128/r128_cce.c
+++ b/drivers/gpu/drm/r128/r128_cce.c
@@ -511,9 +511,9 @@ static int r128_do_init_cce(struct drm_d
 
 #if __OS_HAS_AGP
 	if (!dev_priv->is_pci) {
-		drm_core_ioremap(dev_priv->cce_ring, dev);
-		drm_core_ioremap(dev_priv->ring_rptr, dev);
-		drm_core_ioremap(dev->agp_buffer_map, dev);
+		drm_core_ioremap_wc(dev_priv->cce_ring, dev);
+		drm_core_ioremap_wc(dev_priv->ring_rptr, dev);
+		drm_core_ioremap_wc(dev->agp_buffer_map, dev);
 		if (!dev_priv->cce_ring->handle ||
 		    !dev_priv->ring_rptr->handle ||
 		    !dev->agp_buffer_map->handle) {


