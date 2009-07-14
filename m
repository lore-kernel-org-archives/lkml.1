Return-Path: <linux-kernel-owner+w=401wt.eu-S1756663AbZGNW3E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756663AbZGNW3E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 18:29:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756520AbZGNW3D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 18:29:03 -0400
Received: from aun.it.uu.se ([130.238.12.36]:59547 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754355AbZGNW3C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 18:29:02 -0400
Date: Wed, 15 Jul 2009 00:28:43 +0200 (MEST)
Message-Id: <200907142228.n6EMSh1C001441@pilspetsen.it.uu.se>
From: Mikael Pettersson <mikpe@it.uu.se>
To: airlied@linux.ie
Subject: [PATCH] DRM_RADEON should not select FB stuff
Cc: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 771fe6b912fca54f03e8a72eb63058b582775362 changed the DRM_RADEON
Kconfig entry to select a bunch of framebuffer options. However, the
driver doesn't actually use any of those things, so these selects are
bogus. This patch reverts them.

I'm running this right now. drm and radeon loaded, acceleration works,
nothing anywhere is complaining about missing the FB stuff.

Signed-off-by: Mikael Pettersson <mikpe@it.uu.se>

diff -rupN linux-2.6.31-rc3/drivers/gpu/drm/Kconfig linux-2.6.31-rc3.radeon-dont-select-fb-dammit/drivers/gpu/drm/Kconfig
--- linux-2.6.31-rc3/drivers/gpu/drm/Kconfig	2009-07-14 13:42:51.000000000 +0200
+++ linux-2.6.31-rc3.radeon-dont-select-fb-dammit/drivers/gpu/drm/Kconfig	2009-07-14 14:03:03.000000000 +0200
@@ -44,11 +44,6 @@ config DRM_R128
 config DRM_RADEON
 	tristate "ATI Radeon"
 	depends on DRM && PCI
-	select FB_CFB_FILLRECT
-	select FB_CFB_COPYAREA
-	select FB_CFB_IMAGEBLIT
-	select FB
-	select FRAMEBUFFER_CONSOLE if !EMBEDDED
 	help
 	  Choose this option if you have an ATI Radeon graphics card.  There
 	  are both PCI and AGP versions.  You don't need to choose this to
