Return-Path: <linux-kernel-owner+w=401wt.eu-S1753434AbYL2UcX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753434AbYL2UcX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 15:32:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752493AbYL2UcP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 15:32:15 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:39672 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752489AbYL2UcP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 15:32:15 -0500
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Subject: [PATCH v4] linux/uio.h: cleanup for userspace
Date: Mon, 29 Dec 2008 15:32:13 -0500
Message-Id: <1230582733-8010-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <20081229130353.GA10167@infradead.org>
References: <20081229130353.GA10167@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hide iov_shorten() behind __KERNEL__ since it's a prototype only.  Use the
__inline__ form for iov_length() since it's usable by userspace.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
v4
	- hide all funcs behind __KERNEL__
v3
	- keep all __KERNEL__ stuff in one place
v2
	- drop inline conversion stuff

 include/linux/uio.h |   18 +++++++++---------
 1 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/include/linux/uio.h b/include/linux/uio.h
index b7fe138..31d75cd 100644
--- a/include/linux/uio.h
+++ b/include/linux/uio.h
@@ -19,6 +19,13 @@ struct iovec
 	__kernel_size_t iov_len; /* Must be size_t (1003.1g) */
 };
 
+/*
+ *	UIO_MAXIOV shall be at least 16 1003.1g (5.4.1.1)
+ */
+
+#define UIO_FASTIOV	8
+#define UIO_MAXIOV	1024
+
 #ifdef __KERNEL__
 
 struct kvec {
@@ -26,15 +33,6 @@ struct kvec {
 	size_t iov_len;
 };
 
-#endif
-
-/*
- *	UIO_MAXIOV shall be at least 16 1003.1g (5.4.1.1)
- */
- 
-#define UIO_FASTIOV	8
-#define UIO_MAXIOV	1024
-
 /*
  * Total number of bytes covered by an iovec.
  *
@@ -55,3 +53,5 @@ static inline size_t iov_length(const struct iovec *iov, unsigned long nr_segs)
 unsigned long iov_shorten(struct iovec *iov, unsigned long nr_segs, size_t to);
 
 #endif
+
+#endif
-- 
1.6.0.6

