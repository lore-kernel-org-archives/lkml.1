Return-Path: <linux-kernel-owner+w=401wt.eu-S1757495AbYCTTlo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757495AbYCTTlo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2008 15:41:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754100AbYCTTlc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Mar 2008 15:41:32 -0400
Received: from el-out-1112.google.com ([209.85.162.182]:42393 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754779AbYCTTla (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2008 15:41:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=CgX/DVIkM2RPBhzjSFsT89fm1BIxGlu9CiyWCpYJiGcAeMvlyiveWQg7eWp2Rpxj3enFk/DoTwts5dDHycfiyybn7YhWcwJf4zUomjaZpLfj3PhI34RUC9M+sTZUOgGGgaXyLiA9anrMemVxaFDeDoPNBN3PV8Kw0kB+DI8J2aM=
Subject: [PATCH] kernel: add byteorder function with alignment fixups
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-netdev <netdev@vger.kernel.org>
In-Reply-To: <20080320190953.GR10722@ZenIV.linux.org.uk>
References: <1206034454.17059.4.camel@brick>
	 <20080320182911.GQ10722@ZenIV.linux.org.uk>
	 <1206038244.17059.7.camel@brick>
	 <20080320190953.GR10722@ZenIV.linux.org.uk>
Content-Type: text/plain
Date: Thu, 20 Mar 2008 12:41:27 -0700
Message-Id: <1206042087.17059.15.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add helpers for the pattern put_unaligned(cpu_to_le32(val), (__le32 *)p)
to linux/unaligned.h

Repeat for various combinations of le/be and 64/32/16 bit.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
Applies on top of my last patch, makes it a symmetric API.

 include/linux/unaligned.h |   30 ++++++++++++++++++++++++++++++
 1 files changed, 30 insertions(+), 0 deletions(-)

diff --git a/include/linux/unaligned.h b/include/linux/unaligned.h
index 7d8fddc..c9aa286 100644
--- a/include/linux/unaligned.h
+++ b/include/linux/unaligned.h
@@ -37,6 +37,36 @@ static inline u16 be16_to_cpu_unaligned(void *p)
 	return __be16_to_cpu(get_unaligned((__be16 *)p));
 }
 
+static inline void cpu_to_le64_unaligned(u64 val, void *p)
+{
+	put_unaligned(cpu_to_le64(val), (__le64 *)p);
+}
+
+static inline void cpu_to_le32_unaligned(u32 val, void *p)
+{
+	put_unaligned(cpu_to_le32(val), (__le32 *)p);
+}
+
+static inline void cpu_to_le16_unaligned(u16 val, void *p)
+{
+	put_unaligned(cpu_to_le16(val), (__le16 *)p);
+}
+
+static inline void cpu_to_be64_unaligned(u64 val, void *p)
+{
+	put_unaligned(cpu_to_be64(val), (__be64 *)p);
+}
+
+static inline void cpu_to_be32_unaligned(u32 val, void *p)
+{
+	put_unaligned(cpu_to_be32(val), (__be32 *)p);
+}
+
+static inline void cpu_to_be16_unaligned(u16 val, void *p)
+{
+	put_unaligned(cpu_to_be16(val), (__be16 *)p);
+}
+
 #endif /* KERNEL */
 
 #endif /* _LINUX_UNALIGNED_H */
-- 
1.5.4.4.684.g0e08



