Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754303Ab0BGDoM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Feb 2010 22:44:12 -0500
Received: from mga02.intel.com ([134.134.136.20]:48033 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754055Ab0BGDoH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Feb 2010 22:44:07 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,420,1262592000"; 
   d="scan'208";a="490280336"
Message-Id: <20100207034223.473443793@intel.com>
User-Agent: quilt/0.48-1
Date: Sun, 07 Feb 2010 11:28:06 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Al Viro <viro@ZenIV.linux.org.uk>, Eric Paris <eparis@redhat.com>,
       Wu Fengguang <fengguang.wu@intel.com>
CC: Roland Dreier <rdreier@cisco.com>
CC: "H. Peter Anvin" <hpa@zytor.com>
CC: Borislav Petkov <bp@amd64.org>
CC: Jamie Lokier <jamie@shareable.org>
CC: Peter Zijlstra <peterz@infradead.org>
cc: <linux-fsdevel@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/4] fanotify: fix FMODE_NONOTIFY bit number
References: <20100207032805.769788305@intel.com>
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

--- linux.orig/include/asm-generic/fcntl.h	2010-01-05 10:42:36.000000000 +0800
+++ linux/include/asm-generic/fcntl.h	2010-01-05 10:42:57.000000000 +0800
@@ -5,7 +5,7 @@
 
 /*
  * FMODE_EXEC is 0x20
- * FMODE_NONOTIFY is 0x800000
+ * FMODE_NONOTIFY is 0x1000000
  * These cannot be used by userspace O_* until internal and external open
  * flags are split.
  * -Eric Paris
--- linux.orig/include/linux/fs.h	2010-01-05 10:40:33.000000000 +0800
+++ linux/include/linux/fs.h	2010-01-05 10:42:07.000000000 +0800
@@ -88,7 +88,7 @@ struct inodes_stat_t {
 #define FMODE_NOCMTIME		((__force fmode_t)2048)
 
 /* File was opened by fanotify and shouldn't generate fanotify events */
-#define FMODE_NONOTIFY		((__force fmode_t)8388608)
+#define FMODE_NONOTIFY		((__force fmode_t)0x1000000)
 
 /*
  * The below are the various read and write types that we support. Some of


