Return-Path: <linux-kernel-owner+w=401wt.eu-S1754281Ab0AHXpV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754281Ab0AHXpV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 18:45:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752110Ab0AHXpU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 18:45:20 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:52903 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754140Ab0AHXpT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 18:45:19 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Eric Anholt <eric@anholt.net>
Subject: [PATCH] DRM / i915: Fix resume regression on MSI Wind U100 w/o KMS
Date: Sat, 9 Jan 2010 00:45:33 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.33-rc3-rjw; KDE/4.3.3; x86_64; ; )
Cc: Zhenyu Wang <zhenyuw@linux.intel.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       dri-devel@lists.sourceforge.net
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201001090045.33784.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Commit cbda12d77ea590082edb6d30bd342a67ebc459e0 (drm/i915: implement
new pm ops for i915), among other things, removed the .suspend and
.resume pointers from the struct drm_driver object in i915_drv.c,
which broke resume without KMS on my MSI Wind U100.

Fix this by reverting that part of commit cbda12d77ea59.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/gpu/drm/i915/i915_drv.c |   53 ++++------------------------------------
 1 file changed, 6 insertions(+), 47 deletions(-)

Index: linux-2.6/drivers/gpu/drm/i915/i915_drv.c
===================================================================
--- linux-2.6.orig/drivers/gpu/drm/i915/i915_drv.c
+++ linux-2.6/drivers/gpu/drm/i915/i915_drv.c
@@ -464,6 +418,8 @@ static struct drm_driver driver = {
 	.lastclose = i915_driver_lastclose,
 	.preclose = i915_driver_preclose,
 	.postclose = i915_driver_postclose,
+	.suspend = i915_suspend,
+	.resume = i915_resume,
 	.device_is_agp = i915_driver_device_is_agp,
 	.enable_vblank = i915_enable_vblank,
 	.disable_vblank = i915_disable_vblank,
