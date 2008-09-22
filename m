Return-Path: <linux-kernel-owner+w=401wt.eu-S1754656AbYIVXL4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754656AbYIVXL4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 19:11:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753575AbYIVXLs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 19:11:48 -0400
Received: from mx1.redhat.com ([66.187.233.31]:48153 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753499AbYIVXLr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 19:11:47 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] CRED: Delete alloc_creds() as it's not used
To: akpm@osdl.org, jmorris@namei.org
Cc: dhowells@redhat.com, linux-security-module@vger.kernel.org,
       linux-kernel@vger.kernel.org
Date: Tue, 23 Sep 2008 00:10:05 +0100
Message-ID: <20080922231005.2472.65288.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Delete alloc_creds() as it's not used.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 kernel/cred-internals.h |    5 -----
 kernel/cred.c           |   15 ---------------
 2 files changed, 0 insertions(+), 20 deletions(-)


diff --git a/kernel/cred-internals.h b/kernel/cred-internals.h
index f16312a..2dc4fc2 100644
--- a/kernel/cred-internals.h
+++ b/kernel/cred-internals.h
@@ -10,11 +10,6 @@
  */
 
 /*
- * cred.c
- */
-extern struct cred *alloc_creds(const struct cred *, gfp_t);
-
-/*
  * user.c
  */
 static inline void sched_switch_user(struct task_struct *p)
diff --git a/kernel/cred.c b/kernel/cred.c
index a68a154..49ed76a 100644
--- a/kernel/cred.c
+++ b/kernel/cred.c
@@ -112,21 +112,6 @@ void __put_cred(struct cred *cred)
 }
 EXPORT_SYMBOL(__put_cred);
 
-/*
- * Allocate new credentials
- */
-struct cred *alloc_creds(const struct cred *old, gfp_t gfp)
-{
-	struct cred *new;
-
-	new = kmem_cache_alloc(cred_jar, GFP_KERNEL);
-	if (!new)
-		return NULL;
-	if (old)
-		memcpy(new, old, sizeof(struct cred));
-	return new;
-}
-
 /**
  * prepare_creds - Prepare a new set of credentials for modification
  *

