Return-Path: <linux-kernel-owner+w=401wt.eu-S1760158AbYAKGZr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760158AbYAKGZr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 01:25:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759479AbYAKGZG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 01:25:06 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:40037 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759252AbYAKGZE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 01:25:04 -0500
Date: Fri, 11 Jan 2008 17:24:53 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: mochel@osdl.org
Cc: greg@kroah.com, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] constify the name passed to platform_device_register_simple
Message-Id: <20080111172453.81644f8d.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This name is just passed to platform_device_alloc which has its parameter
declared const.

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/base/platform.c         |    2 +-
 include/linux/platform_device.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/base/platform.c b/drivers/base/platform.c
index fb56092..3408699 100644
--- a/drivers/base/platform.c
+++ b/drivers/base/platform.c
@@ -360,7 +360,7 @@ EXPORT_SYMBOL_GPL(platform_device_unregister);
  *	the Linux driver model.  In particular, when such drivers are built
  *	as modules, they can't be "hotplugged".
  */
-struct platform_device *platform_device_register_simple(char *name, int id,
+struct platform_device *platform_device_register_simple(const char *name, int id,
 							struct resource *res, unsigned int num)
 {
 	struct platform_device *pdev;
diff --git a/include/linux/platform_device.h b/include/linux/platform_device.h
index e808043..3261681 100644
--- a/include/linux/platform_device.h
+++ b/include/linux/platform_device.h
@@ -35,7 +35,7 @@ extern struct resource *platform_get_resource_byname(struct platform_device *, u
 extern int platform_get_irq_byname(struct platform_device *, char *);
 extern int platform_add_devices(struct platform_device **, int);
 
-extern struct platform_device *platform_device_register_simple(char *, int id,
+extern struct platform_device *platform_device_register_simple(const char *, int id,
 					struct resource *, unsigned int);
 
 extern struct platform_device *platform_device_alloc(const char *name, int id);
-- 
1.5.3.8

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
