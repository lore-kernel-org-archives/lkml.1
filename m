Return-Path: <linux-kernel-owner+w=401wt.eu-S1764317AbYAYID0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764317AbYAYID0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 03:03:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756314AbYAYH7l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 02:59:41 -0500
Received: from mail.suse.de ([195.135.220.2]:59321 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760678AbYAYH7k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 02:59:40 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 184/196] Driver Core: constify the name passed to platform_device_register_simple
Date: Thu, 24 Jan 2008 23:33:33 -0800
Message-Id: <1201246425-5058-105-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <20080125071127.GA4860@kroah.com>
References: <20080125071127.GA4860@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>

This name is just passed to platform_device_alloc which has its parameter
declared const.

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/platform.c         |    2 +-
 include/linux/platform_device.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/base/platform.c b/drivers/base/platform.c
index bdd59e8..48d5db4 100644
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

