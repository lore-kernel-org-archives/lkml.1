Return-Path: <linux-kernel-owner+w=401wt.eu-S1763332AbXKNCH4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763332AbXKNCH4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 21:07:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761539AbXKNCFY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 21:05:24 -0500
Received: from DSL022.labridge.com ([206.117.136.22]:4766 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761540AbXKNCFW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 21:05:22 -0500
Subject: [PATCH] - [8/15] - remove defconfig ptr comparisons to 0 - fs/nfs
From: Joe Perches <joe@perches.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Trond Myklebust <trond.myklebust@fys.uio.no>
Content-Type: text/plain
Date: Tue, 13 Nov 2007 18:05:23 -0800
Message-Id: <1195005923.5163.94.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0-2mdv2008.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Remove defconfig ptr comparison to 0

Remove sparse warning: Using plain integer as NULL pointer

Signed-off-by: Joe Perches <joe@perches.com>

---

diff --git a/fs/nfs/callback_xdr.c b/fs/nfs/callback_xdr.c
index 058ade7..935f145 100644
--- a/fs/nfs/callback_xdr.c
+++ b/fs/nfs/callback_xdr.c
@@ -254,7 +254,7 @@ static __be32 encode_attr_change(struct xdr_stream *xdr, const uint32_t *bitmap,
 	if (!(bitmap[0] & FATTR4_WORD0_CHANGE))
 		return 0;
 	p = xdr_reserve_space(xdr, 8);
-	if (unlikely(p == 0))
+	if (unlikely(!p))
 		return htonl(NFS4ERR_RESOURCE);
 	p = xdr_encode_hyper(p, change);
 	return 0;
@@ -267,7 +267,7 @@ static __be32 encode_attr_size(struct xdr_stream *xdr, const uint32_t *bitmap, u
 	if (!(bitmap[0] & FATTR4_WORD0_SIZE))
 		return 0;
 	p = xdr_reserve_space(xdr, 8);
-	if (unlikely(p == 0))
+	if (unlikely(!p))
 		return htonl(NFS4ERR_RESOURCE);
 	p = xdr_encode_hyper(p, size);
 	return 0;
@@ -278,7 +278,7 @@ static __be32 encode_attr_time(struct xdr_stream *xdr, const struct timespec *ti
 	__be32 *p;
 
 	p = xdr_reserve_space(xdr, 12);
-	if (unlikely(p == 0))
+	if (unlikely(!p))
 		return htonl(NFS4ERR_RESOURCE);
 	p = xdr_encode_hyper(p, time->tv_sec);
 	*p = htonl(time->tv_nsec);
diff --git a/fs/nfs/delegation.c b/fs/nfs/delegation.c
index 11833f4..4e93af2 100644
--- a/fs/nfs/delegation.c
+++ b/fs/nfs/delegation.c
@@ -49,7 +49,7 @@ static int nfs_delegation_claim_locks(struct nfs_open_context *ctx, struct nfs4_
 	struct file_lock *fl;
 	int status;
 
-	for (fl = inode->i_flock; fl != 0; fl = fl->fl_next) {
+	for (fl = inode->i_flock; fl; fl = fl->fl_next) {
 		if (!(fl->fl_flags & (FL_POSIX|FL_FLOCK)))
 			continue;
 		if (nfs_file_open_context(fl->fl_file) != ctx)
diff --git a/fs/nfs/idmap.c b/fs/nfs/idmap.c
index d11eb05..c6d4e70 100644
--- a/fs/nfs/idmap.c
+++ b/fs/nfs/idmap.c
@@ -308,7 +308,7 @@ nfs_idmap_name(struct idmap *idmap, struct idmap_hashtable *h,
 	mutex_lock(&idmap->idmap_im_lock);
 
 	he = idmap_lookup_id(h, id);
-	if (he != 0) {
+	if (he) {
 		memcpy(name, he->ih_name, he->ih_namelen);
 		ret = he->ih_namelen;
 		goto out;
diff --git a/fs/nfs/nfs4state.c b/fs/nfs/nfs4state.c
index 23a9a36..a983637 100644
--- a/fs/nfs/nfs4state.c
+++ b/fs/nfs/nfs4state.c
@@ -781,7 +781,7 @@ static int nfs4_reclaim_locks(struct nfs4_state_recovery_ops *ops, struct nfs4_s
 	struct file_lock *fl;
 	int status = 0;
 
-	for (fl = inode->i_flock; fl != 0; fl = fl->fl_next) {
+	for (fl = inode->i_flock; fl; fl = fl->fl_next) {
 		if (!(fl->fl_flags & (FL_POSIX|FL_FLOCK)))
 			continue;
 		if (nfs_file_open_context(fl->fl_file)->state != state)


