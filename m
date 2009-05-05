Return-Path: <linux-kernel-owner+w=401wt.eu-S1756791AbZEERNJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756791AbZEERNJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 13:13:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754316AbZEERMz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 13:12:55 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:41113 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751943AbZEERMy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 13:12:54 -0400
Subject: [PATCH] integrity: lsm audit rule matching fix
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: James Morris <jmorris@namei.org>, david safford <safford@watson.ibm.com>
Content-Type: text/plain
Date: Tue, 05 May 2009 13:12:48 -0400
Message-Id: <1241543568.6101.10.camel@dyn9002018117.watson.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

An audit subsystem change replaced AUDIT_EQUAL with Audit_equal.
Update calls to security_filter_rule_init()/match() to reflect
the change.

Index: security-testing-2.6/security/integrity/ima/ima_policy.c
===================================================================
--- security-testing-2.6.orig/security/integrity/ima/ima_policy.c
+++ security-testing-2.6/security/integrity/ima/ima_policy.c
@@ -96,7 +96,7 @@ static bool ima_match_rules(struct ima_m
 	if ((rule->flags & IMA_UID) && rule->uid != tsk->cred->uid)
 		return false;
 	for (i = 0; i < MAX_LSM_RULES; i++) {
-		int rc;
+		int rc = 0;
 		u32 osid, sid;
 
 		if (!rule->lsm[i].rule)
@@ -109,7 +109,7 @@ static bool ima_match_rules(struct ima_m
 			security_inode_getsecid(inode, &osid);
 			rc = security_filter_rule_match(osid,
 							rule->lsm[i].type,
-							AUDIT_EQUAL,
+							Audit_equal,
 							rule->lsm[i].rule,
 							NULL);
 			break;
@@ -119,7 +119,7 @@ static bool ima_match_rules(struct ima_m
 			security_task_getsecid(tsk, &sid);
 			rc = security_filter_rule_match(sid,
 							rule->lsm[i].type,
-							AUDIT_EQUAL,
+							Audit_equal,
 							rule->lsm[i].rule,
 							NULL);
 		default:
@@ -227,7 +227,7 @@ static int ima_lsm_rule_init(struct ima_
 
 	entry->lsm[lsm_rule].type = audit_type;
 	result = security_filter_rule_init(entry->lsm[lsm_rule].type,
-					   AUDIT_EQUAL, args,
+					   Audit_equal, args,
 					   &entry->lsm[lsm_rule].rule);
 	return result;
 }


