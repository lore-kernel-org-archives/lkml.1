Return-Path: <linux-kernel-owner+w=401wt.eu-S1759530AbYF0Io6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759530AbYF0Io6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 04:44:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755877AbYF0Ios
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 04:44:48 -0400
Received: from ipmail04.adl2.internode.on.net ([203.16.214.57]:14888 "EHLO
	ipmail04.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755151AbYF0Ior (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 04:44:47 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEANexXkh5LFnm/2dsb2JhbACuPg
X-IronPort-AV: E=Sophos;i="4.27,714,1204464600"; 
   d="scan'208";a="144433133"
From: Dave Chinner <david@fromorbit.com>
To: xfs@oss.sgi.com
Cc: linux-kernel@vger.kernel.org, matthew@wil.cx, dwalker@mvista.com,
       Dave Chinner <david@fromorbit.com>
Subject: [PATCH 6/6] Remove the sema_t from XFS.
Date: Fri, 27 Jun 2008 18:44:44 +1000
Message-Id: <1214556284-4160-7-git-send-email-david@fromorbit.com>
X-Mailer: git-send-email 1.5.5.4
In-Reply-To: <1214556284-4160-1-git-send-email-david@fromorbit.com>
References: <1214556284-4160-1-git-send-email-david@fromorbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that all users of the sema_t are gone from XFS we
can finally kill it.

Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 fs/xfs/linux-2.6/sema.h      |   52 ------------------------------------------
 fs/xfs/linux-2.6/xfs_linux.h |    2 +-
 2 files changed, 1 insertions(+), 53 deletions(-)
 delete mode 100644 fs/xfs/linux-2.6/sema.h

diff --git a/fs/xfs/linux-2.6/sema.h b/fs/xfs/linux-2.6/sema.h
deleted file mode 100644
index 3abe7e9..0000000
--- a/fs/xfs/linux-2.6/sema.h
+++ /dev/null
@@ -1,52 +0,0 @@
-/*
- * Copyright (c) 2000-2002,2005 Silicon Graphics, Inc.
- * All Rights Reserved.
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it would be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write the Free Software Foundation,
- * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
- */
-#ifndef __XFS_SUPPORT_SEMA_H__
-#define __XFS_SUPPORT_SEMA_H__
-
-#include <linux/time.h>
-#include <linux/wait.h>
-#include <linux/semaphore.h>
-#include <asm/atomic.h>
-
-/*
- * sema_t structure just maps to struct semaphore in Linux kernel.
- */
-
-typedef struct semaphore sema_t;
-
-#define initnsema(sp, val, name)	sema_init(sp, val)
-#define psema(sp, b)			down(sp)
-#define vsema(sp)			up(sp)
-#define freesema(sema)			do { } while (0)
-
-static inline int issemalocked(sema_t *sp)
-{
-	return down_trylock(sp) || (up(sp), 0);
-}
-
-/*
- * Map cpsema (try to get the sema) to down_trylock. We need to switch
- * the return values since cpsema returns 1 (acquired) 0 (failed) and
- * down_trylock returns the reverse 0 (acquired) 1 (failed).
- */
-static inline int cpsema(sema_t *sp)
-{
-	return down_trylock(sp) ? 0 : 1;
-}
-
-#endif /* __XFS_SUPPORT_SEMA_H__ */
diff --git a/fs/xfs/linux-2.6/xfs_linux.h b/fs/xfs/linux-2.6/xfs_linux.h
index 4d45d93..4fb838f 100644
--- a/fs/xfs/linux-2.6/xfs_linux.h
+++ b/fs/xfs/linux-2.6/xfs_linux.h
@@ -45,13 +45,13 @@
 #include <mrlock.h>
 #include <sv.h>
 #include <mutex.h>
-#include <sema.h>
 #include <time.h>
 
 #include <support/ktrace.h>
 #include <support/debug.h>
 #include <support/uuid.h>
 
+#include <linux/semaphore.h>
 #include <linux/mm.h>
 #include <linux/kernel.h>
 #include <linux/blkdev.h>
-- 
1.5.5.4

