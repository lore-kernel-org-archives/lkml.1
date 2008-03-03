Return-Path: <linux-kernel-owner+w=401wt.eu-S1762745AbYCCT2U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762745AbYCCT2U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 14:28:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757315AbYCCT2H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 14:28:07 -0500
Received: from el-out-1112.google.com ([209.85.162.176]:53482 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756958AbYCCT2E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 14:28:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=kMANK/Ko7zLEYjaLh1prmgppOXJORpCYtVtDU8S3YikULE1tDfrdVNwSpzgYqk209TLaBKhDSmh/bHHHyzRafvVem4pmf7xgXhGFES0Aaww8abM25MN4SVvlYM1bwc8C0YNxFDZg7QfRn1wGJ/YmyWoGyTB2GlWWfsHugDVCATQ=
Subject: [PATCH] sparc64: replace remaining __FUNCTION__ occurances
From: Harvey Harrison <harvey.harrison@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 03 Mar 2008 11:28:01 -0800
Message-Id: <1204572481.3266.44.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__FUNCTION__ is gcc-specific, use __func__

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 arch/sparc64/solaris/conv.h  |    2 +-
 arch/sparc64/solaris/timod.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/sparc64/solaris/conv.h b/arch/sparc64/solaris/conv.h
index 5faf59a..50e5823 100644
--- a/arch/sparc64/solaris/conv.h
+++ b/arch/sparc64/solaris/conv.h
@@ -28,7 +28,7 @@ extern unsigned sunos_sys_table[];
 #define SUNOS(x) ((long)sunos_sys_table[x])
 
 #ifdef DEBUG_SOLARIS
-#define SOLD(s) printk("%s,%d,%s(): %s\n",__FILE__,__LINE__,__FUNCTION__,(s))
+#define SOLD(s) printk("%s,%d,%s(): %s\n",__FILE__,__LINE__,__func__,(s))
 #define SOLDD(s) printk("solaris: "); printk s
 #else
 #define SOLD(s)
diff --git a/arch/sparc64/solaris/timod.c b/arch/sparc64/solaris/timod.c
index f53123c..15234fc 100644
--- a/arch/sparc64/solaris/timod.c
+++ b/arch/sparc64/solaris/timod.c
@@ -81,7 +81,7 @@ void mykfree(void *p)
 #define MKCTL_MAGIC	0xDEADBABEBADC0DEDL
 #define PUT_MAGIC(a,m)	do{(*(u64*)(a))=(m);}while(0)
 #define SCHECK_MAGIC(a,m)	do{if((*(u64*)(a))!=(m))printk("%s,%u,%s(): magic %08x at %p corrupted!\n",\
-				__FILE__,__LINE__,__FUNCTION__,(m),(a));}while(0)
+				__FILE__,__LINE__,__func__,(m),(a));}while(0)
 #define BUF_OFFSET	sizeof(u64)
 #define MKCTL_TRAILER	sizeof(u64)
 
-- 
1.5.4.3.500.g83a2c



