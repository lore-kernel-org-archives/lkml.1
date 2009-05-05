Return-Path: <linux-kernel-owner+w=401wt.eu-S1758674AbZEEXqe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758674AbZEEXqe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 19:46:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752618AbZEEXqY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 19:46:24 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:44795 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752135AbZEEXqX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 19:46:23 -0400
Subject: Re: [PATCH] integrity: lsm audit rule matching fix
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: James Morris <jmorris@namei.org>
Cc: linux-kernel@vger.kernel.org, david safford <safford@watson.ibm.com>
In-Reply-To: <alpine.LRH.2.00.0905060925390.10864@tundra.namei.org>
References: <1241543568.6101.10.camel@dyn9002018117.watson.ibm.com>
	 <alpine.LRH.2.00.0905060914300.10864@tundra.namei.org>
	 <alpine.LRH.2.00.0905060925390.10864@tundra.namei.org>
Content-Type: text/plain
Date: Tue, 05 May 2009 19:46:23 -0400
Message-Id: <1241567183.8625.8.camel@dyn9002018117.watson.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

An audit subsystem change replaced AUDIT_EQUAL with Audit_equal.
Update calls to security_filter_rule_init()/match() to reflect
the change.

Signed-off-by: Mimi Zohar <zohar@us.ibm.com>

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


