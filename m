Return-Path: <linux-kernel-owner+w=401wt.eu-S1759342AbZCCAHr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759342AbZCCAHr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 19:07:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758692AbZCCAHJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 19:07:09 -0500
Received: from el-out-1112.google.com ([209.85.162.178]:14608 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757909AbZCCAHG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 19:07:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=rxuk6KjvAQDxad+D7H/lueJ1hbnPBN2TiFfRhkZ/1Z915x1FTfTeLcxAEQM1S/qqAD
         LVLVj3sO/10cYJA6QqvYi0O4Rnv8D70jQMMbMwOj8PkxYKIbDdW2JVhK3+EprSDnENIG
         03QfdHm/q15A6QkPyby0YYyE0CuEFNoW309Es=
Subject: [PATCH 2/2] unaligned: add load/store_{endian}_noalign API
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Boaz Harrosh <bharrosh@panasas.com>
Content-Type: text/plain
Date: Mon, 02 Mar 2009 16:06:58 -0800
Message-Id: <1236038818.5756.12.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The existing get/put_unaligned_{endian} API is not typed, the
arguments are in the oposite of the usual order, and the name
get/put usually implies taking/releasing a reference.

Add a typed API with the usual argument ordering and use load/store,
this API is also consistent with the aligned versions.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 include/linux/unaligned/generic.h |   60 +++++++++++++++++++++++++++++++++++++
 1 files changed, 60 insertions(+), 0 deletions(-)

diff --git a/include/linux/unaligned/generic.h b/include/linux/unaligned/generic.h
index 02d97ff..1e3e267 100644
--- a/include/linux/unaligned/generic.h
+++ b/include/linux/unaligned/generic.h
@@ -1,6 +1,66 @@
 #ifndef _LINUX_UNALIGNED_GENERIC_H
 #define _LINUX_UNALIGNED_GENERIC_H
 
+static inline u16 load_le16_noalign(const __le16 *p)
+{
+	return get_unaligned_le16(p);
+}
+
+static inline u32 load_le32_noalign(const __le32 *p)
+{
+	return get_unaligned_le32(p);
+}
+
+static inline u64 load_le64_noalign(const __le64 *p)
+{
+	return get_unaligned_le64(p);
+}
+
+static inline u16 load_be16_noalign(const __be16 *p)
+{
+	return get_unaligned_be16(p);
+}
+
+static inline u32 load_be32_noalign(const __be32 *p)
+{
+	return get_unaligned_be32(p);
+}
+
+static inline u64 load_be64_noalign(const __be64 *p)
+{
+	return get_unaligned_be64(p);
+}
+
+static inline void store_le16_noalign(__le16 *p, u16 val)
+{
+	return put_unaligned_le16(val, p);
+}
+
+static inline void store_le32_noalign(__le32 *p, u32 val)
+{
+	return put_unaligned_le32(val, p);
+}
+
+static inline void store_le64_noalign(__le64 *p, u64 val)
+{
+	return put_unaligned_le64(val, p);
+}
+
+static inline void store_be16_noalign(__be16 *p, u16 val)
+{
+	return put_unaligned_be16(val, p);
+}
+
+static inline void store_be32_noalign(__be32 *p, u32 val)
+{
+	return put_unaligned_be32(val, p);
+}
+
+static inline void store_be64_noalign(__be64 *p, u64 val)
+{
+	return put_unaligned_be64(val, p);
+}
+
 /*
  * Cause a link-time error if we try an unaligned access other than
  * 1,2,4 or 8 bytes long
-- 
1.6.2.rc2.289.g2fa25

