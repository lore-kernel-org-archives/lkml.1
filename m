Return-Path: <linux-kernel-owner+w=401wt.eu-S1757562AbZEERNq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757562AbZEERNq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 13:13:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756968AbZEERNa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 13:13:30 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:36614 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757272AbZEERN3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 13:13:29 -0400
Subject: [PATCH] integrity: remove __setup auditing msgs
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: James Morris <jmorris@namei.org>, david safford <safford@watson.ibm.com>
Content-Type: text/plain
Date: Tue, 05 May 2009 13:13:10 -0400
Message-Id: <1241543590.6101.12.camel@dyn9002018117.watson.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove integrity audit messages from __setup()

Signed-off-by: Mimi Zohar <zohar@us.ibm.com>

Index: security-testing-2.6/security/integrity/ima/ima_audit.c
===================================================================
--- security-testing-2.6.orig/security/integrity/ima/ima_audit.c
+++ security-testing-2.6/security/integrity/ima/ima_audit.c
@@ -22,18 +22,9 @@ static int ima_audit;
 static int __init ima_audit_setup(char *str)
 {
 	unsigned long audit;
-	int rc, result = 0;
-	char *op = "ima_audit";
-	char *cause;
 
-	rc = strict_strtoul(str, 0, &audit);
-	if (rc || audit > 1)
-		result = 1;
-	else
-		ima_audit = audit;
-	cause = ima_audit ? "enabled" : "not_enabled";
-	integrity_audit_msg(AUDIT_INTEGRITY_STATUS, NULL, NULL,
-			    op, cause, result, 0);
+	if (!strict_strtoul(str, 0, &audit))
+		ima_audit = audit ? 1 : 0;
 	return 1;
 }
 __setup("ima_audit=", ima_audit_setup);
Index: security-testing-2.6/security/integrity/ima/ima_main.c
===================================================================
--- security-testing-2.6.orig/security/integrity/ima/ima_main.c
+++ security-testing-2.6/security/integrity/ima/ima_main.c
@@ -29,20 +29,8 @@ int ima_initialized;
 char *ima_hash = "sha1";
 static int __init hash_setup(char *str)
 {
-	const char *op = "hash_setup";
-	const char *hash = "sha1";
-	int result = 0;
-	int audit_info = 0;
-
-	if (strncmp(str, "md5", 3) == 0) {
-		hash = "md5";
-		ima_hash = str;
-	} else if (strncmp(str, "sha1", 4) != 0) {
-		hash = "invalid_hash_type";
-		result = 1;
-	}
-	integrity_audit_msg(AUDIT_INTEGRITY_HASH, NULL, NULL, op, hash,
-			    result, audit_info);
+	if (strncmp(str, "md5", 3) == 0)
+		ima_hash = "md5";
 	return 1;
 }
 __setup("ima_hash=", hash_setup);


