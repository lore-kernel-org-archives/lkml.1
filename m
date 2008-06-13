Return-Path: <linux-kernel-owner+w=401wt.eu-S1755026AbYFMTAf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755026AbYFMTAf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2008 15:00:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752598AbYFMTAZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jun 2008 15:00:25 -0400
Received: from mx1.redhat.com ([66.187.233.31]:32982 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751836AbYFMTAY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2008 15:00:24 -0400
Date: Fri, 13 Jun 2008 14:59:23 -0400
From: Jason Baron <jbaron@redhat.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, joe@perches.com, greg@kroah.com,
       nick@nick-andrew.net, randy.dunlap@oracle.com
Subject: [PATCH 1/8] dynamic debug - move hashing functions
Message-ID: <20080613185923.GB8813@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


-move useful dcache hashing functions from include/linux/dcache.h
to include/linux/hash.h. This allows other kernel components
to just include the hashing functions without all of dcache.h

Signed-off-by: Jason Baron <jbaron@redhat.com>

---

 include/linux/dcache.h |   30 ------------------------------
 include/linux/hash.h   |   31 +++++++++++++++++++++++++++++++
 2 files changed, 31 insertions(+), 30 deletions(-)


diff --git a/include/linux/dcache.h b/include/linux/dcache.h
index cfb1627..a248b7f 100644
--- a/include/linux/dcache.h
+++ b/include/linux/dcache.h
@@ -46,36 +46,6 @@ struct dentry_stat_t {
 };
 extern struct dentry_stat_t dentry_stat;
 
-/* Name hashing routines. Initial hash value */
-/* Hash courtesy of the R5 hash in reiserfs modulo sign bits */
-#define init_name_hash()		0
-
-/* partial hash update function. Assume roughly 4 bits per character */
-static inline unsigned long
-partial_name_hash(unsigned long c, unsigned long prevhash)
-{
-	return (prevhash + (c << 4) + (c >> 4)) * 11;
-}
-
-/*
- * Finally: cut down the number of bits to a int value (and try to avoid
- * losing bits)
- */
-static inline unsigned long end_name_hash(unsigned long hash)
-{
-	return (unsigned int) hash;
-}
-
-/* Compute the hash for a name string. */
-static inline unsigned int
-full_name_hash(const unsigned char *name, unsigned int len)
-{
-	unsigned long hash = init_name_hash();
-	while (len--)
-		hash = partial_name_hash(*name++, hash);
-	return end_name_hash(hash);
-}
-
 struct dcookie_struct;
 
 #define DNAME_INLINE_LEN_MIN 36
diff --git a/include/linux/hash.h b/include/linux/hash.h
index 06d25c1..4083a01 100644
--- a/include/linux/hash.h
+++ b/include/linux/hash.h
@@ -67,4 +67,35 @@ static inline unsigned long hash_ptr(void *ptr, unsigned int bits)
 {
 	return hash_long((unsigned long)ptr, bits);
 }
+
+/* Name hashing routines. Initial hash value */
+/* Hash courtesy of the R5 hash in reiserfs modulo sign bits */
+#define init_name_hash()                0
+
+/* partial hash update function. Assume roughly 4 bits per character */
+static inline unsigned long
+partial_name_hash(unsigned long c, unsigned long prevhash)
+{
+	return (prevhash + (c << 4) + (c >> 4)) * 11;
+}
+
+/*
+ * Finally: cut down the number of bits to a int value (and try to avoid
+ * losing bits)
+ */
+static inline unsigned long end_name_hash(unsigned long hash)
+{
+	return (unsigned int) hash;
+}
+
+/* Compute the hash for a name string. */
+static inline unsigned int
+full_name_hash(const unsigned char *name, unsigned int len)
+{
+	unsigned long hash = init_name_hash();
+	while (len--)
+		hash = partial_name_hash(*name++, hash);
+	return end_name_hash(hash);
+}
+
 #endif /* _LINUX_HASH_H */
