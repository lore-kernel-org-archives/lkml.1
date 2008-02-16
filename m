Return-Path: <linux-kernel-owner+w=401wt.eu-S1755585AbYBPDa3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755585AbYBPDa3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 22:30:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752566AbYBPDaI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 22:30:08 -0500
Received: from rv-out-0910.google.com ([209.85.198.190]:34901 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760257AbYBPDaG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 22:30:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=gE/BcIdzhdE1RcxjQ503NEzc26tIUpWrbqdzsbkiepI7YlYIe947Kg2qc5pzjXVLi3kKlLQLVR5yr66FY6gGXps7sFB5EaN6f6lBAj7v0bkRPCHcRbFoeNMoZRE2CsF8l4rVagKDd7KSenG1V2bNaZ1Q2JEHLOnknKlWFFj74OI=
Subject: [PATCH] lockd: fix sparse warning in svcshare.c
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 15 Feb 2008 19:30:00 -0800
Message-Id: <1203132600.7442.37.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fs/lockd/svcshare.c:74:50: warning: Using plain integer as NULL pointer

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 fs/lockd/svcshare.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/lockd/svcshare.c b/fs/lockd/svcshare.c
index 068886d..c42fcf0 100644
--- a/fs/lockd/svcshare.c
+++ b/fs/lockd/svcshare.c
@@ -71,7 +71,7 @@ nlmsvc_unshare_file(struct nlm_host *host, struct nlm_file *file,
 	struct nlm_share	*share, **shpp;
 	struct xdr_netobj	*oh = &argp->lock.oh;
 
-	for (shpp = &file->f_shares; (share = *shpp) != 0; shpp = &share->s_next) {
+	for (shpp = &file->f_shares; (share = *shpp) != NULL; shpp = &share->s_next) {
 		if (share->s_host == host && nlm_cmp_owner(share, oh)) {
 			*shpp = share->s_next;
 			kfree(share);
-- 
1.5.4.1.1278.gc75be



