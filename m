Return-Path: <linux-kernel-owner+w=401wt.eu-S1756781AbZCBWnU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756781AbZCBWnU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 17:43:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753939AbZCBWnE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 17:43:04 -0500
Received: from mail-bw0-f178.google.com ([209.85.218.178]:50109 "EHLO
	mail-bw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753265AbZCBWnC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 17:43:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=f03rbDSpEzE4E5TmDo2su7fbov7ETXC5EdEKtKahu27UJnkTMDAq+99MsHQIHGYrzl
         lSG9gyxbOXk6WW5si6p6aQ2nO8L/VZqiSr77qHNzpiEdexjJVvwfbu5RhH1E+4UJyYHz
         jncneU/sBxuQ6crXtwUOfo+a7M3187XBvRzRc=
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: linux-input@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 1/2] ktime: add ktime_compare
Date: Mon,  2 Mar 2009 23:42:51 +0100
Message-Id: <1236033772-20329-1-git-send-email-marcin.slusarz@gmail.com>
X-Mailer: git-send-email 1.6.0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

add ktime_compare as an analogy to timeval_compare/timespec_compare

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
---
 include/linux/ktime.h |   28 ++++++++++++++++++++++++++++
 1 files changed, 28 insertions(+), 0 deletions(-)

diff --git a/include/linux/ktime.h b/include/linux/ktime.h
index ce59832..4590f95 100644
--- a/include/linux/ktime.h
+++ b/include/linux/ktime.h
@@ -130,6 +130,20 @@ static inline ktime_t timeval_to_ktime(struct timeval tv)
 /* Convert ktime_t to nanoseconds - NOP in the scalar storage format: */
 #define ktime_to_ns(kt)			((kt).tv64)
 
+/*
+ * lhs < rhs:  return <0
+ * lhs == rhs: return 0
+ * lhs > rhs:  return >0
+ */
+static inline int ktime_compare(ktime_t lhs, ktime_t rhs)
+{
+	if (lhs.tv64 < rhs.tv64)
+		return -1;
+	if (lhs.tv64 > rhs.tv64)
+		return 1;
+	return 0;
+}
+
 #else
 
 /*
@@ -275,6 +289,20 @@ static inline s64 ktime_to_ns(const ktime_t kt)
 	return (s64) kt.tv.sec * NSEC_PER_SEC + kt.tv.nsec;
 }
 
+/*
+ * lhs < rhs:  return <0
+ * lhs == rhs: return 0
+ * lhs > rhs:  return >0
+ */
+static inline int ktime_compare(ktime_t lhs, ktime_t rhs)
+{
+	if (lhs.sec < rhs.sec)
+		return -1;
+	if (lhs.sec > rhs.sec)
+		return 1;
+	return lhs.nsec - rhs.nsec;
+}
+
 #endif
 
 /**
-- 
1.6.0.6

