Return-Path: <linux-kernel-owner+w=401wt.eu-S1759206AbYJPR0p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759206AbYJPR0p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 13:26:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755371AbYJPROv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 13:14:51 -0400
Received: from kroah.org ([198.145.64.141]:47006 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756402AbYJPROt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 13:14:49 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Arjan van de Ven <arjan@linux.intel.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 31/46] debug: Introduce a dev_WARN() function
Date: Thu, 16 Oct 2008 10:10:32 -0700
Message-Id: <1224177047-11859-31-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <20081016170954.GA11824@kroah.com>
References: <20081016170954.GA11824@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arjan van de Ven <arjan@linux.intel.com>

in the line of dev_printk(), this patch introduces a dev_WARN() function,
that takes a struct device and then a printk format/args set of arguments.
Unlike dev_printk(), the effect is that of WARN() in that a full warning
message (including filename/line, module list, versions and a backtrace)
is printed in addition to the device name and the arguments.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 include/linux/device.h |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/include/linux/device.h b/include/linux/device.h
index fb03446..ec90e79 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -570,6 +570,14 @@ extern const char *dev_driver_string(const struct device *dev);
 	({ if (0) dev_printk(KERN_DEBUG, dev, format, ##arg); 0; })
 #endif
 
+/*
+ * dev_WARN() acts like dev_printk(), but with the key difference
+ * of using a WARN/WARN_ON to get the message out, including the
+ * file/line information and a backtrace.
+ */
+#define dev_WARN(dev, format, arg...) \
+	WARN(1, "Device: %s\n" format, dev_driver_string(dev), ## arg);
+
 /* Create alias, so I can be autoloaded. */
 #define MODULE_ALIAS_CHARDEV(major,minor) \
 	MODULE_ALIAS("char-major-" __stringify(major) "-" __stringify(minor))
-- 
1.6.0.2

