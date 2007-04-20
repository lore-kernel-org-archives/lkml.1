Return-Path: <linux-kernel-owner+w=401wt.eu-S1767251AbXDTU7h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767251AbXDTU7h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 16:59:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767259AbXDTU7h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 16:59:37 -0400
Received: from mga03.intel.com ([143.182.124.21]:41724 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767251AbXDTU7g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 16:59:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,433,1170662400"; 
   d="scan'208"; a="216864582:sNHT19048722"
From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH] dev_dbg: check dev_dbg() arguments
To: greg@kroah.com
Cc: mochel@linux.intel.com, linux-kernel@vger.kernel.org
Date: Fri, 20 Apr 2007 13:59:35 -0700
Message-ID: <20070420205935.801.6015.stgit@dwillia2-linux.ch.intel.com>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Duplicate what Zach Brown did for pr_debug in commit
8b2a1fd1b394c60eaa2587716102dd5e9b4e5990

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---

 include/linux/device.h |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/include/linux/device.h b/include/linux/device.h
index 5cf30e9..b6825d0 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -554,7 +554,11 @@ extern const char *dev_driver_string(struct device *dev);
 #define dev_dbg(dev, format, arg...)		\
 	dev_printk(KERN_DEBUG , dev , format , ## arg)
 #else
-#define dev_dbg(dev, format, arg...) do { (void)(dev); } while (0)
+static inline int __attribute__ ((format (printf, 2, 3)))
+dev_dbg(struct device * dev, const char * fmt, ...)
+{
+	return 0;
+}
 #endif
 
 #define dev_err(dev, format, arg...)		\
