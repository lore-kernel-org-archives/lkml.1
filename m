Return-Path: <linux-kernel-owner+w=401wt.eu-S934528AbYDQLJv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934528AbYDQLJv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 07:09:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932676AbYDQLGm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 07:06:42 -0400
Received: from hera.kernel.org ([140.211.167.34]:41601 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756515AbYDQLGd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 07:06:33 -0400
From: James Morris <jmorris@namei.org>
To: linux-security-module@vger.kernel.org
Cc: linux-audit@redhat.com, linux-kernel@vger.kernel.org,
       James Morris <jmorris@namei.org>
Subject: [PATCH 10/12] Tell git about security/selinux/include/audit.h
Date: Thu, 17 Apr 2008 11:06:07 +0000
Message-Id: <751bc5f7460a0337b7e463bd9a7c4ad60ed6176e.1208428766.git.jmorris@namei.org>
X-Mailer: git-send-email 1.5.5
In-Reply-To: <1208430369-23156-1-git-send-email-jmorris@namei.org>
References: <1208430369-23156-1-git-send-email-jmorris@namei.org>
In-Reply-To: <88d8811229b02f6b14ff1f0682dc5502a1f61b41.1208428765.git.jmorris@namei.org>
References: <88d8811229b02f6b14ff1f0682dc5502a1f61b41.1208428765.git.jmorris@namei.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: James Morris <jmorris@namei.org>
---
 security/selinux/include/audit.h |   65 ++++++++++++++++++++++++++++++++++++++
 1 files changed, 65 insertions(+), 0 deletions(-)
 create mode 100644 security/selinux/include/audit.h

diff --git a/security/selinux/include/audit.h b/security/selinux/include/audit.h
new file mode 100644
index 0000000..6c8b9ef
--- /dev/null
+++ b/security/selinux/include/audit.h
@@ -0,0 +1,65 @@
+/*
+ * SELinux support for the Audit LSM hooks
+ *
+ * Most of below header was moved from include/linux/selinux.h which 
+ * is released under below copyrights:
+ *
+ * Author: James Morris <jmorris@redhat.com>
+ *
+ * Copyright (C) 2005 Red Hat, Inc., James Morris <jmorris@redhat.com>
+ * Copyright (C) 2006 Trusted Computer Solutions, Inc. <dgoeddel@trustedcs.com>
+ * Copyright (C) 2006 IBM Corporation, Timothy R. Chavez <tinytim@us.ibm.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2,
+ * as published by the Free Software Foundation.
+ */
+
+#ifndef _SELINUX_AUDIT_H
+#define _SELINUX_AUDIT_H
+
+/**
+ *	selinux_audit_rule_init - alloc/init an selinux audit rule structure.
+ *	@field: the field this rule refers to
+ *	@op: the operater the rule uses
+ *	@rulestr: the text "target" of the rule
+ *	@rule: pointer to the new rule structure returned via this
+ *
+ *	Returns 0 if successful, -errno if not.  On success, the rule structure
+ *	will be allocated internally.  The caller must free this structure with
+ *	selinux_audit_rule_free() after use.
+ */
+int selinux_audit_rule_init(u32 field, u32 op, char *rulestr, void **rule);
+
+/**
+ *	selinux_audit_rule_free - free an selinux audit rule structure.
+ *	@rule: pointer to the audit rule to be freed
+ *
+ *	This will free all memory associated with the given rule.
+ *	If @rule is NULL, no operation is performed.
+ */
+void selinux_audit_rule_free(void *rule);
+
+/**
+ *	selinux_audit_rule_match - determine if a context ID matches a rule.
+ *	@sid: the context ID to check
+ *	@field: the field this rule refers to
+ *	@op: the operater the rule uses
+ *	@rule: pointer to the audit rule to check against
+ *	@actx: the audit context (can be NULL) associated with the check
+ *
+ *	Returns 1 if the context id matches the rule, 0 if it does not, and
+ *	-errno on failure.
+ */
+int selinux_audit_rule_match(u32 sid, u32 field, u32 op, void *rule,
+                             struct audit_context *actx);
+
+/**
+ *	selinux_audit_rule_known - check to see if rule contains selinux fields.
+ *	@rule: rule to be checked
+ *	Returns 1 if there are selinux fields specified in the rule, 0 otherwise.
+ */
+int selinux_audit_rule_known(struct audit_krule *krule);
+
+#endif /* _SELINUX_AUDIT_H */
+
-- 
1.5.4.2

