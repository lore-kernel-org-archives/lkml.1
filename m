Return-Path: <linux-kernel-owner+w=401wt.eu-S1756774AbZCLORN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756774AbZCLORN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 10:17:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755647AbZCLOQ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 10:16:57 -0400
Received: from ti-out-0910.google.com ([209.85.142.191]:39130 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754040AbZCLOQ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 10:16:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:mime-version
         :content-type:content-disposition:user-agent;
        b=g6QRGizF4eqD2gWDMKGP2sID84E/k/PQ89brtVvoKa62TNEHuMB+gDinEqa+6i40Ta
         u+kz+dNmcOEM2ugAxpnmuPH2yMsQXhV4oluZoW1gMMYMLkhuuSJTHcY+3KmjUOMe9r9y
         tY1CSX02GAJPuMfPPL4gXWIrD+4LeVqYgPFuQ=
Date: Thu, 12 Mar 2009 22:16:12 +0800
From: Zhenwen Xu <helight.xu@gmail.com>
To: viro@zeniv.linux.org.uk
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-audit@redhat.com
Subject: [PATCH]make the e->rule.xxx shorter in kernel auditfilter.c
Message-ID: <20090312141612.GB3859@helight>
Reply-To: Zhenwen Xu <helight.xu@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


make the e->rule.xxx shorter in kernel/auditfilter.c
-- 
---------------------------------
Zhenwen Xu - Open and Free
Home Page:	http://zhwen.org
My Studio:	http://dim4.cn

>From 99692dc640b278f1cb1a15646ce42f22e89c0f77 Mon Sep 17 00:00:00 2001
From: Zhenwen Xu <Helight.Xu@gmail.com>
Date: Thu, 12 Mar 2009 22:04:59 +0800
Subject: [PATCH] make the e->rule.xxx shorter in kernel/auditfilter.c


Signed-off-by: Zhenwen Xu <Helight.Xu@gmail.com>
---
 kernel/auditfilter.c |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/kernel/auditfilter.c b/kernel/auditfilter.c
index fbf24d1..a6fe71f 100644
--- a/kernel/auditfilter.c
+++ b/kernel/auditfilter.c
@@ -135,18 +135,18 @@ static void audit_remove_watch(struct audit_watch *watch)
 static inline void audit_free_rule(struct audit_entry *e)
 {
 	int i;
-
+	struct audit_krule *erule = &e->rule;
 	/* some rules don't have associated watches */
-	if (e->rule.watch)
-		audit_put_watch(e->rule.watch);
-	if (e->rule.fields)
-		for (i = 0; i < e->rule.field_count; i++) {
-			struct audit_field *f = &e->rule.fields[i];
+	if (erule->watch)
+		audit_put_watch(erule->watch);
+	if (erule->fields)
+		for (i = 0; i < erule->field_count; i++) {
+			struct audit_field *f = &erule->fields[i];
 			kfree(f->lsm_str);
 			security_audit_rule_free(f->lsm_rule);
 		}
-	kfree(e->rule.fields);
-	kfree(e->rule.filterkey);
+	kfree(erule->fields);
+	kfree(erule->filterkey);
 	kfree(e);
 }
 
-- 
1.5.6.5

