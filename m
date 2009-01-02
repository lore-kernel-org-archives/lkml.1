Return-Path: <linux-kernel-owner+w=401wt.eu-S1757398AbZABIje@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757398AbZABIje (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 03:39:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751133AbZABIj0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 03:39:26 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:33683 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750860AbZABIj0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 03:39:26 -0500
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: Sam Ravnborg <sam@ravnborg.org>, David Woodhouse <dwmw2@infradead.org>,
       Jan Engelhardt <jengelh@computergmbh.de>,
       Patrick McHardy <kaber@trash.net>,
       "David S. Miller" <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH v2] linux/types.h: always export 64bit aligned defines
Date: Fri,  2 Jan 2009 03:39:22 -0500
Message-Id: <1230885562-11456-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some kernel headers exported to userspace rely on these 64bit aligned
defines.  However, they are hidden behind __KERNEL_STRICT_NAMES at the
moment which means most of the time, they're never actually available.
These these defines dont actually conflict with normal userspace / C
library types, there's no reason to hide them behind the
__KERNEL_STRICT_NAMES define.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Jan Engelhardt <jengelh@computergmbh.de>
Cc: Patrick McHardy <kaber@trash.net>
Cc: David S. Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---
v1
	- update after the net tree merge which broke previous patch

 include/linux/types.h |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/include/linux/types.h b/include/linux/types.h
index 121f349..7c0601b 100644
--- a/include/linux/types.h
+++ b/include/linux/types.h
@@ -125,11 +125,6 @@ typedef		__u64		u_int64_t;
 typedef		__s64		int64_t;
 #endif
 
-/* this is a special 64bit data type that is 8-byte aligned */
-#define aligned_u64 __u64 __attribute__((aligned(8)))
-#define aligned_be64 __be64 __attribute__((aligned(8)))
-#define aligned_le64 __le64 __attribute__((aligned(8)))
-
 /**
  * The type used for indexing onto a disc or disc partition.
  *
@@ -156,6 +151,11 @@ typedef unsigned long blkcnt_t;
 
 #endif /* __KERNEL_STRICT_NAMES */
 
+/* this is a special 64bit data type that is 8-byte aligned */
+#define aligned_u64 __u64 __attribute__((aligned(8)))
+#define aligned_be64 __be64 __attribute__((aligned(8)))
+#define aligned_le64 __le64 __attribute__((aligned(8)))
+
 /*
  * Below are truly Linux-specific types that should never collide with
  * any application/library that wants linux/types.h.
-- 
1.6.0.6

