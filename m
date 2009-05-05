Return-Path: <linux-kernel-owner+w=401wt.eu-S1756663AbZEERN2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756663AbZEERN2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 13:13:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755621AbZEERNI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 13:13:08 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:35741 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756125AbZEERNH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 13:13:07 -0400
Subject: [PATCH] integrity: use audit_log_string
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Eric Paris <eparis@redhat.com>, James Morris <jmorris@namei.org>,
       david safford <safford@watson.ibm.com>
Content-Type: text/plain
Date: Tue, 05 May 2009 13:13:00 -0400
Message-Id: <1241543580.6101.11.camel@dyn9002018117.watson.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Based on a request from Eric Paris to simplify parsing, replace
audit_log_format statements containing "%s" with audit_log_string().

Signed-off-by: Mimi Zohar <zohar@us.ibm.com>

Index: security-testing-2.6/security/integrity/ima/ima_audit.c
===================================================================
--- security-testing-2.6.orig/security/integrity/ima/ima_audit.c
+++ security-testing-2.6/security/integrity/ima/ima_audit.c
@@ -54,19 +54,10 @@ void integrity_audit_msg(int audit_msgno
 			 audit_get_loginuid(current),
 			 audit_get_sessionid(current));
 	audit_log_task_context(ab);
-	switch (audit_msgno) {
-	case AUDIT_INTEGRITY_DATA:
-	case AUDIT_INTEGRITY_METADATA:
-	case AUDIT_INTEGRITY_PCR:
-	case AUDIT_INTEGRITY_STATUS:
-		audit_log_format(ab, " op=%s cause=%s", op, cause);
-		break;
-	case AUDIT_INTEGRITY_HASH:
-		audit_log_format(ab, " op=%s hash=%s", op, cause);
-		break;
-	default:
-		audit_log_format(ab, " op=%s", op);
-	}
+	audit_log_format(ab, " op=");
+	audit_log_string(ab, op);
+	audit_log_format(ab, " cause=");
+	audit_log_string(ab, cause);
 	audit_log_format(ab, " comm=");
 	audit_log_untrustedstring(ab, current->comm);
 	if (fname) {


