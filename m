Return-Path: <linux-kernel-owner+w=401wt.eu-S1751518AbYITEIx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751518AbYITEIx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2008 00:08:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750744AbYITEIo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Sep 2008 00:08:44 -0400
Received: from casper.infradead.org ([85.118.1.10]:37299 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750740AbYITEIo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2008 00:08:44 -0400
Date: Fri, 19 Sep 2008 21:07:33 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, greg@kroah.com
Subject: [PATCH] debug: Introduce a dev_WARN() function
Message-ID: <20080919210733.4e9c58e8@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Arjan van de Ven <arjan@linux.intel.com>
Date: Fri, 19 Sep 2008 21:03:06 -0700
Subject: [PATCH] debug: Introduce a dev_WARN() function

in the line of dev_printk(), this patch introduces a dev_WARN() macro,
that takes a struct device and then a printk format/args set of arguments.
Unlike dev_printk(), the effect is that of WARN() in that a full warning
message (including filename/line, module list, versions and a backtrace)
is printed in addition to the device name and the arguments.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
---
 include/linux/device.h |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/include/linux/device.h b/include/linux/device.h
index 4d8372d..2f9cdfa 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -539,6 +539,9 @@ extern const char *dev_driver_string(const struct device *dev);
 #define dev_info(dev, format, arg...)		\
 	dev_printk(KERN_INFO , dev , format , ## arg)
 
+#define dev_WARN(dev, format, arg...) \
+	WARN(1, "Device: %s\n" format, dev_driver_string(dev), ## arg)
+
 #ifdef DEBUG
 #define dev_dbg(dev, format, arg...)		\
 	dev_printk(KERN_DEBUG , dev , format , ## arg)
-- 
1.5.5.1


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
