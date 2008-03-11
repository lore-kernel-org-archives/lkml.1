Return-Path: <linux-kernel-owner+w=401wt.eu-S1753012AbYCKQ4p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753012AbYCKQ4p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 12:56:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751747AbYCKQ4i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 12:56:38 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:50746 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751480AbYCKQ4h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 12:56:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=fqJ5AP3jp5zQtyICS7cGy0EaHtxfyuF4IfTh8KdDAYDulYQcKkJWfkiMfJEeDITrlz4gPIR54eNqqajrGuyMkZ5q8MothEfmGO4CsC9gwztgrPDCVASaO45o+oCSDAoWsTwfF9hB5VWXbi3zd07VuW83y8uu60KjOjJEzdXynMg=
Subject: [PATCH] bitops: add 8-bit and 16-bit rotation functions
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 11 Mar 2008 09:56:09 -0700
Message-Id: <1205254569.22317.8.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Flesh out the api a bit, done in the same style as the 32-bit
version.  Currently there are hand-rolled versions elsewhere
in the tree that can be consolidated.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
Andrew, once this is in I'll feed the patches replacing hand-rolled
versions of this through appropriate maintainers.

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
1.5.4.4.592.g32d4c



