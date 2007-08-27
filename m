Return-Path: <linux-kernel-owner+w=401wt.eu-S964903AbXH0U3Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964903AbXH0U3Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 16:29:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761301AbXH0UXS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 16:23:18 -0400
Received: from mail.fieldses.org ([66.93.2.214]:43348 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762057AbXH0UXL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 16:23:11 -0400
From: "J. Bruce Fields" <bfields@fieldses.org>
To: linux-kernel@vger.kernel.org
Cc: nfs@lists.sourceforge.net, Neil Brown <neilb@suse.de>,
       "J. Bruce Fields" <bfields@citi.umich.edu>
Subject: [PATCH 13/15] knfsd: remove code duplication in nfsd4_setclientid()
Date: Mon, 27 Aug 2007 16:22:54 -0400
Message-Id: <11882461782430-git-send-email-bfields@fieldses.org>
X-Mailer: git-send-email 1.5.3.rc6.48.g17437
In-Reply-To: <11882461772689-git-send-email-bfields@fieldses.org>
References: <11882461763072-git-send-email-bfields@fieldses.org>
 <1188246176681-git-send-email-bfields@fieldses.org>
 <1188246176897-git-send-email-bfields@fieldses.org>
 <1188246177833-git-send-email-bfields@fieldses.org>
 <11882461773576-git-send-email-bfields@fieldses.org>
 <11882461771774-git-send-email-bfields@fieldses.org>
 <1188246177195-git-send-email-bfields@fieldses.org>
 <11882461773396-git-send-email-bfields@fieldses.org>
 <1188246177259-git-send-email-bfields@fieldses.org>
 <1188246177192-git-send-email-bfields@fieldses.org>
 <11882461773221-git-send-email-bfields@fieldses.org>
 <11882461773657-git-send-email-bfields@fieldses.org>
 <11882461772689-git-send-email-bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: J. Bruce Fields <bfields@citi.umich.edu>

Each branch of this if-then-else has a bunch of duplicated code that we
could just put at the end.

Signed-off-by: "J. Bruce Fields" <bfields@citi.umich.edu>
---
 fs/nfsd/nfs4state.c |   30 ++++++------------------------
 1 files changed, 6 insertions(+), 24 deletions(-)

diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index 09573b9..6256492 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -774,13 +774,7 @@ nfsd4_setclientid(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 		new = create_client(clname, dname);
 		if (new == NULL)
 			goto out;
-		copy_verf(new, &clverifier);
-		new->cl_addr = sin->sin_addr.s_addr;
-		copy_cred(&new->cl_cred,&rqstp->rq_cred);
 		gen_clid(new);
-		gen_confirm(new);
-		gen_callback(new, setclid);
-		add_to_unconfirmed(new, strhashval);
 	} else if (same_verf(&conf->cl_verifier, &clverifier)) {
 		/*
 		 * CASE 1:
@@ -806,13 +800,7 @@ nfsd4_setclientid(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 		new = create_client(clname, dname);
 		if (new == NULL)
 			goto out;
-		copy_verf(new,&conf->cl_verifier);
-		new->cl_addr = sin->sin_addr.s_addr;
-		copy_cred(&new->cl_cred,&rqstp->rq_cred);
 		copy_clid(new, conf);
-		gen_confirm(new);
-		gen_callback(new, setclid);
-		add_to_unconfirmed(new,strhashval);
 	} else if (!unconf) {
 		/*
 		 * CASE 2:
@@ -825,13 +813,7 @@ nfsd4_setclientid(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 		new = create_client(clname, dname);
 		if (new == NULL)
 			goto out;
-		copy_verf(new,&clverifier);
-		new->cl_addr = sin->sin_addr.s_addr;
-		copy_cred(&new->cl_cred,&rqstp->rq_cred);
 		gen_clid(new);
-		gen_confirm(new);
-		gen_callback(new, setclid);
-		add_to_unconfirmed(new, strhashval);
 	} else if (!same_verf(&conf->cl_confirm, &unconf->cl_confirm)) {
 		/*	
 		 * CASE3:
@@ -852,19 +834,19 @@ nfsd4_setclientid(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 		new = create_client(clname, dname);
 		if (new == NULL)
 			goto out;
-		copy_verf(new,&clverifier);
-		new->cl_addr = sin->sin_addr.s_addr;
-		copy_cred(&new->cl_cred,&rqstp->rq_cred);
 		gen_clid(new);
-		gen_confirm(new);
-		gen_callback(new, setclid);
-		add_to_unconfirmed(new, strhashval);
 	} else {
 		/* No cases hit !!! */
 		status = nfserr_inval;
 		goto out;
 
 	}
+	copy_verf(new, &clverifier);
+	new->cl_addr = sin->sin_addr.s_addr;
+	copy_cred(&new->cl_cred, &rqstp->rq_cred);
+	gen_confirm(new);
+	gen_callback(new, setclid);
+	add_to_unconfirmed(new, strhashval);
 	setclid->se_clientid.cl_boot = new->cl_clientid.cl_boot;
 	setclid->se_clientid.cl_id = new->cl_clientid.cl_id;
 	memcpy(setclid->se_confirm.data, new->cl_confirm.data, sizeof(setclid->se_confirm.data));
-- 
1.5.3.rc5.19.g0734d

