Return-Path: <linux-kernel-owner+w=401wt.eu-S934248AbXCWArb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934248AbXCWArb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 20:47:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934250AbXCWArU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 20:47:20 -0400
Received: from ns2.suse.de ([195.135.220.15]:40162 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934248AbXCWArE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 20:47:04 -0400
From: NeilBrown <neilb@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Date: Fri, 23 Mar 2007 11:46:59 +1100
Message-Id: <1070323004659.28973@suse.de>
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YDui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Cc: nfs@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [PATCH 003 of 4] knfsd: nfsd4: demote "clientid in use" printk to a dprintk
References: <20070323114512.28822.patches@notabene>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Bruce Fields <bfields@citi.umich.edu>

The reused clientid here is a more of a problem for the client than the
server, and the client can report the problem itself if it's serious.

Signed-off-by: "J. Bruce Fields" <bfields@citi.umich.edu>
Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./fs/nfsd/nfs4state.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff .prev/fs/nfsd/nfs4state.c ./fs/nfsd/nfs4state.c
--- .prev/fs/nfsd/nfs4state.c	2007-03-23 11:19:14.000000000 +1100
+++ ./fs/nfsd/nfs4state.c	2007-03-23 11:19:14.000000000 +1100
@@ -750,9 +750,8 @@ nfsd4_setclientid(struct svc_rqst *rqstp
 		status = nfserr_clid_inuse;
 		if (!cmp_creds(&conf->cl_cred, &rqstp->rq_cred)
 				|| conf->cl_addr != sin->sin_addr.s_addr) {
-			printk("NFSD: setclientid: string in use by client"
-			"(clientid %08x/%08x)\n",
-			conf->cl_clientid.cl_boot, conf->cl_clientid.cl_id);
+			dprintk("NFSD: setclientid: string in use by client"
+				"at %u.%u.%u.%u\n", NIPQUAD(conf->cl_addr));
 			goto out;
 		}
 	}
