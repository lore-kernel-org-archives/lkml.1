Return-Path: <linux-kernel-owner+w=401wt.eu-S1761959AbXGJCYr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761959AbXGJCYr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 22:24:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762120AbXGJCYZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 22:24:25 -0400
Received: from mx1.suse.de ([195.135.220.2]:38085 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762117AbXGJCYY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 22:24:24 -0400
From: NeilBrown <neilb@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Date: Tue, 10 Jul 2007 12:24:20 +1000
Message-Id: <1070710022420.13110@suse.de>
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YDui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Cc: nfs@lists.sourceforge.net, linux-kernel@vger.kernel.org
Cc: "J. Bruce Fields" <bfields@citi.umich.edu>
Cc: J "." Bruce Fields <bfields@citi.umich.edu>
Cc: Neil Brown <neilb@suse.de>
Subject: [PATCH 006 of 20] knfsd: nfsd: remove superfluous assignment from nfsd_lookup
References: <20070710121949.12548.patches@notabene>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: J. Bruce Fields <bfields@citi.umich.edu>

The "err" variable will only be used in the final return, which always
happens after either the preceding

	err = fh_compose(...);

or after the following

	err = nfserrno(host_err);

So the earlier assignment to err is ignored.

Signed-off-by: "J. Bruce Fields" <bfields@citi.umich.edu>
Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./fs/nfsd/vfs.c |    2 --
 1 file changed, 2 deletions(-)

diff .prev/fs/nfsd/vfs.c ./fs/nfsd/vfs.c
--- .prev/fs/nfsd/vfs.c	2007-07-10 11:20:09.000000000 +1000
+++ ./fs/nfsd/vfs.c	2007-07-10 11:34:00.000000000 +1000
@@ -168,8 +168,6 @@ nfsd_lookup(struct svc_rqst *rqstp, stru
 	exp  = fhp->fh_export;
 	exp_get(exp);
 
-	err = nfserr_acces;
-
 	/* Lookup the name, but don't follow links */
 	if (isdotent(name, len)) {
 		if (len==1)
