Return-Path: <linux-kernel-owner+w=401wt.eu-S1751795AbXCZUHM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751795AbXCZUHM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 16:07:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751831AbXCZUHM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 16:07:12 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:43397 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751795AbXCZUHK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 16:07:10 -0400
Subject: [Patch -mm] integrity: integrity_dummy_verify_metadata
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: safford@watson.ibm.com, serue@linux.vnet.ibm.com,
       kjhall@linux.vnet.ibm.com, zohar@us.ibm.com, akpm@osdl.org
In-Reply-To: <20070326022735.7d7c16f8.akpm@linux-foundation.org>
References: <1174666139.11149.0.camel@localhost.localdomain>
	 <20070326022735.7d7c16f8.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Mon, 26 Mar 2007 16:05:54 -0400
Message-Id: <1174939554.5713.2.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.2 (2.0.2-27.rhel4.6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


The following patch addresses the missing initialization values bug.

signed-off-by: Mimi Zohar <zohar@us.ibm.com>
---

Index: linux-2.6.21-rc4-mm1/security/integrity_dummy.c
===================================================================
--- linux-2.6.21-rc4-mm1.orig/security/integrity_dummy.c
+++ linux-2.6.21-rc4-mm1/security/integrity_dummy.c
@@ -19,15 +19,15 @@
 #include <linux/xattr.h>
 
 /*
- *  Return the extended attribute
+ *  Return the extended attribute, if requested. 
  */
 static int dummy_verify_metadata(struct dentry *dentry, char *xattr_name,
 				 char **xattr_value, int *xattr_value_len,
 				 int *status)
 {
-	char *value;
-	int size;
-	int error;
+	char *value = NULL;
+	int size = 0;
+	int error = 0;
 
 	if (!status)
 		return -EINVAL;


