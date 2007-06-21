Return-Path: <linux-kernel-owner+w=401wt.eu-S1757681AbXFUEbe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757681AbXFUEbe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 00:31:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756763AbXFUEa5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 00:30:57 -0400
Received: from cantor2.suse.de ([195.135.220.15]:59834 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756662AbXFUEa4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 00:30:56 -0400
From: NeilBrown <neilb@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Date: Thu, 21 Jun 2007 14:30:45 +1000
Message-Id: <1070621043045.1081@suse.de>
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YDui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Cc: nfs@lists.sourceforge.net, linux-kernel@vger.kernel.org
Cc: "J. Bruce Fields" <bfields@citi.umich.edu>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Neil Brown <neilb@suse.de>
Subject: [PATCH 003 of 8] knfsd: nfsd4: silence a compiler warning in ACL code
References: <20070621142604.727.patches@notabene>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: "J. Bruce Fields" <bfields@fieldses.org>


Silence a compiler warning in the ACL code, and add a comment making
clear the initialization serves no other purpose.

Signed-off-by: "J. Bruce Fields" <bfields@citi.umich.edu>
Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./fs/nfsd/nfs4acl.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff .prev/fs/nfsd/nfs4acl.c ./fs/nfsd/nfs4acl.c
--- .prev/fs/nfsd/nfs4acl.c	2007-06-21 13:46:39.000000000 +1000
+++ ./fs/nfsd/nfs4acl.c	2007-06-21 14:10:06.000000000 +1000
@@ -183,8 +183,13 @@ static void
 summarize_posix_acl(struct posix_acl *acl, struct posix_acl_summary *pas)
 {
 	struct posix_acl_entry *pa, *pe;
-	pas->users = 0;
-	pas->groups = 0;
+
+	/*
+	 * Only pas.users and pas.groups need initialization; previous
+	 * posix_acl_valid() calls ensure that the other fields will be
+	 * initialized in the following loop.  But, just to placate gcc:
+	 */
+	memset(pas, 0, sizeof(*pas));
 	pas->mask = 07;
 
 	pe = acl->a_entries + acl->a_count;
