Return-Path: <linux-kernel-owner+w=401wt.eu-S1756379AbXI1Xqf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756379AbXI1Xqf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 19:46:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754255AbXI1Xq2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 19:46:28 -0400
Received: from stout.engsoc.carleton.ca ([134.117.69.22]:52925 "EHLO
	stout.engsoc.carleton.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750921AbXI1Xq0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 19:46:26 -0400
From: Kyle McMartin <kyle@mcmartin.ca>
To: linux-arch@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Kyle McMartin <kyle@mcmartin.ca>
Subject: [COMPAT] Add compat_merge64 helper
Date: Fri, 28 Sep 2007 18:33:51 -0400
Message-Id: <1191018832-18069-1-git-send-email-kyle@mcmartin.ca>
X-Mailer: git-send-email 1.5.3.2
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

To be used when endianness matters for argument ordering when reassembling
a 64-bit value out of two register halves.

Signed-off-by: Kyle McMartin <kyle@mcmartin.ca>
---
 include/linux/compat.h |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/include/linux/compat.h b/include/linux/compat.h
index 0e69d2c..07bcc3c 100644
--- a/include/linux/compat.h
+++ b/include/linux/compat.h
@@ -267,5 +267,14 @@ asmlinkage long compat_sys_signalfd(int ufd,
 asmlinkage long compat_sys_timerfd(int ufd, int clockid, int flags,
 				const struct compat_itimerspec __user *utmr);
 
+static inline u64 compat_merge64(u32 left, u32 right)
+{
+#if defined(__BIG_ENDIAN)
+	return ((u64)left << 32) | right;
+#else /* defined (__LITTLE_ENDIAN) */
+	return ((u64)right << 32) | left;
+#endif
+}
+	
 #endif /* CONFIG_COMPAT */
 #endif /* _LINUX_COMPAT_H */
-- 
1.5.3.2

