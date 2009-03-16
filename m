Return-Path: <linux-kernel-owner+w=401wt.eu-S1753692AbZCPDRe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753692AbZCPDRe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Mar 2009 23:17:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755926AbZCPDRW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Mar 2009 23:17:22 -0400
Received: from outbound.icp-qv1-irony-out4.iinet.net.au ([203.59.1.150]:27446
	"EHLO outbound.icp-qv1-irony-out4.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755894AbZCPDRV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Mar 2009 23:17:21 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAIphvUl8qWbQ/2dsb2JhbADQQYN/Bg
X-IronPort-AV: E=Sophos;i="4.38,370,1233500400"; 
   d="scan'208";a="325654768"
From: Ian Kent <raven@themaw.net>
Subject: [PATCH 2/2] autofs4 - fix kernel includes
To: Andrew Morton <akpm@linux-foundation.org>
Cc: autofs mailing list <autofs@linux.kernel.org>,
       Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>
Date: Mon, 16 Mar 2009 12:17:17 +0900
Message-ID: <20090316031717.26901.79534.stgit@zeus.themaw.net>
In-Reply-To: <20090316031712.26901.52109.stgit@zeus.themaw.net>
References: <20090316031712.26901.52109.stgit@zeus.themaw.net>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

autofs_dev-ioctl.h is included by both the kernel module and user
space tools and it includes two kernel header files. Compiles
work if the kernel headers are installed but fail otherwise.

Signed-off-by: Ian Kent <raven@themaw.net>
---

 include/linux/auto_dev-ioctl.h |    7 ++++++-
 include/linux/auto_fs.h        |    6 ++++--
 2 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/include/linux/auto_dev-ioctl.h b/include/linux/auto_dev-ioctl.h
index 91a7739..850f39b 100644
--- a/include/linux/auto_dev-ioctl.h
+++ b/include/linux/auto_dev-ioctl.h
@@ -10,8 +10,13 @@
 #ifndef _LINUX_AUTO_DEV_IOCTL_H
 #define _LINUX_AUTO_DEV_IOCTL_H
 
+#include <linux/auto_fs.h>
+
+#ifdef __KERNEL__
 #include <linux/string.h>
-#include <linux/types.h>
+#else
+#include <string.h>
+#endif /* __KERNEL__ */
 
 #define AUTOFS_DEVICE_NAME		"autofs"
 
diff --git a/include/linux/auto_fs.h b/include/linux/auto_fs.h
index c21e597..6326585 100644
--- a/include/linux/auto_fs.h
+++ b/include/linux/auto_fs.h
@@ -17,11 +17,13 @@
 #ifdef __KERNEL__
 #include <linux/fs.h>
 #include <linux/limits.h>
+#include <linux/types.h>
+#include <linux/ioctl.h>
+#else
 #include <asm/types.h>
+#include <sys/ioctl.h>
 #endif /* __KERNEL__ */
 
-#include <linux/ioctl.h>
-
 /* This file describes autofs v3 */
 #define AUTOFS_PROTO_VERSION	3
 

