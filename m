Return-Path: <linux-kernel-owner+w=401wt.eu-S1759529AbYHSVub@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759529AbYHSVub (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 17:50:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755424AbYHSVuU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 17:50:20 -0400
Received: from wr-out-0506.google.com ([64.233.184.232]:47797 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755284AbYHSVuS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 17:50:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=GlrzQ484ch6KmivrlwJjB8m1Qdru1nZ+W+zoO/v++woEhIzcpWZeveTUODoOpd35Sr
         8iBAPWC2Rrv1cISV8e1GT1/lBaxAwZgZFYg1u5jdrE9zTQ9JCNk2qhe21oCC7V/kXgGW
         mIVKQ6+Jk9INg+j2YYw0OvmnaFOU3yWH5QL/s=
Subject: [PATCH] kernel: fix dynamic printk sparse warnings
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jason Baron <jbaron@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 19 Aug 2008 14:50:18 -0700
Message-Id: <1219182618.17033.92.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ret is a common variable name and creates scads of shadowed variable
warnings.  Change to using __ret inside the dynamic_debug_enabled
macro.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 include/linux/dynamic_printk.h |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/linux/dynamic_printk.h b/include/linux/dynamic_printk.h
index c54cf84..2d528d0 100644
--- a/include/linux/dynamic_printk.h
+++ b/include/linux/dynamic_printk.h
@@ -37,12 +37,12 @@ extern int __dynamic_dbg_enabled_helper(char *modname, int type,
 					int value, int hash);
 
 #define __dynamic_dbg_enabled(module, type, value, level, hash)  ({	     \
-	int ret = 0;							     \
+	int __ret = 0;							     \
 	if (unlikely((dynamic_printk_enabled & (1LL << DEBUG_HASH)) &&	     \
 			(dynamic_printk_enabled2 & (1LL << DEBUG_HASH2))))   \
-			ret = __dynamic_dbg_enabled_helper(module, type,     \
+			__ret = __dynamic_dbg_enabled_helper(module, type,   \
 								value, hash);\
-	ret; })
+	__ret; })
 
 #define dynamic_pr_debug(fmt, ...) do {					    \
 	static char mod_name[]						    \
-- 
1.6.0.274.g8aacc



