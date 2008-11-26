Return-Path: <linux-kernel-owner+w=401wt.eu-S1754159AbYLAQm5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754159AbYLAQm5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 11:42:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752934AbYLAQkJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 11:40:09 -0500
Received: from zombie2.ncsc.mil ([144.51.88.133]:56955 "EHLO zombie2.ncsc.mil"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751647AbYLAQjv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 11:39:51 -0500
From: "David P. Quigley" <dpquigl@tycho.nsa.gov>
To: hch@infradead.org, viro@zeniv.linux.org.uk, casey@schaufler-ca.com,
       sds@tycho.nsa.gov, matthew.dodd@sparta.com, trond.myklebust@fys.uio.no,
       bfields@fieldses.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-security-module@vger.kernel.org, selinux@tycho.nsa.gov,
       labeled-nfs@linux-nfs.org, "David P. Quigley" <dpquigl@tycho.nsa.gov>,
       "Matthew N. Dodd" <Matthew.Dodd@sparta.com>
Subject: [PATCH 11/14] NFSv4: Introduce new label structure
Date: Wed, 26 Nov 2008 16:03:11 -0500
Message-Id: <1227733394-1114-12-git-send-email-dpquigl@tycho.nsa.gov>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1227733394-1114-1-git-send-email-dpquigl@tycho.nsa.gov>
References: <1227733394-1114-1-git-send-email-dpquigl@tycho.nsa.gov>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to mimic the way that NFSv4 ACLs are implemented we have created a
structure to be used to pass label data up and down the call chain. This patch
adds the new structure and new members to the required NFSv4 call structures.

Signed-off-by: Matthew N. Dodd <Matthew.Dodd@sparta.com>
Signed-off-by: David P. Quigley <dpquigl@tycho.nsa.gov>
---
 include/linux/nfs4.h      |    6 ++++++
 include/linux/nfs_xdr.h   |    3 +++
 include/linux/nfsd/xdr4.h |    3 +++
 3 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/include/linux/nfs4.h b/include/linux/nfs4.h
index 144eacf..dd99b27 100644
--- a/include/linux/nfs4.h
+++ b/include/linux/nfs4.h
@@ -112,6 +112,12 @@ struct nfs4_acl {
 	struct nfs4_ace	aces[0];
 };
 
+struct nfs4_label {
+	void		*label;
+	u32		len;
+};
+
+
 typedef struct { char data[NFS4_VERIFIER_SIZE]; } nfs4_verifier;
 typedef struct { char data[NFS4_STATEID_SIZE]; } nfs4_stateid;
 
diff --git a/include/linux/nfs_xdr.h b/include/linux/nfs_xdr.h
index 58532cb..177a62c 100644
--- a/include/linux/nfs_xdr.h
+++ b/include/linux/nfs_xdr.h
@@ -136,6 +136,7 @@ struct nfs_openargs {
 	const struct nfs_server *server;	 /* Needed for ID mapping */
 	const u32 *		bitmask;
 	__u32			claim;
+	const struct nfs4_label *label;
 };
 
 struct nfs_openres {
@@ -354,6 +355,7 @@ struct nfs_setattrargs {
 	struct iattr *                  iap;
 	const struct nfs_server *	server; /* Needed for name mapping */
 	const u32 *			bitmask;
+	const struct nfs4_label *	label;
 };
 
 struct nfs_setaclargs {
@@ -578,6 +580,7 @@ struct nfs4_create_arg {
 	const struct iattr *		attrs;
 	const struct nfs_fh *		dir_fh;
 	const u32 *			bitmask;
+	const struct nfs4_label *	label;
 };
 
 struct nfs4_create_res {
diff --git a/include/linux/nfsd/xdr4.h b/include/linux/nfsd/xdr4.h
index 27bd3e3..a0f3d79 100644
--- a/include/linux/nfsd/xdr4.h
+++ b/include/linux/nfsd/xdr4.h
@@ -94,6 +94,7 @@ struct nfsd4_create {
 	struct iattr	cr_iattr;           /* request */
 	struct nfsd4_change_info  cr_cinfo; /* response */
 	struct nfs4_acl *cr_acl;
+	struct nfs4_label *cr_label;
 };
 #define cr_linklen	u.link.namelen
 #define cr_linkname	u.link.name
@@ -223,6 +224,7 @@ struct nfsd4_open {
 	int		op_truncate;        /* used during processing */
 	struct nfs4_stateowner *op_stateowner; /* used during processing */
 	struct nfs4_acl *op_acl;
+	struct nfs4_label *op_label;
 };
 #define op_iattr	u.iattr
 #define op_verf		u.verf
@@ -304,6 +306,7 @@ struct nfsd4_setattr {
 	u32		sa_bmval[2];        /* request */
 	struct iattr	sa_iattr;           /* request */
 	struct nfs4_acl *sa_acl;
+	struct nfs4_label *sa_label;
 };
 
 struct nfsd4_setclientid {
-- 
1.5.5.1

