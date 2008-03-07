Return-Path: <linux-kernel-owner+w=401wt.eu-S1763362AbYCGXmO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763362AbYCGXmO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 18:42:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754969AbYCGXl6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 18:41:58 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:58099 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754191AbYCGXl6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 18:41:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=UxkA7ch+4UI9mjU4DipWB/VsIDUYjKVo32kIH85/sBgHpeiWe/aFGJF8mMcLYcQY2EjmN6FMXX+PtuIDAzdiZfo9pGb++bzRAyh90EkaRhg/0fNVLhkKLPRL7mFZuZsscfEaiRdP5+VxuF2A9nndNocp3bitRvPetOZnizYDneo=
From: Dave Young <hidave.darkstar@gmail.com>
To: akpm@linux-foundation.org
Subject: [PATCH v2] add time_now_after and other macros which compare with jiffies
Date: Sat, 8 Mar 2008 07:35:06 +0800
User-Agent: KMail/1.9.6 (enterprise 0.20071012.724442)
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803080735.06984.hidave.darkstar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes from previous version:
1. Add comments
2. Change names easy to understand. For example, now time_now_after(a) means time now after a will return true.

---
Signed-off-by: Dave Young <hidave.darkstar@gmail.com>

---
include/linux/jiffies.h |   16 ++++++++++++++++
1 file changed, 16 insertions(+)

diff -upr linux/include/linux/jiffies.h linux.new/include/linux/jiffies.h
--- linux/include/linux/jiffies.h	2008-03-07 19:56:02.000000000 +0800
+++ linux.new/include/linux/jiffies.h	2008-03-07 20:10:25.000000000 +0800
@@ -135,6 +135,22 @@ static inline u64 get_jiffies_64(void)
 #define time_before_eq64(a,b)	time_after_eq64(b,a)
 
 /*
+ * These four macros compare jiffies and 'a' for convenience.
+ */
+
+/* time_now_after(a) return true if now (jiffies) is after a */
+#define time_now_after(a) time_after(jiffies, a)
+
+/* time_now_before(a) return true if now (jiffies) is before a */
+#define time_now_before(a) time_before(jiffies, a)
+
+/* time_now_after_eq(a) return true if now (jiffies) is after or equal to a */
+#define time_now_after_eq(a) time_after_eq(jiffies, a)
+
+/* time_now_before_eq(a) return true if now (jiffies) is before or equal to a */
+#define time_now_before_eq(a) time_before_eq(jiffies, a)
+
+/*
  * Have the 32 bit jiffies value wrap 5 minutes after boot
  * so jiffies wrap bugs show up earlier.
  */
