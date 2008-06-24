Return-Path: <linux-kernel-owner+w=401wt.eu-S1756470AbYFXALP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756470AbYFXALP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 20:11:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752499AbYFXAJZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 20:09:25 -0400
Received: from wf-out-1314.google.com ([209.85.200.172]:55360 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756074AbYFXAJV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 20:09:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=DvoohQmNceRW1zmb+mwWy2afox+b8NOzeCKI3oWf7EwyZ8EEhYB5CwJT+mqHEOedQG
         k7KORN/CqxSEHQGWNDhtjEjnHYhx5wO7lrR3hy8aFLByFHwbVMYT8paIDmjZsMJytcqM
         zDGoTKarjpw90u39YoO57zx9qz1y82cHT3dF4=
Subject: [PATCH 6/6] byteorder: add store_{endian} helpers
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 23 Jun 2008 17:09:10 -0700
Message-Id: <1214266150.21092.47.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add helpers for the idiom:
*(__le16 *)ptr = cpu_to_le16(val);

Can now be written as:
store_le16(ptr, val);

Implemented as macros to allow val to be byteswapped at compile-time
when it is a constant.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 include/linux/byteorder.h |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/include/linux/byteorder.h b/include/linux/byteorder.h
index b4713ce..20abbf8 100644
--- a/include/linux/byteorder.h
+++ b/include/linux/byteorder.h
@@ -278,6 +278,17 @@ static inline __be64 __cpu_to_be64p(const __u64 *p)
 # define htons(x) ___htons(x)
 # define ntohs(x) ___ntohs(x)
 
+/*
+ * Defined as macros to allow constant folding of the cpu_to_XXXX when
+ * possible.
+ */
+#define store_le16(ptr, val)	(*(__le16 *)(ptr) = cpu_to_le16((u16)(val));)
+#define store_le32(ptr, val)	(*(__le32 *)(ptr) = cpu_to_le32((u32)(val));)
+#define store_le64(ptr, val)	(*(__le64 *)(ptr) = cpu_to_le64((u64)(val));)
+#define store_be16(ptr, val)	(*(__be16 *)(ptr) = cpu_to_be16((u16)(val));)
+#define store_be32(ptr, val)	(*(__be32 *)(ptr) = cpu_to_be32((u32)(val));)
+#define store_be64(ptr, val)	(*(__be64 *)(ptr) = cpu_to_be64((u64)(val));)
+
 static inline void le16_add_cpu(__le16 *var, u16 val)
 {
 	*var = cpu_to_le16(le16_to_cpup(var) + val);
-- 
1.5.6.290.gc4e15

