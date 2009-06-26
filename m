Return-Path: <linux-kernel-owner+w=401wt.eu-S1758450AbZFZPZU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758450AbZFZPZU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 11:25:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752533AbZFZPZE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 11:25:04 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:60575 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753108AbZFZPZB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 11:25:01 -0400
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>, James Morris <jmorris@namei.org>,
       David Safford <safford@watson.ibm.com>, Mimi Zohar <zohar@us.ibm.com>
Subject: [PATCH] integrity: ima audit hash_exists fix
Date: Fri, 26 Jun 2009 11:25:00 -0400
Message-Id: <1246029900-6910-1-git-send-email-zohar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.6.0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Audit the file name, not the template name.

Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
---
 security/integrity/ima/ima_queue.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/security/integrity/ima/ima_queue.c b/security/integrity/ima/ima_queue.c
index 7ec9431..57f26f1 100644
--- a/security/integrity/ima/ima_queue.c
+++ b/security/integrity/ima/ima_queue.c
@@ -134,7 +134,8 @@ int ima_add_template_entry(struct ima_template_entry *entry, int violation,
 	}
 out:
 	mutex_unlock(&ima_extend_list_mutex);
-	integrity_audit_msg(AUDIT_INTEGRITY_PCR, inode, entry->template_name,
+	integrity_audit_msg(AUDIT_INTEGRITY_PCR, inode, 
+			    entry->template.file_name,
 			    op, audit_cause, result, audit_info);
 	return result;
 }
-- 
1.6.0.6

