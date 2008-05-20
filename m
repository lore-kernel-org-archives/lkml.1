Return-Path: <linux-kernel-owner+w=401wt.eu-S1764172AbYETSFf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764172AbYETSFf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 14:05:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757085AbYETSF0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 14:05:26 -0400
Received: from wf-out-1314.google.com ([209.85.200.168]:3341 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755732AbYETSFZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 14:05:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=IjsEEjxHhE2GyJ/9WLHKHgQ+Bj9ZcNfc+zttb6DHzLe5cNw6/vbmU3Y15Juphn5WzcW/CWMpMKHiyBymKVzn8RQ1ruGe6oACpsFlt6wkRBhwjYdekZKJ8AcwuOUfFaMutJV9xJ5xXTf4XfLfY8CyhnZg2WVVBcR91i4TsBM5zRQ=
Subject: [PATCH 01/21] lib: add byteorder helpers for the aligned case
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 20 May 2008 11:05:21 -0700
Message-Id: <1211306721.5915.167.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some users know the pointer they are writeing to are aligned,
rather than doing *(__le16 *)ptr = cpu_to_le16(val) add helpers
wrapping this up that have the same convention as put_unaligned_le/be.

Although the get_be/le versions duplicate the le16_to_cpup functionality
add them anyway as it makes this a complete api and start work to
eliminate {le|be}{16|32|64}_to_cpup uses (not many).

This makes the api look like:

get_unaligned_le16
put_unaligned_le16

get_le16
put_le16

With explicit alignment constraints.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 include/linux/byteorder/generic.h |   60 +++++++++++++++++++++++++++++++++++++
 1 files changed, 60 insertions(+), 0 deletions(-)

diff --git a/include/linux/byteorder/generic.h b/include/linux/byteorder/generic.h
index 0846e6b..1f0c07e 100644
--- a/include/linux/byteorder/generic.h
+++ b/include/linux/byteorder/generic.h
@@ -119,6 +119,66 @@
 #define cpu_to_be16s __cpu_to_be16s
 #define be16_to_cpus __be16_to_cpus
 
+static inline u16 get_le16(void *ptr)
+{
+	return le16_to_cpu(*(__le16 *)ptr);
+}
+
+static inline u32 get_le32(void *ptr)
+{
+	return le32_to_cpu(*(__le32 *)ptr);
+}
+
+static inline u64 get_le64(void *ptr)
+{
+	return le64_to_cpu(*(__le64 *)ptr);
+}
+
+static inline u16 get_be16(void *ptr)
+{
+	return be16_to_cpu(*(__be16 *)ptr);
+}
+
+static inline u32 get_be32(void *ptr)
+{
+	return be32_to_cpu(*(__be32 *)ptr);
+}
+
+static inline u64 get_be64(void *ptr)
+{
+	return be64_to_cpu(*(__be64 *)ptr);
+}
+
+static inline void put_le16(u16 val, void *ptr)
+{
+	*(__le16 *)ptr = cpu_to_le16(val);
+}
+
+static inline void put_le32(u32 val, void *ptr)
+{
+	*(__le32 *)ptr = cpu_to_le32(val);
+}
+
+static inline void put_le64(u64 val, void *ptr)
+{
+	*(__le64 *)ptr = cpu_to_le64(val);
+}
+
+static inline void put_be16(u16 val, void *ptr)
+{
+	*(__be16 *)ptr = cpu_to_be16(val);
+}
+
+static inline void put_be32(u32 val, void *ptr)
+{
+	*(__be32 *)ptr = cpu_to_be32(val);
+}
+
+static inline void put_be64(u64 val, void *ptr)
+{
+	*(__be64 *)ptr = cpu_to_be64(val);
+}
+
 /*
  * They have to be macros in order to do the constant folding
  * correctly - if the argument passed into a inline function
-- 
1.5.5.1.570.g26b5e


