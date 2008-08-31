Return-Path: <linux-kernel-owner+w=401wt.eu-S1758007AbYHaJVX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758007AbYHaJVX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2008 05:21:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751576AbYHaJVO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 Aug 2008 05:21:14 -0400
Received: from py-out-1112.google.com ([64.233.166.176]:10453 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750954AbYHaJVN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2008 05:21:13 -0400
Message-ID: <154e089b0808310221k1dd9c774hff79d545967b5283@mail.gmail.com>
Date: Sun, 31 Aug 2008 11:21:12 +0200
From: "Hannes Eder" <hannes@hanneseder.net>
To: wharms@bfs.de
Subject: Re: [PATCH] Fix build warning in kernel/auditsc.c
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
In-Reply-To: <48B93730.2020409@bfs.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48b93353.02e2660a.0e28.3e54@mx.google.com>
	 <48B93730.2020409@bfs.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the following build warning, by eliminating the variable.

kernel/auditsc.c: In function 'audit_match_perm':
kernel/auditsc.c:249: warning: ISO C90 forbids mixed declarations and code

Signed-off-by: Hannes Eder <hannes@hanneseder.net>
---
walter harms <wharms@bfs.de> wrote:
> maybe you can do a s/n/ctx->major/g ?
> removing the need for the whole variable ?!

Here we go.  Why is this better than splitting the variable declaration and
initialization, as in the previous patch?

 kernel/auditsc.c |   15 +++++++--------
 1 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index 972f8e6..f7d7ad4 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -246,28 +246,27 @@ static int audit_match_perm(struct audit_context
*ctx, int mask)
 	if (unlikely(!ctx))
 		return 0;

-	unsigned n = ctx->major;
-	switch (audit_classify_syscall(ctx->arch, n)) {
+	switch (audit_classify_syscall(ctx->arch, ctx->major)) {
 	case 0:	/* native */
 		if ((mask & AUDIT_PERM_WRITE) &&
-		     audit_match_class(AUDIT_CLASS_WRITE, n))
+		     audit_match_class(AUDIT_CLASS_WRITE, ctx->major))
 			return 1;
 		if ((mask & AUDIT_PERM_READ) &&
-		     audit_match_class(AUDIT_CLASS_READ, n))
+		     audit_match_class(AUDIT_CLASS_READ, ctx->major))
 			return 1;
 		if ((mask & AUDIT_PERM_ATTR) &&
-		     audit_match_class(AUDIT_CLASS_CHATTR, n))
+		     audit_match_class(AUDIT_CLASS_CHATTR, ctx->major))
 			return 1;
 		return 0;
 	case 1: /* 32bit on biarch */
 		if ((mask & AUDIT_PERM_WRITE) &&
-		     audit_match_class(AUDIT_CLASS_WRITE_32, n))
+		     audit_match_class(AUDIT_CLASS_WRITE_32, ctx->major))
 			return 1;
 		if ((mask & AUDIT_PERM_READ) &&
-		     audit_match_class(AUDIT_CLASS_READ_32, n))
+		     audit_match_class(AUDIT_CLASS_READ_32, ctx->major))
 			return 1;
 		if ((mask & AUDIT_PERM_ATTR) &&
-		     audit_match_class(AUDIT_CLASS_CHATTR_32, n))
+		     audit_match_class(AUDIT_CLASS_CHATTR_32, ctx->major))
 			return 1;
 		return 0;
 	case 2: /* open */
