Return-Path: <linux-kernel-owner+w=401wt.eu-S1753118Ab0A3JxW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753118Ab0A3JxW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jan 2010 04:53:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752877Ab0A3JxW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jan 2010 04:53:22 -0500
Received: from mga01.intel.com ([192.55.52.88]:46174 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752600Ab0A3JxV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jan 2010 04:53:21 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,373,1262592000"; 
   d="scan'208";a="768609401"
Message-Id: <20100130094957.560789869@intel.com>
User-Agent: quilt/0.48-1
Date: Sat, 30 Jan 2010 17:45:16 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Wu Fengguang <fengguang.wu@intel.com>, LKML <linux-kernel@vger.kernel.org>,
       Eric Paris <eparis@redhat.com>
cc: Al Viro <viro@ZenIV.linux.org.uk>
cc: <linux-fsdevel@vger.kernel.org>
Subject: [PATCH 1/5] fanotify: fix FMODE_NONOTIFY bit number
References: <20100130094515.475881280@intel.com>
Content-Disposition: inline; filename=fanotify-bit-fix
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

FMODE_NONOTIFY=0x800000 collides with __O_SYNC in sparc,
so change it to 0x1000000.

CC: Eric Paris <eparis@redhat.com>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 include/asm-generic/fcntl.h |    2 +-
 include/linux/fs.h          |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- linux-mm.orig/include/asm-generic/fcntl.h	2010-01-13 10:16:27.000000000 +0800
+++ linux-mm/include/asm-generic/fcntl.h	2010-01-30 17:40:48.000000000 +0800
@@ -5,7 +5,7 @@
 
 /*
  * FMODE_EXEC is 0x20
- * FMODE_NONOTIFY is 0x800000
+ * FMODE_NONOTIFY is 0x1000000
  * These cannot be used by userspace O_* until internal and external open
  * flags are split.
  * -Eric Paris
--- linux-mm.orig/include/linux/fs.h	2010-01-30 17:14:14.000000000 +0800
+++ linux-mm/include/linux/fs.h	2010-01-30 17:41:04.000000000 +0800
@@ -91,7 +91,7 @@ struct inodes_stat_t {
 #define FMODE_RANDOM		((__force fmode_t)0x1000)
 
 /* File was opened by fanotify and shouldn't generate fanotify events */
-#define FMODE_NONOTIFY		((__force fmode_t)0x800000)
+#define FMODE_NONOTIFY		((__force fmode_t)0x1000000)
 
 /*
  * The below are the various read and write types that we support. Some of


