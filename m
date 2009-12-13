Return-Path: <linux-kernel-owner+w=401wt.eu-S1756071AbZLNASx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756071AbZLNASx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 19:18:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754882AbZLMX5o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 18:57:44 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:34718 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754873AbZLMX5m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 18:57:42 -0500
From: re.emese@gmail.com
To: linux-kernel@vger.kernel.org
Cc: Emese Revfy <re.emese@gmail.com>, benh@kernel.crashing.org,
       paulus@samba.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, vapier@gentoo.org, tomi.valkeinen@nokia.com
Subject: [PATCH 22/22] Constify struct backlight_ops for 2.6.32-git-053fe57ac v2
Date: Mon, 14 Dec 2009 00:59:14 +0100
Message-Id: <1a257c6833a7cfbc6cce13f5ca828164e1595796.1260662995.git.re.emese@gmail.com>
X-Mailer: git-send-email 1.6.5.3
In-Reply-To: <cover.1260662994.git.re.emese@gmail.com>
References: <cover.1260662994.git.re.emese@gmail.com>
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Emese Revfy <re.emese@gmail.com>


Signed-off-by: Emese Revfy <re.emese@gmail.com>
---
 drivers/macintosh/via-pmu-backlight.c     |    4 ++--
 drivers/video/aty/atyfb_base.c            |    2 +-
 drivers/video/bf54x-lq043fb.c             |    2 +-
 drivers/video/bfin-t350mcqb-fb.c          |    2 +-
 drivers/video/omap2/displays/panel-taal.c |    2 +-
 5 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/macintosh/via-pmu-backlight.c b/drivers/macintosh/via-pmu-backlight.c
index a348bb0..ecd9b3f 100644
--- a/drivers/macintosh/via-pmu-backlight.c
+++ b/drivers/macintosh/via-pmu-backlight.c
@@ -15,7 +15,7 @@
 
 #define MAX_PMU_LEVEL 0xFF
 
-static struct backlight_ops pmu_backlight_data;
+static const struct backlight_ops pmu_backlight_data;
 static DEFINE_SPINLOCK(pmu_backlight_lock);
 static int sleeping, uses_pmu_bl;
 static u8 bl_curve[FB_BACKLIGHT_LEVELS];
@@ -115,7 +115,7 @@ static int pmu_backlight_get_brightness(struct backlight_device *bd)
 	return bd->props.brightness;
 }
 
-static struct backlight_ops pmu_backlight_data = {
+static const struct backlight_ops pmu_backlight_data = {
 	.get_brightness	= pmu_backlight_get_brightness,
 	.update_status	= pmu_backlight_update_status,
 
diff --git a/drivers/video/aty/atyfb_base.c b/drivers/video/aty/atyfb_base.c
index 1ddeb4c..fc4e221 100644
--- a/drivers/video/aty/atyfb_base.c
+++ b/drivers/video/aty/atyfb_base.c
@@ -2225,7 +2225,7 @@ static int aty_bl_get_brightness(struct backlight_device *bd)
 	return bd->props.brightness;
 }
 
-static struct backlight_ops aty_bl_data = {
+static const struct backlight_ops aty_bl_data = {
 	.get_brightness = aty_bl_get_brightness,
 	.update_status	= aty_bl_update_status,
 };
diff --git a/drivers/video/bf54x-lq043fb.c b/drivers/video/bf54x-lq043fb.c
index e49ae5e..db4e6f7 100644
--- a/drivers/video/bf54x-lq043fb.c
+++ b/drivers/video/bf54x-lq043fb.c
@@ -463,7 +463,7 @@ static int bl_get_brightness(struct backlight_device *bd)
 	return 0;
 }
 
-static struct backlight_ops bfin_lq043fb_bl_ops = {
+static const struct backlight_ops bfin_lq043fb_bl_ops = {
 	.get_brightness = bl_get_brightness,
 };
 
diff --git a/drivers/video/bfin-t350mcqb-fb.c b/drivers/video/bfin-t350mcqb-fb.c
index 5cc36cf..4e06416 100644
--- a/drivers/video/bfin-t350mcqb-fb.c
+++ b/drivers/video/bfin-t350mcqb-fb.c
@@ -381,7 +381,7 @@ static int bl_get_brightness(struct backlight_device *bd)
 	return 0;
 }
 
-static struct backlight_ops bfin_lq043fb_bl_ops = {
+static const struct backlight_ops bfin_lq043fb_bl_ops = {
 	.get_brightness = bl_get_brightness,
 };
 
diff --git a/drivers/video/omap2/displays/panel-taal.c b/drivers/video/omap2/displays/panel-taal.c
index 1f01dfc..a5f7f82 100644
--- a/drivers/video/omap2/displays/panel-taal.c
+++ b/drivers/video/omap2/displays/panel-taal.c
@@ -313,7 +313,7 @@ static int taal_bl_get_intensity(struct backlight_device *dev)
 	return 0;
 }
 
-static struct backlight_ops taal_bl_ops = {
+static const struct backlight_ops taal_bl_ops = {
 	.get_brightness = taal_bl_get_intensity,
 	.update_status  = taal_bl_update_status,
 };
-- 
1.6.5.3

