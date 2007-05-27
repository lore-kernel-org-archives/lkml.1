Return-Path: <linux-kernel-owner+w=401wt.eu-S1753087AbXE0Kew@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753087AbXE0Kew (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2007 06:34:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751154AbXE0Keo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 May 2007 06:34:44 -0400
Received: from havoc.gtf.org ([69.61.125.42]:33162 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751114AbXE0Keo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2007 06:34:44 -0400
Date: Sun, 27 May 2007 06:34:42 -0400
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>, neilb@suse.de
Cc: LKML <linux-kernel@vger.kernel.org>, nfs@lists.sourceforge.net
Subject: [PATCH] NFSD: fix uninitialized variable
Message-ID: <20070527103442.GA10594@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Unlike many of the bogus warnings spewed by gcc, this one actually
complains about a real bug:

fs/nfsd/nfs4acl.c: In function ‘_posix_to_nfsv4_one’:
fs/nfsd/nfs4acl.c:227: warning: ‘pas.owner’ may be used uninitialized in this function
fs/nfsd/nfs4acl.c:227: warning: ‘pas.group’ may be used uninitialized in this function
fs/nfsd/nfs4acl.c:227: warning: ‘pas.other’ may be used uninitialized in this function

Signed-off-by: Jeff Garzik <jeff@garzik.org>

diff --git a/fs/nfsd/nfs4acl.c b/fs/nfsd/nfs4acl.c
index cc3b7ba..7fd4d44 100644
--- a/fs/nfsd/nfs4acl.c
+++ b/fs/nfsd/nfs4acl.c
@@ -183,8 +183,8 @@ static void
 summarize_posix_acl(struct posix_acl *acl, struct posix_acl_summary *pas)
 {
 	struct posix_acl_entry *pa, *pe;
-	pas->users = 0;
-	pas->groups = 0;
+
+	memset(pas, 0, sizeof(*pas));
 	pas->mask = 07;
 
 	pe = acl->a_entries + acl->a_count;
