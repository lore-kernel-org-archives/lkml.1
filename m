Return-Path: <linux-kernel-owner+w=401wt.eu-S1754012AbYL0Gui@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754012AbYL0Gui (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Dec 2008 01:50:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751650AbYL0Gto
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Dec 2008 01:49:44 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:36040 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751538AbYL0Gtn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Dec 2008 01:49:43 -0500
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] linux/uio.h: cleanup for userspace
Date: Sat, 27 Dec 2008 01:49:42 -0500
Message-Id: <1230360582-6657-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hide iov_shorten() behind __KERNEL__ since it's a prototype only.  Use the
__inline__ form for iov_length() since it's usable by userspace.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 include/linux/uio.h |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/include/linux/uio.h b/include/linux/uio.h
index b7fe138..2faeea6 100644
--- a/include/linux/uio.h
+++ b/include/linux/uio.h
@@ -42,7 +42,7 @@ struct kvec {
  * segment lengths have been validated.  Because the individual lengths can
  * overflow a size_t when added together.
  */
-static inline size_t iov_length(const struct iovec *iov, unsigned long nr_segs)
+static __inline__ size_t iov_length(const struct iovec *iov, unsigned long nr_segs)
 {
 	unsigned long seg;
 	size_t ret = 0;
@@ -52,6 +52,8 @@ static inline size_t iov_length(const struct iovec *iov, unsigned long nr_segs)
 	return ret;
 }
 
+#ifdef __KERNEL__
 unsigned long iov_shorten(struct iovec *iov, unsigned long nr_segs, size_t to);
+#endif
 
 #endif
-- 
1.6.0.6

