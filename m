Return-Path: <linux-kernel-owner+w=401wt.eu-S1754575AbYAZJXm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754575AbYAZJXm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2008 04:23:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753295AbYAZJX2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jan 2008 04:23:28 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:58735 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753290AbYAZJX0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2008 04:23:26 -0500
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] linux/types.h: always export 64bit aligned defines
Date: Sat, 26 Jan 2008 04:23:21 -0500
User-Agent: KMail/1.9.7
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801260423.21860.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some kernel headers exported to userspace rely on these 64bit aligned defines.
However, they are hidden behind __KERNEL_STRICT_NAMES at the moment which
means most of the time, they're never actually available.  These these defines
dont actually conflict with normal userspace / C library types, there's no
reason to hide them behind the __KERNEL_STRICT_NAMES define.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 include/linux/types.h |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/include/linux/types.h b/include/linux/types.h
index f4f8d19..b80a263 100644
--- a/include/linux/types.h
+++ b/include/linux/types.h
@@ -125,11 +125,6 @@ typedef		__u64		u_int64_t;
 typedef		__s64		int64_t;
 #endif
 
-/* this is a special 64bit data type that is 8-byte aligned */
-#define aligned_u64 unsigned long long __attribute__((aligned(8)))
-#define aligned_be64 __be64 __attribute__((aligned(8)))
-#define aligned_le64 __le64 __attribute__((aligned(8)))
-
 /**
  * The type used for indexing onto a disc or disc partition.
  *
@@ -161,6 +156,11 @@ typedef unsigned long blkcnt_t;
 
 #endif /* __KERNEL_STRICT_NAMES */
 
+/* this is a special 64bit data type that is 8-byte aligned */
+#define aligned_u64 unsigned long long __attribute__((aligned(8)))
+#define aligned_be64 __be64 __attribute__((aligned(8)))
+#define aligned_le64 __le64 __attribute__((aligned(8)))
+
 /*
  * Below are truly Linux-specific types that should never collide with
  * any application/library that wants linux/types.h.
-- 
1.5.3.8
