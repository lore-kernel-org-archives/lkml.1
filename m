Return-Path: <linux-kernel-owner+w=401wt.eu-S1756056AbZGBFd4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756056AbZGBFd4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 01:33:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754663AbZGBFcO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 01:32:14 -0400
Received: from mail-pz0-f188.google.com ([209.85.222.188]:54689 "EHLO
	mail-pz0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753500AbZGBFcM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 01:32:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=EbSxr1ZHrusW23hrneeIYGx4QOm4jmalAWJGidlhZqaQB5oHwI2TDlHIFR4KAfXy8r
         vqNhnjGwc/eKvPSu6itkRYb8HOr8w+gLhbBiD5EJBbmH3im450uAukHqU0jrs7vy/y9w
         H2p81EjxdMHsaJ6P/EEqoo9Fku5+WM6yF4Uyk=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: selinux@tycho.nsa.gov, "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 8/8] SELinux xfrm.c non trivial fixes.
Date: Wed,  1 Jul 2009 22:32:47 -0700
Message-Id: <1246512767-2999-9-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.6.3.2
In-Reply-To: <1246512767-2999-1-git-send-email-justinmattock@gmail.com>
References: <1246512767-2999-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

Fix some comments.
Add some words to some comment's to sound proper.
---
 security/selinux/xfrm.c |   26 +++++++++++++-------------
 1 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/security/selinux/xfrm.c b/security/selinux/xfrm.c
index 72b1845..4313064 100644
--- a/security/selinux/xfrm.c
+++ b/security/selinux/xfrm.c
@@ -27,9 +27,9 @@
  *	CONFIG_SECURITY_NETWORK_XFRM=y
  *	CONFIG_SECURITY_SELINUX=m/y
  * ISSUES:
- *   1. Caching packets, so they are not dropped during negotiation
- *   2. Emulating a reasonable SO_PEERSEC across machines
- *   3. Testing addition of sk_policy's with security context via setsockopt
+ *   1. Caching packets, so they are not dropped during negotiation.
+ *   2. Emulating a reasonable SO_PEERSEC across machines.
+ *   3. Testing addition of sk_policy's with security context via setsockopt.
  */
 #include <linux/kernel.h>
 #include <linux/init.h>
@@ -51,11 +51,11 @@
 #include "objsec.h"
 #include "xfrm.h"
 
-/* Labeled XFRM instance counter */
+/* Labeled XFRM instance counter. */
 atomic_t selinux_xfrm_refcount = ATOMIC_INIT(0);
 
 /*
- * Returns true if an LSM/SELinux context
+ * Returns true if an LSM/SELinux context.
  */
 static inline int selinux_authorizable_ctx(struct xfrm_sec_ctx *ctx)
 {
@@ -65,7 +65,7 @@ static inline int selinux_authorizable_ctx(struct xfrm_sec_ctx *ctx)
 }
 
 /*
- * Returns true if the xfrm contains a security blob for SELinux
+ * Returns true if the xfrm contains a security blob for SELinux.
  */
 static inline int selinux_authorizable_xfrm(struct xfrm_state *x)
 {
@@ -81,7 +81,7 @@ int selinux_xfrm_policy_lookup(struct xfrm_sec_ctx *ctx, u32 fl_secid, u8 dir)
 	int rc;
 	u32 sel_sid;
 
-	/* Context sid is either set to label or ANY_ASSOC */
+	/* Context sid is either set to label or ANY_ASSOC. */
 	if (ctx) {
 		if (!selinux_authorizable_ctx(ctx))
 			return -EINVAL;
@@ -118,18 +118,18 @@ int selinux_xfrm_state_pol_flow_match(struct xfrm_state *x, struct xfrm_policy *
 
 	if (!xp->security)
 		if (x->security)
-			/* unlabeled policy and labeled SA can't match */
+			/* Unlabeled policy and labeled SA can't match. */
 			return 0;
 		else
-			/* unlabeled policy and unlabeled SA match all flows */
+			/* Unlabeled policy and unlabeled SA match all flows. */
 			return 1;
 	else
 		if (!x->security)
-			/* unlabeled SA and labeled policy can't match */
+			/* Unlabeled SA and labeled policy can't match. */
 			return 0;
 		else
 			if (!selinux_authorizable_xfrm(x))
-				/* Not a SELinux-labeled SA */
+				/* Not a SELinux-labeled SA. */
 				return 0;
 
 	state_sid = x->security->ctx_sid;
@@ -191,7 +191,7 @@ int selinux_xfrm_decode_session(struct sk_buff *skb, u32 *sid, int ckall)
 
 /*
  * Security blob allocation for xfrm_policy and xfrm_state
- * CTX does not have a meaningful value on input
+ * CTX does not have a meaningful value on input.
  */
 static int selinux_xfrm_sec_ctx_alloc(struct xfrm_sec_ctx **ctxp,
 	struct xfrm_user_sec_ctx *uctx, u32 sid)
@@ -237,7 +237,7 @@ static int selinux_xfrm_sec_ctx_alloc(struct xfrm_sec_ctx **ctxp,
 		goto out;
 
 	/*
-	 * Does the subject have permission to set security context?
+	 * Does the subject have permission to set the security context?
 	 */
 	rc = avc_has_perm(tsec->sid, ctx->ctx_sid,
 			  SECCLASS_ASSOCIATION,
-- 
1.6.3.2

