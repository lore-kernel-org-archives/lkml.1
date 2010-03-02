Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758121Ab0CBXx1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 18:53:27 -0500
Received: from kroah.org ([198.145.64.141]:38640 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754339Ab0CBX3e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 18:29:34 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
       Hans Verkuil <hverkuil@xs4all.nl>,
       Mauro Carvalho Chehab <mchehab@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 35/62] media: move omap24xxcam's probe function to .devinit.text
Date: Tue,  2 Mar 2010 15:28:34 -0800
Message-Id: <1267572541-410-35-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <20100302230933.GA32287@kroah.com>
References: <20100302230933.GA32287@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

A pointer to omap24xxcam_probe is passed to the core via
platform_driver_register and so the function must not disappear when the
.init sections are discarded.  Otherwise (if also having HOTPLUG=y)
unbinding and binding a device to the driver via sysfs will result in an
oops as does a device being registered late.

An alternative to this patch is using platform_driver_probe instead of
platform_driver_register plus removing the pointer to the probe function
from the struct platform_driver.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Acked-by: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
Acked-by: Trilok Soni <soni.trilok@gmail.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/media/video/omap24xxcam.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/omap24xxcam.c b/drivers/media/video/omap24xxcam.c
index 7400eac..142c327 100644
--- a/drivers/media/video/omap24xxcam.c
+++ b/drivers/media/video/omap24xxcam.c
@@ -1735,7 +1735,7 @@ static struct v4l2_int_device omap24xxcam = {
  *
  */
 
-static int __init omap24xxcam_probe(struct platform_device *pdev)
+static int __devinit omap24xxcam_probe(struct platform_device *pdev)
 {
 	struct omap24xxcam_device *cam;
 	struct resource *mem;
-- 
1.7.0.1

