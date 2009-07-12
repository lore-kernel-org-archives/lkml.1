Return-Path: <linux-kernel-owner+w=401wt.eu-S1754743AbZGLWsN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754743AbZGLWsN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jul 2009 18:48:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754475AbZGLWqh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Jul 2009 18:46:37 -0400
Received: from kroah.org ([198.145.64.141]:33517 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754725AbZGLWqg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jul 2009 18:46:36 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Imre Deak <imre.deak@nokia.com>,
       Russell King <rmk+kernel@arm.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Tony Lindgren <tony@atomide.com>,
       Felipe Contreras <felipe.contreras@nokia.com>
Subject: [PATCH 8/9] omap: video: remove direct access of driver_data
Date: Sun, 12 Jul 2009 15:46:05 -0700
Message-Id: <1247438766-17266-8-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <20090712223717.GB16600@kroah.com>
References: <20090712223717.GB16600@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dev_set/get_drvdata() should be used instead, as driver_data is going
away.


Cc: Imre Deak <imre.deak@nokia.com>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Trilok Soni <soni.trilok@gmail.com>
Cc: Tony Lindgren <tony@atomide.com>
Cc: Felipe Contreras <felipe.contreras@nokia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/video/omap/omapfb_main.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/video/omap/omapfb_main.c b/drivers/video/omap/omapfb_main.c
index 4ea99bf..8862233 100644
--- a/drivers/video/omap/omapfb_main.c
+++ b/drivers/video/omap/omapfb_main.c
@@ -1254,7 +1254,7 @@ static struct fb_ops omapfb_ops = {
 static ssize_t omapfb_show_caps_num(struct device *dev,
 				    struct device_attribute *attr, char *buf)
 {
-	struct omapfb_device *fbdev = (struct omapfb_device *)dev->driver_data;
+	struct omapfb_device *fbdev = dev_get_drvdata(dev);
 	int plane;
 	size_t size;
 	struct omapfb_caps caps;
@@ -1274,7 +1274,7 @@ static ssize_t omapfb_show_caps_num(struct device *dev,
 static ssize_t omapfb_show_caps_text(struct device *dev,
 				     struct device_attribute *attr, char *buf)
 {
-	struct omapfb_device *fbdev = (struct omapfb_device *)dev->driver_data;
+	struct omapfb_device *fbdev = dev_get_drvdata(dev);
 	int i;
 	struct omapfb_caps caps;
 	int plane;
@@ -1321,7 +1321,7 @@ static DEVICE_ATTR(caps_text, 0444, omapfb_show_caps_text, NULL);
 static ssize_t omapfb_show_panel_name(struct device *dev,
 				      struct device_attribute *attr, char *buf)
 {
-	struct omapfb_device *fbdev = (struct omapfb_device *)dev->driver_data;
+	struct omapfb_device *fbdev = dev_get_drvdata(dev);
 
 	return snprintf(buf, PAGE_SIZE, "%s\n", fbdev->panel->name);
 }
@@ -1330,7 +1330,7 @@ static ssize_t omapfb_show_bklight_level(struct device *dev,
 					 struct device_attribute *attr,
 					 char *buf)
 {
-	struct omapfb_device *fbdev = (struct omapfb_device *)dev->driver_data;
+	struct omapfb_device *fbdev = dev_get_drvdata(dev);
 	int r;
 
 	if (fbdev->panel->get_bklight_level) {
@@ -1345,7 +1345,7 @@ static ssize_t omapfb_store_bklight_level(struct device *dev,
 					  struct device_attribute *attr,
 					  const char *buf, size_t size)
 {
-	struct omapfb_device *fbdev = (struct omapfb_device *)dev->driver_data;
+	struct omapfb_device *fbdev = dev_get_drvdata(dev);
 	int r;
 
 	if (fbdev->panel->set_bklight_level) {
@@ -1364,7 +1364,7 @@ static ssize_t omapfb_store_bklight_level(struct device *dev,
 static ssize_t omapfb_show_bklight_max(struct device *dev,
 				       struct device_attribute *attr, char *buf)
 {
-	struct omapfb_device *fbdev = (struct omapfb_device *)dev->driver_data;
+	struct omapfb_device *fbdev = dev_get_drvdata(dev);
 	int r;
 
 	if (fbdev->panel->get_bklight_level) {
@@ -1397,7 +1397,7 @@ static struct attribute_group panel_attr_grp = {
 static ssize_t omapfb_show_ctrl_name(struct device *dev,
 				     struct device_attribute *attr, char *buf)
 {
-	struct omapfb_device *fbdev = (struct omapfb_device *)dev->driver_data;
+	struct omapfb_device *fbdev = dev_get_drvdata(dev);
 
 	return snprintf(buf, PAGE_SIZE, "%s\n", fbdev->ctrl->name);
 }
-- 
1.6.3.2

