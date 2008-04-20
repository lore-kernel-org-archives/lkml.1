Return-Path: <linux-kernel-owner+w=401wt.eu-S1753859AbYDTD37@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753859AbYDTD37 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2008 23:29:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751192AbYDTD3w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Apr 2008 23:29:52 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:51591 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751162AbYDTD3w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2008 23:29:52 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH] linux/{dlm,dlm_device}.h: cleanup for userspace
Date: Sat, 19 Apr 2008 23:29:50 -0400
Message-Id: <1208662190-3531-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.5.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

linux/dlm_device.h uses types from dlm.h and types.h, so pull them in.  The
dlm.h header should use __u## rather than uint##_t types and thus pull in
linux/types.h for it.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 include/linux/dlm.h        |    3 ++-
 include/linux/dlm_device.h |    7 +++++++
 2 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/include/linux/dlm.h b/include/linux/dlm.h
index c743fbc..ea301f0 100644
--- a/include/linux/dlm.h
+++ b/include/linux/dlm.h
@@ -21,6 +21,7 @@
 
 /* Lock levels and flags are here */
 #include <linux/dlmconstants.h>
+#include <linux/types.h>
 
 
 #define DLM_RESNAME_MAXLEN	64
@@ -63,7 +64,7 @@ typedef void dlm_lockspace_t;
 
 struct dlm_lksb {
 	int 	 sb_status;
-	uint32_t sb_lkid;
+	__u32	 sb_lkid;
 	char 	 sb_flags;
 	char *	 sb_lvbptr;
 };
diff --git a/include/linux/dlm_device.h b/include/linux/dlm_device.h
index 9642277..9eb2ff4 100644
--- a/include/linux/dlm_device.h
+++ b/include/linux/dlm_device.h
@@ -11,10 +11,16 @@
 *******************************************************************************
 ******************************************************************************/
 
+#ifndef _LINUX_DLM_DEVICE_H
+#define _LINUX_DLM_DEVICE_H
+
 /* This is the device interface for dlm, most users will use a library
  * interface.
  */
 
+#include <linux/dlm.h>
+#include <linux/types.h>
+
 #define DLM_USER_LVB_LEN	32
 
 /* Version of the device interface */
@@ -101,3 +107,4 @@ struct dlm_lock_result {
 #define DLM_USER_LSFLG_AUTOFREE   1
 #define DLM_USER_LSFLG_FORCEFREE  2
 
+#endif
-- 
1.5.5

