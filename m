Return-Path: <linux-kernel-owner+w=401wt.eu-S1754529AbYDTDWq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754529AbYDTDWq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2008 23:22:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750797AbYDTDWh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Apr 2008 23:22:37 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:42209 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750761AbYDTDWg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2008 23:22:36 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH] linux/atm_tcp.h: cleanup for userspace
Date: Sat, 19 Apr 2008 23:22:34 -0400
Message-Id: <1208661754-3197-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.5.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The atm_tcp.h uses types from linux/atm.h, but does not include it.  It
should also use the standard __u## types from linux/types.h rather than the
uint##_t types since the former can be found with the kernel already.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 include/linux/atm_tcp.h |   10 ++++------
 1 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/include/linux/atm_tcp.h b/include/linux/atm_tcp.h
index 18787f9..f05014e 100644
--- a/include/linux/atm_tcp.h
+++ b/include/linux/atm_tcp.h
@@ -8,10 +8,8 @@
 #define LINUX_ATM_TCP_H
 
 #include <linux/atmapi.h>
-
-#ifdef __KERNEL__
 #include <linux/types.h>
-#endif
+#include <linux/atm.h>
 #include <linux/atmioc.h>
 
 
@@ -20,9 +18,9 @@
  */
 
 struct atmtcp_hdr {
-	uint16_t	vpi;
-	uint16_t	vci;
-	uint32_t	length;		/* ... of data part */
+	__u16	vpi;
+	__u16	vci;
+	__u32	length;		/* ... of data part */
 };
 
 /*
-- 
1.5.5

