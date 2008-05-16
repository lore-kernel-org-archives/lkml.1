Return-Path: <linux-kernel-owner+w=401wt.eu-S1764052AbYEPPAk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764052AbYEPPAk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 11:00:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758568AbYEPOoY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 10:44:24 -0400
Received: from vsmtp02.dti.ne.jp ([202.216.231.137]:49292 "EHLO
	vsmtp02.dti.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754375AbYEPOmW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 10:42:22 -0400
From: hooanon05@yahoo.co.jp
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Junjiro Okajima <hooanon05@yahoo.co.jp>
Subject: [PATCH 3/67] aufs global header file
Date: Fri, 16 May 2008 23:32:17 +0900
Message-Id: <12109484012997-git-send-email-hooanon05@yahoo.co.jp>
X-Mailer: git-send-email 1.4.4.4
In-Reply-To: <12109484012532-git-send-email-hooanon05@yahoo.co.jp>
References: <12109484013324-git-send-email-hooanon05@yahoo.co.jp> <12109484012532-git-send-email-hooanon05@yahoo.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Junjiro Okajima <hooanon05@yahoo.co.jp>

	initial commit
	aufs global header file

Signed-off-by: Junjiro Okajima <hooanon05@yahoo.co.jp>
---
 include/linux/aufs_type.h |  111 +++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 111 insertions(+), 0 deletions(-)

diff --git a/include/linux/aufs_type.h b/include/linux/aufs_type.h
new file mode 100644
index 0000000..1f56ec9
--- /dev/null
+++ b/include/linux/aufs_type.h
@@ -0,0 +1,111 @@
+/*
+ * Copyright (C) 2005, 2006, 2007, 2008 Junjiro Okajima
+ *
+ * This program, aufs is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+
+/* $Id: aufs_type.h,v 1.106 2008/05/12 00:29:11 sfjro Exp $ */
+
+#include <linux/ioctl.h>
+
+#ifndef __AUFS_TYPE_H__
+#define __AUFS_TYPE_H__
+
+#define AUFS_VERSION	"20080516-mm"
+
+/* move this to linux-2.6.19/include/magic.h */
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
+#else
+#error unknown CONFIG_AUFS_BRANCH_MAX value
+#endif
+#endif
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
+#ifdef CONFIG_AUFS_COMPAT
+#define AUFS_DIROPQ_NAME	"__dir_opaque"
+#else
+#define AUFS_DIROPQ_NAME	AUFS_WH_PFX ".opq" /* whiteouted doubly */
+#endif
+#define AUFS_WH_DIROPQ		AUFS_WH_PFX AUFS_DIROPQ_NAME
+
+/* will be whiteouted doubly */
+#define AUFS_WH_BASENAME	AUFS_WH_PFX AUFS_NAME
+#define AUFS_WH_PLINKDIR	AUFS_WH_PFX "plink"
+
+/* ---------------------------------------------------------------------- */
+
+/* ioctl */
+enum {
+	AuCtlErr,
+	AuCtlErr_Last
+};
+enum {
+	AuCtl_REFRESH, //AuCtl_REFRESHV,
+	//AuCtl_FLUSH_PLINK,
+	//AuCtl_CPUP,
+	AuCtl_CPDOWN, AuCtl_MVDOWN,
+	//AuCtl_DIROPQ
+};
+
+struct aufs_ctl_cp {
+	int bsrc, bdst;
+	int err;
+};
+
+#define AuCtlType		'A'
+#define AUFS_CTL_REFRESH	_IO(AuCtlType, AuCtl_REFRESH)
+//#define AUFS_CTL_REFRESHV	_IO(AuCtlType, AuCtl_REFRESHV)
+//#define AUFS_CTL_FLUSH_PLINK	_IOR(AuCtlType, AuCtl_FLUSH_PLINK)
+//#define AUFS_CTL_CPUP		_IOWR(AuCtlType, AuCtl_CPUP, struct aufs_ctl_cp)
+#define AUFS_CTL_CPDOWN \
+	_IOWR(AuCtlType, AuCtl_CPDOWN, struct aufs_ctl_cp)
+#define AUFS_CTL_MVDOWN \
+	_IOWR(AuCtlType, AuCtl_MVDOWN, struct aufs_ctl_cp)
+//#define AUFS_CTL_DIROPQ		_IO(AuCtlType, AuCtl_DIROPQ)
+
+#endif /* __AUFS_TYPE_H__ */
-- 
1.4.4.4

