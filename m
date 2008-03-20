Return-Path: <linux-kernel-owner+w=401wt.eu-S1756424AbYCTTWx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756424AbYCTTWx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2008 15:22:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754465AbYCTTWo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Mar 2008 15:22:44 -0400
Received: from el-out-1112.google.com ([209.85.162.181]:15254 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754473AbYCTTWn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2008 15:22:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=IwtCrOQ4gBPiUYThmpHp/sje6mBoyZiixtoE746OSK3flFsOTYvY6LrZNH4aSIWxIqFshyf2ojJ60NQZM+/PmLlpg2h3a3m8wfo971debDNZWv2pzpFWONcXd832eHRV7R8WmyS0lro69LeGXQyECA8PZYuGVfvSul9TxeAbOG8=
Subject: Re: [RFC PATCH] kernel: add byteorder macros with alignment fixups
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
Date: Thu, 20 Mar 2008 12:22:33 -0700
Message-Id: <1206040953.17059.13.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Create linux/unaligned.h to hold a common pattern in the kernel:

le32_to_cpu(get_unaligned((__le32 *)x));

Repeat for various combinations of le/be and 64/32/16 bit.  Add
a variant that operates on possibly unaligned pointers to
byteorder/generic.h

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
Now the indirect include of asm/unaligned is opt-in when places
add the linux/unaligned header.

 include/linux/unaligned.h |   42 ++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 42 insertions(+), 0 deletions(-)

diff --git a/include/linux/unaligned.h b/include/linux/unaligned.h
new file mode 100644
index 0000000..7d8fddc
--- /dev/null
+++ b/include/linux/unaligned.h
@@ -0,0 +1,42 @@
+#ifndef _LINUX_UNALIGNED_H_
+#define _LINUX_UNALIGNED_H_
+
+#include <linux/types.h>
+#include <asm/byteorder.h>
+#include <asm/unaligned.h>
+
+#ifdef __KERNEL__
+
+static inline u64 le64_to_cpu_unaligned(void *p)
+{
+	return __le64_to_cpu(get_unaligned((__le64 *)p));
+}
+
+static inline u32 le32_to_cpu_unaligned(void *p)
+{
+	return __le32_to_cpu(get_unaligned((__le32 *)p));
+}
+
+static inline u16 le16_to_cpu_unaligned(void *p)
+{
+	return __le16_to_cpu(get_unaligned((__le16 *)p));
+}
+
+static inline u64 be64_to_cpu_unaligned(void *p)
+{
+	return __be64_to_cpu(get_unaligned((__be64 *)p));
+}
+
+static inline u32 be32_to_cpu_unaligned(void *p)
+{
+	return __be32_to_cpu(get_unaligned((__be32 *)p));
+}
+
+static inline u16 be16_to_cpu_unaligned(void *p)
+{
+	return __be16_to_cpu(get_unaligned((__be16 *)p));
+}
+
+#endif /* KERNEL */
+
+#endif /* _LINUX_UNALIGNED_H */
-- 
1.5.4.4.684.g0e08



