Return-Path: <linux-kernel-owner+w=401wt.eu-S1030817AbXCNJUa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030817AbXCNJUa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 05:20:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030803AbXCNJU0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 05:20:26 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:60506 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030740AbXCNJTv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 05:19:51 -0400
To: torvalds@linux-foundation.org
Subject: [PATCH 12/17] hid-core endianness annotations
Cc: linux-kernel@vger.kernel.org
Message-Id: <E1HRPeA-0003Xn-1s@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Wed, 14 Mar 2007 09:19:50 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 drivers/hid/hid-core.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index f4ee1af..9c8157f 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -753,8 +753,7 @@ static __inline__ __u32 extract(__u8 *report, unsigned offset, unsigned n)
 
 	report += offset >> 3;  /* adjust byte index */
 	offset &= 7;            /* now only need bit offset into one byte */
-	x = get_unaligned((u64 *) report);
-	x = le64_to_cpu(x);
+	x = le64_to_cpu(get_unaligned((__le64 *) report));
 	x = (x >> offset) & ((1ULL << n) - 1);  /* extract bit field */
 	return (u32) x;
 }
@@ -769,7 +768,7 @@ static __inline__ __u32 extract(__u8 *report, unsigned offset, unsigned n)
  */
 static __inline__ void implement(__u8 *report, unsigned offset, unsigned n, __u32 value)
 {
-	u64 x;
+	__le64 x;
 	u64 m = (1ULL << n) - 1;
 
 	WARN_ON(n > 32);
@@ -780,10 +779,10 @@ static __inline__ void implement(__u8 *report, unsigned offset, unsigned n, __u3
 	report += offset >> 3;
 	offset &= 7;
 
-	x = get_unaligned((u64 *)report);
+	x = get_unaligned((__le64 *)report);
 	x &= cpu_to_le64(~(m << offset));
 	x |= cpu_to_le64(((u64) value) << offset);
-	put_unaligned(x, (u64 *) report);
+	put_unaligned(x, (__le64 *) report);
 }
 
 /*
-- 
1.5.0-rc2.GIT


