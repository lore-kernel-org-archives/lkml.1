Return-Path: <linux-kernel-owner+w=401wt.eu-S1758854AbYEWPlL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758854AbYEWPlL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 11:41:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756221AbYEWPkt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 11:40:49 -0400
Received: from outbound-mail-28.bluehost.com ([69.89.17.198]:45422 "HELO
	outbound-mail-28.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756084AbYEWPks (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 11:40:48 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Dave Airlie <airlied@linux.ie>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] remove debug printk from DRM suspend path
Date: Fri, 23 May 2008 08:40:45 -0700
User-Agent: KMail/1.9.9
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805230840.46015.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
DomainKey-Status: no signature
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not sure how this snuck upstream, but it really doesn't belong there.  We
don't need a KERN_ERR printk in the suspend path to know what's going on (at
least not anymore).

Signed-off-by:  Jesse Barnes <jbarnes@virtuousgeek.org>

diff --git a/drivers/char/drm/drm_sysfs.c b/drivers/char/drm/drm_sysfs.c
index 9a32169..af211a0 100644
--- a/drivers/char/drm/drm_sysfs.c
+++ b/drivers/char/drm/drm_sysfs.c
@@ -34,8 +34,6 @@ static int drm_sysfs_suspend(struct device *dev, pm_message_t state)
 	struct drm_minor *drm_minor = to_drm_minor(dev);
 	struct drm_device *drm_dev = drm_minor->dev;
 
-	printk(KERN_ERR "%s\n", __func__);
-
 	if (drm_dev->driver->suspend)
 		return drm_dev->driver->suspend(drm_dev, state);
 
