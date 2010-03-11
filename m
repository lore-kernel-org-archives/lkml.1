Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933397Ab0CKRcV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 12:32:21 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:35735 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932710Ab0CKRcR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 12:32:17 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: [PATCH 3/3] of: protect contents of of_platform.h and of_device.h
To: devicetree-discuss@lists.ozlabs.org, benh@kernel.crashing.org,
       davem@davemloft.net, jeremy.kerr@canonical.com, monstr@monstr.eu
Cc: linux-kernel@vger.kernel.org
Date: Thu, 11 Mar 2010 10:32:09 -0700
Message-ID: <20100311173209.4423.22665.stgit@angua>
In-Reply-To: <20100311173024.4423.53178.stgit@angua>
References: <20100311173024.4423.53178.stgit@angua>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Only process contents of of_platform.h and of_device.h if
CONFIG_OF_DEVICE is set.
---

 include/linux/of_device.h   |    2 ++
 include/linux/of_platform.h |    2 ++
 2 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/include/linux/of_device.h b/include/linux/of_device.h
index d3a74e0..e7904a9 100644
--- a/include/linux/of_device.h
+++ b/include/linux/of_device.h
@@ -1,6 +1,7 @@
 #ifndef _LINUX_OF_DEVICE_H
 #define _LINUX_OF_DEVICE_H
 
+#ifdef CONFIG_OF_DEVICE
 #include <linux/device.h>
 #include <linux/of.h>
 #include <linux/mod_devicetable.h>
@@ -26,5 +27,6 @@ static inline void of_device_free(struct of_device *dev)
 
 extern ssize_t of_device_get_modalias(struct of_device *ofdev,
 					char *str, ssize_t len);
+#endif /* CONFIG_OF_DEVICE */
 
 #endif /* _LINUX_OF_DEVICE_H */
diff --git a/include/linux/of_platform.h b/include/linux/of_platform.h
index 9084066..ac3ae07 100644
--- a/include/linux/of_platform.h
+++ b/include/linux/of_platform.h
@@ -11,6 +11,7 @@
  *
  */
 
+#ifdef CONFIG_OF_DEVICE
 #include <linux/module.h>
 #include <linux/device.h>
 #include <linux/mod_devicetable.h>
@@ -66,5 +67,6 @@ static inline void of_unregister_platform_driver(struct of_platform_driver *drv)
 extern struct of_device *of_find_device_by_node(struct device_node *np);
 
 extern int of_bus_type_init(struct bus_type *bus, const char *name);
+#endif /* CONFIG_OF_DEVICE */
 
 #endif	/* _LINUX_OF_PLATFORM_H */

