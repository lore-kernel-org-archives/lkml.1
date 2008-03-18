Return-Path: <linux-kernel-owner+w=401wt.eu-S1755527AbYCSTb4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755527AbYCSTb4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 15:31:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753735AbYCST0Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 15:26:24 -0400
Received: from rn-out-0910.google.com ([64.233.170.189]:55369 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753276AbYCSTZR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 15:25:17 -0400
Subject: [PATCH] kernel: add bit rotation helpers for 16 and 8 bit
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Johannes Berg <johannes@sipsolutions.net>,
       Randy Dunlap <randy.dunlap@oracle.com>
Content-Type: text/plain
Date: Tue, 18 Mar 2008 13:24:01 -0700
Message-Id: <1205871841.17607.10.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Will replace open-coded variants elsewhere.  Done in the same
style as the 32-bit versions.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
Andrew, these will be used to replace some open-coded variants in the
mac80211 code, there are currently no users so it can go in with little
risk.

Randy, CC'd in case I screwed up the kerneldoc.

 include/linux/bitops.h |   40 ++++++++++++++++++++++++++++++++++++++++
 1 files changed, 40 insertions(+), 0 deletions(-)

diff --git a/include/linux/bitops.h b/include/linux/bitops.h
index 69c1edb..40d5473 100644
--- a/include/linux/bitops.h
+++ b/include/linux/bitops.h
@@ -65,6 +65,46 @@ static inline __u32 ror32(__u32 word, unsigned int shift)
 	return (word >> shift) | (word << (32 - shift));
 }
 
+/**
+ * rol16 - rotate a 16-bit value left
+ * @word: value to rotate
+ * @shift: bits to roll
+ */
+static inline __u16 rol16(__u16 word, unsigned int shift)
+{
+	return (word << shift) | (word >> (16 - shift));
+}
+
+/**
+ * ror16 - rotate a 16-bit value right
+ * @word: value to rotate
+ * @shift: bits to roll
+ */
+static inline __u16 ror16(__u16 word, unsigned int shift)
+{
+	return (word >> shift) | (word << (16 - shift));
+}
+
+/**
+ * rol8 - rotate an 8-bit value left
+ * @word: value to rotate
+ * @shift: bits to roll
+ */
+static inline __u8 rol8(__u8 word, unsigned int shift)
+{
+	return (word << shift) | (word >> (8 - shift));
+}
+
+/**
+ * ror8 - rotate an 8-bit value right
+ * @word: value to rotate
+ * @shift: bits to roll
+ */
+static inline __u8 ror8(__u8 word, unsigned int shift)
+{
+	return (word >> shift) | (word << (8 - shift));
+}
+
 static inline unsigned fls_long(unsigned long l)
 {
 	if (sizeof(l) == 4)
-- 
1.5.4.4.684.g0e08



