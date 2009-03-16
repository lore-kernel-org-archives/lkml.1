Return-Path: <linux-kernel-owner+w=401wt.eu-S1759788AbZCPH3q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759788AbZCPH3q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 03:29:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757270AbZCPHXx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 03:23:53 -0400
Received: from vsmtp01.dti.ne.jp ([202.216.231.136]:35665 "EHLO
	vsmtp01.dti.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757168AbZCPHW6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 03:22:58 -0400
From: "J. R. Okajima" <hooanon05@yahoo.co.jp>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, "J. R. Okajima" <hooanon05@yahoo.co.jp>
Subject: [RFC Aufs2 #2 02/28] aufs public header file
Date: Mon, 16 Mar 2009 16:20:14 +0900
Message-Id: <1237188040-11404-3-git-send-email-hooanon05@yahoo.co.jp>
X-Mailer: git-send-email 1.6.1.284.g5dc13
In-Reply-To: <1237188040-11404-1-git-send-email-hooanon05@yahoo.co.jp>
References: <1237188040-11404-1-git-send-email-hooanon05@yahoo.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

initial commit
public header file

Signed-off-by: J. R. Okajima <hooanon05@yahoo.co.jp>
---
 include/linux/Kbuild      |    1 +
 include/linux/aufs_type.h |   98 +++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 99 insertions(+), 0 deletions(-)
 create mode 100644 include/linux/aufs_type.h

diff --git a/include/linux/Kbuild b/include/linux/Kbuild
index 106c3ba..d0c7262 100644
--- a/include/linux/Kbuild
+++ b/include/linux/Kbuild
@@ -34,6 +34,7 @@ header-y += atmppp.h
 header-y += atmsap.h
 header-y += atmsvc.h
 header-y += atm_zatm.h
+header-y += aufs_type.h
 header-y += auto_fs4.h
 header-y += ax25.h
 header-y += b1lli.h
diff --git a/include/linux/aufs_type.h b/include/linux/aufs_type.h
new file mode 100644
index 0000000..419c853
--- /dev/null
+++ b/include/linux/aufs_type.h
@@ -0,0 +1,98 @@
+/*
+ * Copyright (C) 2005-2009 Junjiro R. Okajima
+ *
+ * This program, aufs is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#ifndef __AUFS_TYPE_H__
+#define __AUFS_TYPE_H__
+
+#include <linux/ioctl.h>
+
+#define AUFS_VERSION	"2"
+
+/* todo? move this to linux-2.6.19/include/magic.h */
+#define AUFS_SUPER_MAGIC	('a' << 24 | 'u' << 16 | 'f' << 8 | 's')
+
+/* ---------------------------------------------------------------------- */
+
+#ifdef CONFIG_AUFS_BRANCH_MAX_127
+/* some environments treat 'char' as 'unsigned char' by default */
+typedef signed char aufs_bindex_t;
+#define AUFS_BRANCH_MAX 127
+#else
+typedef short aufs_bindex_t;
+#ifdef CONFIG_AUFS_BRANCH_MAX_511
+#define AUFS_BRANCH_MAX 511
+#elif defined(CONFIG_AUFS_BRANCH_MAX_1023)
+#define AUFS_BRANCH_MAX 1023
+#elif defined(CONFIG_AUFS_BRANCH_MAX_32767)
+#define AUFS_BRANCH_MAX 32767
+#endif
+#endif
+
+#ifdef __KERNEL__
+#ifndef AUFS_BRANCH_MAX
+#error unknown CONFIG_AUFS_BRANCH_MAX value
+#endif
+#endif /* __KERNEL__ */
+
+/* ---------------------------------------------------------------------- */
+
+#define AUFS_NAME		"aufs"
+#define AUFS_FSTYPE		AUFS_NAME
+
+#define AUFS_ROOT_INO		2
+#define AUFS_FIRST_INO		11
+
+#define AUFS_WH_PFX		".wh."
+#define AUFS_WH_PFX_LEN		((int)sizeof(AUFS_WH_PFX) - 1)
+#define AUFS_XINO_FNAME		"." AUFS_NAME ".xino"
+#define AUFS_XINO_DEFPATH	"/tmp/" AUFS_XINO_FNAME
+#define AUFS_XINO_TRUNC_INIT	64 /* blocks */
+#define AUFS_XINO_TRUNC_STEP	4  /* blocks */
+#define AUFS_DIRWH_DEF		3
+#define AUFS_RDCACHE_DEF	10 /* seconds */
+#define AUFS_WKQ_NAME		AUFS_NAME "d"
+#define AUFS_NWKQ_DEF		4
+#define AUFS_MFS_SECOND_DEF	30 /* seconds */
+#define AUFS_PLINK_WARN		100 /* number of plinks */
+
+#define AUFS_DIROPQ_NAME	AUFS_WH_PFX ".opq" /* whiteouted doubly */
+#define AUFS_WH_DIROPQ		AUFS_WH_PFX AUFS_DIROPQ_NAME
+
+#define AUFS_BASE_NAME		AUFS_WH_PFX AUFS_NAME
+#define AUFS_PLINKDIR_NAME	AUFS_WH_PFX "plnk"
+#define AUFS_ORPHDIR_NAME	AUFS_WH_PFX "orph"
+
+/* doubly whiteouted */
+#define AUFS_WH_BASE		AUFS_WH_PFX AUFS_BASE_NAME
+#define AUFS_WH_PLINKDIR	AUFS_WH_PFX AUFS_PLINKDIR_NAME
+#define AUFS_WH_ORPHDIR		AUFS_WH_PFX AUFS_ORPHDIR_NAME
+
+/* branch permission */
+#define AUFS_BRPERM_RW		"rw"
+#define AUFS_BRPERM_RO		"ro"
+#define AUFS_BRPERM_RR		"rr"
+#define AUFS_BRPERM_WH		"wh"
+#define AUFS_BRPERM_NLWH	"nolwh"
+#define AUFS_BRPERM_ROWH	AUFS_BRPERM_RO "+" AUFS_BRPERM_WH
+#define AUFS_BRPERM_RRWH	AUFS_BRPERM_RR "+" AUFS_BRPERM_WH
+#define AUFS_BRPERM_RWNLWH	AUFS_BRPERM_RW "+" AUFS_BRPERM_NLWH
+
+/* ---------------------------------------------------------------------- */
+
+/* ioctl */
+enum {
+	AuCtl_PLINK_MAINT,
+	AuCtl_PLINK_CLEAN
+};
+
+#define AuCtlType		'A'
+#define AUFS_CTL_PLINK_MAINT	_IO(AuCtlType, AuCtl_PLINK_MAINT)
+#define AUFS_CTL_PLINK_CLEAN	_IO(AuCtlType, AuCtl_PLINK_CLEAN)
+
+#endif /* __AUFS_TYPE_H__ */
-- 
1.6.1.284.g5dc13

