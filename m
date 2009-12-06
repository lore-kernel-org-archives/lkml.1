Return-Path: <linux-kernel-owner+w=401wt.eu-S933191AbZLFJRA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933191AbZLFJRA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 04:17:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932393AbZLFJQ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 04:16:57 -0500
Received: from mgw1.diku.dk ([130.225.96.91]:47589 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933052AbZLFJQr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 04:16:47 -0500
Date: Sun, 6 Dec 2009 10:16:51 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: Stephen Smalley <sds@tycho.nsa.gov>, James Morris <jmorris@namei.org>,
       Eric Paris <eparis@parisplace.org>,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 5/5] security/selinux/ss: correct size computation
Message-ID: <Pine.LNX.4.64.0912061016310.20858@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

The size argument to kcalloc should be the size of desired structure,
not the pointer to it.

The semantic patch that makes this change is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@expression@
expression *x;
@@

x =
 <+...
-sizeof(x)
+sizeof(*x)
...+>// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 security/selinux/ss/services.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -u -p a/security/selinux/ss/services.c b/security/selinux/ss/services.c
--- a/security/selinux/ss/services.c
+++ b/security/selinux/ss/services.c
@@ -2555,7 +2555,7 @@ int security_get_classes(char ***classes
 	read_lock(&policy_rwlock);
 
 	*nclasses = policydb.p_classes.nprim;
-	*classes = kcalloc(*nclasses, sizeof(*classes), GFP_ATOMIC);
+	*classes = kcalloc(*nclasses, sizeof(**classes), GFP_ATOMIC);
 	if (!*classes)
 		goto out;
 
@@ -2602,7 +2602,7 @@ int security_get_permissions(char *class
 	}
 
 	*nperms = match->permissions.nprim;
-	*perms = kcalloc(*nperms, sizeof(*perms), GFP_ATOMIC);
+	*perms = kcalloc(*nperms, sizeof(**perms), GFP_ATOMIC);
 	if (!*perms)
 		goto out;
 
