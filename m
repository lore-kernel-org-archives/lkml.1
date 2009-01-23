Return-Path: <linux-kernel-owner+w=401wt.eu-S1758814AbZAWTvA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758814AbZAWTvA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 14:51:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757543AbZAWTue
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 14:50:34 -0500
Received: from yw-out-2324.google.com ([74.125.46.28]:52682 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752009AbZAWTub (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 14:50:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=pDT7nPe4IdIcf5r6fWIcvyvpRgBT3XU+93Q3TRjWkwZm+M0boAR86f8Q/gs03fdH1t
         pNZUqb3NT6UXUg5ZFP08xhWVf7ya4IRouTsYK97qgArpQFbXAmW3GPm5WddTUrNO91uI
         3ebl92vkn+RYKdOMShitlswaGxO5BQC5IIClg=
MIME-Version: 1.0
Date: Sat, 24 Jan 2009 01:50:30 +0600
Message-ID: <b9df5fa10901231150i1b9ea0f4n14d1cf60a9296a78@mail.gmail.com>
Subject: [PATCH] audit: Fix compile time warning on kernel/auditsc.c
From: Rakib Mullick <rakib.mullick@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 Impact: Fix compile time warning.

The function audit_set_auditable called when CONFIG_AUDIT_TREE is set.
When CONFIG_AUDIT_TREE is not set then it might be unused, which
generates the following warning. Making audit_set_auditable function
inline fixes this problem. If anything else please notice.

CC      kernel/auditsc.o
kernel/auditsc.c:745: warning: 'audit_set_auditable' defined but not used

Thanks.

Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>

--- linux-2.6-orig/kernel/auditsc.c	2009-01-23 18:28:45.000000000 +0600
+++ linux-2.6/kernel/auditsc.c	2009-01-23 22:31:34.145406088 +0600
@@ -741,7 +741,7 @@ void audit_filter_inodes(struct task_str
 	rcu_read_unlock();
 }

-static void audit_set_auditable(struct audit_context *ctx)
+static inline void audit_set_auditable(struct audit_context *ctx)
 {
 	if (!ctx->prio) {
 		ctx->prio = 1;
