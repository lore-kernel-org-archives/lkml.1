Return-Path: <linux-kernel-owner+w=401wt.eu-S933262AbXC1QkY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933262AbXC1QkY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 12:40:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933151AbXC1QkY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 12:40:24 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:56631 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933262AbXC1QkW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 12:40:22 -0400
Subject: [Patch -mm] integrity: ima exit
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: safford@watson.ibm.com, serue@linux.vnet.ibm.com,
       kjhall@linux.vnet.ibm.com, sailer@us.ibm.com, zohar@us.ibm.com,
       akpm@osdl.org
Content-Type: text/plain
Date: Wed, 28 Mar 2007 12:39:13 -0400
Message-Id: <1175099953.16382.1.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.2 (2.0.2-27.rhel4.6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch corrects calling an __exit function from a non-_-exit function.

signed-off-by: Mimi Zohar <zohar@us.ibm.com>
signed-off-by: Kylene Hall <kjhall@us.ibm.com>
---

 security/evm/ima/ima_init.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.21-rc5-mm2/security/evm/ima/ima_init.c
===================================================================
--- linux-2.6.21-rc5-mm2.orig/security/evm/ima/ima_init.c
+++ linux-2.6.21-rc5-mm2/security/evm/ima/ima_init.c
@@ -111,7 +111,7 @@ int ima_init(void)
 	return ima_fs_init();
 }
 
-void ima_cleanup(void)
+void __exit ima_cleanup(void)
 {
 	ima_fs_cleanup();
 }
Index: linux-2.6.21-rc5-mm2/security/evm/evm_integrity.h
===================================================================
--- linux-2.6.21-rc5-mm2.orig/security/evm/evm_integrity.h
+++ linux-2.6.21-rc5-mm2/security/evm/evm_integrity.h
@@ -9,21 +9,21 @@
 extern unsigned int evm_enable_ima;
 
 #ifdef CONFIG_IMA_MEASURE
-static inline int evm_ima_init(void)
+static int evm_ima_init(void)
 {
 	if (evm_enable_ima)
 		return ima_init();
 	return 0;
 }
 
-static inline void evm_ima_measure(const unsigned char *name, int hash_len,
+static void evm_ima_measure(const unsigned char *name, int hash_len,
 				   char *hash)
 {
 	if (evm_enable_ima)
 		ima_measure(name, hash_len, hash);
 }
 
-static inline void evm_ima_cleanup(void)
+static void __exit evm_ima_cleanup(void)
 {
 	if (evm_enable_ima)
 		ima_cleanup();
@@ -31,19 +31,19 @@ static inline void evm_ima_cleanup(void)
 }
 
 #else
-static inline int evm_ima_init(void)
+static int evm_ima_init(void)
 {
 	evm_enable_ima = 0;
 	return 0;
 }
 
-static inline void evm_ima_measure(const unsigned char *name, int hash_len,
+static void evm_ima_measure(const unsigned char *name, int hash_len,
 				   char *hash)
 {
 	return;
 }
 
-static inline void evm_ima_cleanup(void)
+static void __exit evm_ima_cleanup(void)
 {
 	evm_enable_ima = 0;
 }



