Return-Path: <linux-kernel-owner+w=401wt.eu-S934252AbXCWAra@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934252AbXCWAra (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 20:47:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934248AbXCWArV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 20:47:21 -0400
Received: from mx2.suse.de ([195.135.220.15]:40155 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934246AbXCWAq7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 20:46:59 -0400
From: NeilBrown <neilb@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Date: Fri, 23 Mar 2007 11:46:54 +1100
Message-Id: <1070323004654.28958@suse.de>
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YDui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Cc: nfs@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [PATCH 002 of 4] knfsd: nfsd4: fix inheritance flags on v4 ace derived from posix default ace
References: <20070323114512.28822.patches@notabene>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Bruce Fields <bfields@citi.umich.edu>

A regression introduced in the last set of acl patches removed the
INHERIT_ONLY flag from aces derived from the posix acl.  Fix.

Signed-off-by: "J. Bruce Fields" <bfields@citi.umich.edu>
Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./fs/nfsd/nfs4acl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff .prev/fs/nfsd/nfs4acl.c ./fs/nfsd/nfs4acl.c
--- .prev/fs/nfsd/nfs4acl.c	2007-03-23 11:18:58.000000000 +1100
+++ ./fs/nfsd/nfs4acl.c	2007-03-23 11:18:58.000000000 +1100
@@ -228,7 +228,7 @@ _posix_to_nfsv4_one(struct posix_acl *pa
 	struct posix_acl_summary pas;
 	unsigned short deny;
 	int eflag = ((flags & NFS4_ACL_TYPE_DEFAULT) ?
-					NFS4_INHERITANCE_FLAGS : 0);
+		NFS4_INHERITANCE_FLAGS | NFS4_ACE_INHERIT_ONLY_ACE : 0);
 
 	BUG_ON(pacl->a_count < 3);
 	summarize_posix_acl(pacl, &pas);
