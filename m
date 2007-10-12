Return-Path: <linux-kernel-owner+w=401wt.eu-S1760099AbXJLJIs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760099AbXJLJIs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 05:08:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759471AbXJLJHd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 05:07:33 -0400
Received: from mx1.redhat.com ([66.187.233.31]:41677 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755986AbXJLJHZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 05:07:25 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 02/31] Convert ERR_PTR(PTR_ERR(p)) instances to ERR_CAST(p)
	[try #4]
To: torvalds@osdl.org, akpm@osdl.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       dhowells@redhat.com
Date: Fri, 12 Oct 2007 10:07:19 +0100
Message-ID: <20071012090719.3442.29044.stgit@warthog.procyon.org.uk>
In-Reply-To: <20071012090709.3442.69133.stgit@warthog.procyon.org.uk>
References: <20071012090709.3442.69133.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Convert instances of ERR_PTR(PTR_ERR(p)) to ERR_CAST(p) using:

perl -spi -e 's/ERR_PTR[(]PTR_ERR[(](.*)[)][)]/ERR_CAST(\1)/' `grep -rl 'ERR_PTR[(]*PTR_ERR' fs crypto net security`

Signed-off-by: David Howells <dhowells@redhat.com>
---

 crypto/cbc.c                     |    2 +-
 crypto/cryptd.c                  |    4 ++--
 crypto/ecb.c                     |    2 +-
 crypto/hmac.c                    |    2 +-
 crypto/lrw.c                     |    2 +-
 crypto/pcbc.c                    |    2 +-
 crypto/xcbc.c                    |    4 ++--
 fs/9p/vfs_inode.c                |    2 +-
 fs/affs/namei.c                  |    2 +-
 fs/afs/dir.c                     |    4 ++--
 fs/afs/security.c                |    2 +-
 fs/fat/inode.c                   |    2 +-
 fs/fuse/dir.c                    |    6 +++---
 fs/gfs2/dir.c                    |    2 +-
 fs/gfs2/ops_export.c             |    2 +-
 fs/gfs2/ops_inode.c              |    2 +-
 fs/jffs2/write.c                 |    4 ++--
 fs/nfs/getroot.c                 |    8 ++++----
 fs/nfsd/export.c                 |    4 ++--
 fs/quota.c                       |    4 ++--
 fs/reiserfs/inode.c              |    2 +-
 fs/reiserfs/xattr.c              |    6 +++---
 fs/vfat/namei.c                  |    2 +-
 net/rxrpc/af_rxrpc.c             |    6 +++---
 security/keys/key.c              |    2 +-
 security/keys/process_keys.c     |    2 +-
 security/keys/request_key.c      |    4 ++--
 security/keys/request_key_auth.c |    2 +-
 28 files changed, 44 insertions(+), 44 deletions(-)

diff --git a/crypto/cbc.c b/crypto/cbc.c
index 1f2649e..ea39ba2 100644
--- a/crypto/cbc.c
+++ b/crypto/cbc.c
@@ -288,7 +288,7 @@ static struct crypto_instance *crypto_cbc_alloc(struct rtattr **tb)
 	alg = crypto_get_attr_alg(tb, CRYPTO_ALG_TYPE_CIPHER,
 				  CRYPTO_ALG_TYPE_MASK);
 	if (IS_ERR(alg))
-		return ERR_PTR(PTR_ERR(alg));
+		return ERR_CAST(alg);
 
 	inst = crypto_alloc_instance("cbc", alg);
 	if (IS_ERR(inst))
diff --git a/crypto/cryptd.c b/crypto/cryptd.c
index 8bf2da8..60fad7b 100644
--- a/crypto/cryptd.c
+++ b/crypto/cryptd.c
@@ -230,7 +230,7 @@ static struct crypto_instance *cryptd_alloc_blkcipher(
 	alg = crypto_get_attr_alg(tb, CRYPTO_ALG_TYPE_BLKCIPHER,
 				  CRYPTO_ALG_TYPE_MASK | CRYPTO_ALG_ASYNC);
 	if (IS_ERR(alg))
-		return ERR_PTR(PTR_ERR(alg));
+		return ERR_CAST(alg);
 
 	inst = cryptd_alloc_instance(alg, state);
 	if (IS_ERR(inst))
@@ -265,7 +265,7 @@ static struct crypto_instance *cryptd_alloc(struct rtattr **tb)
 
 	algt = crypto_get_attr_type(tb);
 	if (IS_ERR(algt))
-		return ERR_PTR(PTR_ERR(algt));
+		return ERR_CAST(algt);
 
 	switch (algt->type & algt->mask & CRYPTO_ALG_TYPE_MASK) {
 	case CRYPTO_ALG_TYPE_BLKCIPHER:
diff --git a/crypto/ecb.c b/crypto/ecb.c
index 6310387..a46838e 100644
--- a/crypto/ecb.c
+++ b/crypto/ecb.c
@@ -128,7 +128,7 @@ static struct crypto_instance *crypto_ecb_alloc(struct rtattr **tb)
 	alg = crypto_get_attr_alg(tb, CRYPTO_ALG_TYPE_CIPHER,
 				  CRYPTO_ALG_TYPE_MASK);
 	if (IS_ERR(alg))
-		return ERR_PTR(PTR_ERR(alg));
+		return ERR_CAST(alg);
 
 	inst = crypto_alloc_instance("ecb", alg);
 	if (IS_ERR(inst))
diff --git a/crypto/hmac.c b/crypto/hmac.c
index 8802fb6..bed9e25 100644
--- a/crypto/hmac.c
+++ b/crypto/hmac.c
@@ -210,7 +210,7 @@ static struct crypto_instance *hmac_alloc(struct rtattr **tb)
 	alg = crypto_get_attr_alg(tb, CRYPTO_ALG_TYPE_HASH,
 				  CRYPTO_ALG_TYPE_HASH_MASK);
 	if (IS_ERR(alg))
-		return ERR_PTR(PTR_ERR(alg));
+		return ERR_CAST(alg);
 
 	inst = crypto_alloc_instance("hmac", alg);
 	if (IS_ERR(inst))
diff --git a/crypto/lrw.c b/crypto/lrw.c
index 621095d..9d52e58 100644
--- a/crypto/lrw.c
+++ b/crypto/lrw.c
@@ -241,7 +241,7 @@ static struct crypto_instance *alloc(struct rtattr **tb)
 	alg = crypto_get_attr_alg(tb, CRYPTO_ALG_TYPE_CIPHER,
 				  CRYPTO_ALG_TYPE_MASK);
 	if (IS_ERR(alg))
-		return ERR_PTR(PTR_ERR(alg));
+		return ERR_CAST(alg);
 
 	inst = crypto_alloc_instance("lrw", alg);
 	if (IS_ERR(inst))
diff --git a/crypto/pcbc.c b/crypto/pcbc.c
index c3ed8a1..c04f52a 100644
--- a/crypto/pcbc.c
+++ b/crypto/pcbc.c
@@ -292,7 +292,7 @@ static struct crypto_instance *crypto_pcbc_alloc(struct rtattr **tb)
 	alg = crypto_get_attr_alg(tb, CRYPTO_ALG_TYPE_CIPHER,
 				  CRYPTO_ALG_TYPE_MASK);
 	if (IS_ERR(alg))
-		return ERR_PTR(PTR_ERR(alg));
+		return ERR_CAST(alg);
 
 	inst = crypto_alloc_instance("pcbc", alg);
 	if (IS_ERR(inst))
diff --git a/crypto/xcbc.c b/crypto/xcbc.c
index 9f502b8..da018c1 100644
--- a/crypto/xcbc.c
+++ b/crypto/xcbc.c
@@ -301,13 +301,13 @@ static struct crypto_instance *xcbc_alloc(struct rtattr **tb)
 	alg = crypto_get_attr_alg(tb, CRYPTO_ALG_TYPE_CIPHER,
 				  CRYPTO_ALG_TYPE_MASK);
 	if (IS_ERR(alg))
-		return ERR_PTR(PTR_ERR(alg));
+		return ERR_CAST(alg);
 
 	switch(alg->cra_blocksize) {
 	case 16:
 		break;
 	default:
-		return ERR_PTR(PTR_ERR(alg));
+		return ERR_CAST(alg);
 	}
 
 	inst = crypto_alloc_instance("xcbc", alg);
diff --git a/fs/9p/vfs_inode.c b/fs/9p/vfs_inode.c
index e5c45ee..53444f0 100644
--- a/fs/9p/vfs_inode.c
+++ b/fs/9p/vfs_inode.c
@@ -568,7 +568,7 @@ static struct dentry *v9fs_vfs_lookup(struct inode *dir, struct dentry *dentry,
 	v9ses = v9fs_inode2v9ses(dir);
 	dfid = v9fs_fid_lookup(dentry->d_parent);
 	if (IS_ERR(dfid))
-		return ERR_PTR(PTR_ERR(dfid));
+		return ERR_CAST(dfid);
 
 	name = (char *) dentry->d_name.name;
 	fid = p9_client_walk(dfid, 1, &name, 1);
diff --git a/fs/affs/namei.c b/fs/affs/namei.c
index a42143c..b407e9e 100644
--- a/fs/affs/namei.c
+++ b/fs/affs/namei.c
@@ -209,7 +209,7 @@ affs_lookup(struct inode *dir, struct dentry *dentry, struct nameidata *nd)
 	bh = affs_find_entry(dir, dentry);
 	affs_unlock_dir(dir);
 	if (IS_ERR(bh)) {
-		return ERR_PTR(PTR_ERR(bh));
+		return ERR_CAST(bh);
 	}
 	if (bh) {
 		u32 ino = bh->b_blocknr;
diff --git a/fs/afs/dir.c b/fs/afs/dir.c
index 33fe39a..f861d08 100644
--- a/fs/afs/dir.c
+++ b/fs/afs/dir.c
@@ -512,7 +512,7 @@ static struct dentry *afs_lookup(struct inode *dir, struct dentry *dentry,
 	key = afs_request_key(vnode->volume->cell);
 	if (IS_ERR(key)) {
 		_leave(" = %ld [key]", PTR_ERR(key));
-		return ERR_PTR(PTR_ERR(key));
+		return ERR_CAST(key);
 	}
 
 	ret = afs_validate(vnode, key);
@@ -540,7 +540,7 @@ static struct dentry *afs_lookup(struct inode *dir, struct dentry *dentry,
 	key_put(key);
 	if (IS_ERR(inode)) {
 		_leave(" = %ld", PTR_ERR(inode));
-		return ERR_PTR(PTR_ERR(inode));
+		return ERR_CAST(inode);
 	}
 
 	dentry->d_op = &afs_fs_dentry_operations;
diff --git a/fs/afs/security.c b/fs/afs/security.c
index 566fe71..9446a1f 100644
--- a/fs/afs/security.c
+++ b/fs/afs/security.c
@@ -95,7 +95,7 @@ static struct afs_vnode *afs_get_auth_inode(struct afs_vnode *vnode,
 		auth_inode = afs_iget(vnode->vfs_inode.i_sb, key,
 				      &vnode->status.parent, NULL, NULL);
 		if (IS_ERR(auth_inode))
-			return ERR_PTR(PTR_ERR(auth_inode));
+			return ERR_CAST(auth_inode);
 	}
 
 	auth_vnode = AFS_FS_I(auth_inode);
diff --git a/fs/fat/inode.c b/fs/fat/inode.c
index 4baa5f2..960ed3d 100644
--- a/fs/fat/inode.c
+++ b/fs/fat/inode.c
@@ -764,7 +764,7 @@ static struct dentry *fat_get_parent(struct dentry *child)
 	inode = fat_build_inode(child->d_sb, de, i_pos);
 	brelse(bh);
 	if (IS_ERR(inode)) {
-		parent = ERR_PTR(PTR_ERR(inode));
+		parent = ERR_CAST(inode);
 		goto out;
 	}
 	parent = d_alloc_anon(inode);
diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
index bd5a772..69ce097 100644
--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -234,12 +234,12 @@ static struct dentry *fuse_lookup(struct inode *dir, struct dentry *entry,
 
 	req = fuse_get_req(fc);
 	if (IS_ERR(req))
-		return ERR_PTR(PTR_ERR(req));
+		return ERR_CAST(req);
 
 	forget_req = fuse_get_req(fc);
 	if (IS_ERR(forget_req)) {
 		fuse_put_request(fc, req);
-		return ERR_PTR(PTR_ERR(forget_req));
+		return ERR_CAST(forget_req);
 	}
 
 	fuse_lookup_init(req, dir, entry, &outarg);
@@ -897,7 +897,7 @@ static char *read_link(struct dentry *dentry)
 	char *link;
 
 	if (IS_ERR(req))
-		return ERR_PTR(PTR_ERR(req));
+		return ERR_CAST(req);
 
 	link = (char *) __get_free_page(GFP_KERNEL);
 	if (!link) {
diff --git a/fs/gfs2/dir.c b/fs/gfs2/dir.c
index 2beb2f4..7c7b437 100644
--- a/fs/gfs2/dir.c
+++ b/fs/gfs2/dir.c
@@ -1497,7 +1497,7 @@ struct inode *gfs2_dir_search(struct inode *dir, const struct qstr *name)
 	dent = gfs2_dirent_search(dir, name, gfs2_dirent_find, &bh);
 	if (dent) {
 		if (IS_ERR(dent))
-			return ERR_PTR(PTR_ERR(dent));
+			return ERR_CAST(dent);
 		inode = gfs2_inode_lookup(dir->i_sb, 
 				be16_to_cpu(dent->de_type),
 				be64_to_cpu(dent->de_inum.no_addr),
diff --git a/fs/gfs2/ops_export.c b/fs/gfs2/ops_export.c
index b8312ed..549c35d 100644
--- a/fs/gfs2/ops_export.c
+++ b/fs/gfs2/ops_export.c
@@ -177,7 +177,7 @@ static struct dentry *gfs2_get_parent(struct dentry *child)
 	 * have to return that as a(n invalid) pointer to dentry.
 	 */
 	if (IS_ERR(inode))
-		return ERR_PTR(PTR_ERR(inode));
+		return ERR_CAST(inode);
 
 	dentry = d_alloc_anon(inode);
 	if (!dentry) {
diff --git a/fs/gfs2/ops_inode.c b/fs/gfs2/ops_inode.c
index 911c115..c49d3d8 100644
--- a/fs/gfs2/ops_inode.c
+++ b/fs/gfs2/ops_inode.c
@@ -111,7 +111,7 @@ static struct dentry *gfs2_lookup(struct inode *dir, struct dentry *dentry,
 
 	inode = gfs2_lookupi(dir, &dentry->d_name, 0, nd);
 	if (inode && IS_ERR(inode))
-		return ERR_PTR(PTR_ERR(inode));
+		return ERR_CAST(inode);
 
 	if (inode)
 		return d_splice_alias(inode, dentry);
diff --git a/fs/jffs2/write.c b/fs/jffs2/write.c
index 664c164..6daf299 100644
--- a/fs/jffs2/write.c
+++ b/fs/jffs2/write.c
@@ -177,7 +177,7 @@ struct jffs2_full_dnode *jffs2_write_dnode(struct jffs2_sb_info *c, struct jffs2
 		void *hold_err = fn->raw;
 		/* Release the full_dnode which is now useless, and return */
 		jffs2_free_full_dnode(fn);
-		return ERR_PTR(PTR_ERR(hold_err));
+		return ERR_CAST(hold_err);
 	}
 	fn->ofs = je32_to_cpu(ri->offset);
 	fn->size = je32_to_cpu(ri->dsize);
@@ -302,7 +302,7 @@ struct jffs2_full_dirent *jffs2_write_dirent(struct jffs2_sb_info *c, struct jff
 		void *hold_err = fd->raw;
 		/* Release the full_dirent which is now useless, and return */
 		jffs2_free_full_dirent(fd);
-		return ERR_PTR(PTR_ERR(hold_err));
+		return ERR_CAST(hold_err);
 	}
 
 	if (retried) {
diff --git a/fs/nfs/getroot.c b/fs/nfs/getroot.c
index 522e5ad..93d1479 100644
--- a/fs/nfs/getroot.c
+++ b/fs/nfs/getroot.c
@@ -70,7 +70,7 @@ struct dentry *nfs_get_root(struct super_block *sb, struct nfs_fh *mntfh)
 
 		iroot = nfs_fhget(sb, &dummyfh, &fattr);
 		if (IS_ERR(iroot))
-			return ERR_PTR(PTR_ERR(iroot));
+			return ERR_CAST(iroot);
 
 		root = d_alloc_root(iroot);
 		if (!root) {
@@ -93,7 +93,7 @@ struct dentry *nfs_get_root(struct super_block *sb, struct nfs_fh *mntfh)
 	inode = nfs_fhget(sb, mntfh, fsinfo.fattr);
 	if (IS_ERR(inode)) {
 		dprintk("nfs_get_root: get root inode failed\n");
-		return ERR_PTR(PTR_ERR(inode));
+		return ERR_CAST(inode);
 	}
 
 	/* root dentries normally start off anonymous and get spliced in later
@@ -257,7 +257,7 @@ struct dentry *nfs4_get_root(struct super_block *sb, struct nfs_fh *mntfh)
 
 		iroot = nfs_fhget(sb, &dummyfh, &fattr);
 		if (IS_ERR(iroot))
-			return ERR_PTR(PTR_ERR(iroot));
+			return ERR_CAST(iroot);
 
 		root = d_alloc_root(iroot);
 		if (!root) {
@@ -286,7 +286,7 @@ struct dentry *nfs4_get_root(struct super_block *sb, struct nfs_fh *mntfh)
 	inode = nfs_fhget(sb, mntfh, &fattr);
 	if (IS_ERR(inode)) {
 		dprintk("nfs_get_root: get root inode failed\n");
-		return ERR_PTR(PTR_ERR(inode));
+		return ERR_CAST(inode);
 	}
 
 	/* root dentries normally start off anonymous and get spliced in later
diff --git a/fs/nfsd/export.c b/fs/nfsd/export.c
index cba899a..9feaec6 100644
--- a/fs/nfsd/export.c
+++ b/fs/nfsd/export.c
@@ -1221,13 +1221,13 @@ exp_find(struct auth_domain *clp, int fsid_type, u32 *fsidv,
 	struct svc_export *exp;
 	struct svc_expkey *ek = exp_find_key(clp, fsid_type, fsidv, reqp);
 	if (IS_ERR(ek))
-		return ERR_PTR(PTR_ERR(ek));
+		return ERR_CAST(ek);
 
 	exp = exp_get_by_name(clp, ek->ek_mnt, ek->ek_dentry, reqp);
 	cache_put(&ek->h, &svc_expkey_cache);
 
 	if (IS_ERR(exp))
-		return ERR_PTR(PTR_ERR(exp));
+		return ERR_CAST(exp);
 	return exp;
 }
 
diff --git a/fs/quota.c b/fs/quota.c
index 99b24b5..84f28dd 100644
--- a/fs/quota.c
+++ b/fs/quota.c
@@ -341,11 +341,11 @@ static inline struct super_block *quotactl_block(const char __user *special)
 	char *tmp = getname(special);
 
 	if (IS_ERR(tmp))
-		return ERR_PTR(PTR_ERR(tmp));
+		return ERR_CAST(tmp);
 	bdev = lookup_bdev(tmp);
 	putname(tmp);
 	if (IS_ERR(bdev))
-		return ERR_PTR(PTR_ERR(bdev));
+		return ERR_CAST(bdev);
 	sb = get_super(bdev);
 	bdput(bdev);
 	if (!sb)
diff --git a/fs/reiserfs/inode.c b/fs/reiserfs/inode.c
index ddde489..496fbe3 100644
--- a/fs/reiserfs/inode.c
+++ b/fs/reiserfs/inode.c
@@ -1534,7 +1534,7 @@ struct dentry *reiserfs_get_dentry(struct super_block *sb, void *vobjp)
 	if (!inode)
 		inode = ERR_PTR(-ESTALE);
 	if (IS_ERR(inode))
-		return ERR_PTR(PTR_ERR(inode));
+		return ERR_CAST(inode);
 	result = d_alloc_anon(inode);
 	if (!result) {
 		iput(inode);
diff --git a/fs/reiserfs/xattr.c b/fs/reiserfs/xattr.c
index bf6e582..624ddd4 100644
--- a/fs/reiserfs/xattr.c
+++ b/fs/reiserfs/xattr.c
@@ -155,7 +155,7 @@ static struct dentry *get_xa_file_dentry(const struct inode *inode,
 
 	xadir = open_xa_dir(inode, flags);
 	if (IS_ERR(xadir)) {
-		return ERR_PTR(PTR_ERR(xadir));
+		return ERR_CAST(xadir);
 	} else if (xadir && !xadir->d_inode) {
 		dput(xadir);
 		return ERR_PTR(-ENODATA);
@@ -164,7 +164,7 @@ static struct dentry *get_xa_file_dentry(const struct inode *inode,
 	xafile = lookup_one_len(name, xadir, strlen(name));
 	if (IS_ERR(xafile)) {
 		dput(xadir);
-		return ERR_PTR(PTR_ERR(xafile));
+		return ERR_CAST(xafile);
 	}
 
 	if (xafile->d_inode) {	/* file exists */
@@ -203,7 +203,7 @@ static struct file *open_xa_file(const struct inode *inode, const char *name,
 
 	xafile = get_xa_file_dentry(inode, name, flags);
 	if (IS_ERR(xafile))
-		return ERR_PTR(PTR_ERR(xafile));
+		return ERR_CAST(xafile);
 	else if (!xafile->d_inode) {
 		dput(xafile);
 		return ERR_PTR(-ENODATA);
diff --git a/fs/vfat/namei.c b/fs/vfat/namei.c
index c28add2..cd450be 100644
--- a/fs/vfat/namei.c
+++ b/fs/vfat/namei.c
@@ -705,7 +705,7 @@ static struct dentry *vfat_lookup(struct inode *dir, struct dentry *dentry,
 	brelse(sinfo.bh);
 	if (IS_ERR(inode)) {
 		unlock_kernel();
-		return ERR_PTR(PTR_ERR(inode));
+		return ERR_CAST(inode);
 	}
 	alias = d_find_alias(inode);
 	if (alias) {
diff --git a/net/rxrpc/af_rxrpc.c b/net/rxrpc/af_rxrpc.c
index 0803f30..1fd530a 100644
--- a/net/rxrpc/af_rxrpc.c
+++ b/net/rxrpc/af_rxrpc.c
@@ -238,7 +238,7 @@ static struct rxrpc_transport *rxrpc_name_to_transport(struct socket *sock,
 	/* find a remote transport endpoint from the local one */
 	peer = rxrpc_get_peer(srx, gfp);
 	if (IS_ERR(peer))
-		return ERR_PTR(PTR_ERR(peer));
+		return ERR_CAST(peer);
 
 	/* find a transport */
 	trans = rxrpc_get_transport(rx->local, peer, gfp);
@@ -281,7 +281,7 @@ struct rxrpc_call *rxrpc_kernel_begin_call(struct socket *sock,
 		trans = rxrpc_name_to_transport(sock, (struct sockaddr *) srx,
 						sizeof(*srx), 0, gfp);
 		if (IS_ERR(trans)) {
-			call = ERR_PTR(PTR_ERR(trans));
+			call = ERR_CAST(trans);
 			trans = NULL;
 			goto out;
 		}
@@ -305,7 +305,7 @@ struct rxrpc_call *rxrpc_kernel_begin_call(struct socket *sock,
 
 	bundle = rxrpc_get_bundle(rx, trans, key, service_id, gfp);
 	if (IS_ERR(bundle)) {
-		call = ERR_PTR(PTR_ERR(bundle));
+		call = ERR_CAST(bundle);
 		goto out;
 	}
 
diff --git a/security/keys/key.c b/security/keys/key.c
index 01bbc6d..abe9245 100644
--- a/security/keys/key.c
+++ b/security/keys/key.c
@@ -820,7 +820,7 @@ key_ref_t key_create_or_update(key_ref_t keyring_ref,
 	key = key_alloc(ktype, description, current->fsuid, current->fsgid,
 			current, perm, flags);
 	if (IS_ERR(key)) {
-		key_ref = ERR_PTR(PTR_ERR(key));
+		key_ref = ERR_CAST(key);
 		goto error_3;
 	}
 
diff --git a/security/keys/process_keys.c b/security/keys/process_keys.c
index b6f8680..67c1341 100644
--- a/security/keys/process_keys.c
+++ b/security/keys/process_keys.c
@@ -660,7 +660,7 @@ key_ref_t lookup_user_key(struct task_struct *context, key_serial_t id,
 
 		key = key_lookup(id);
 		if (IS_ERR(key)) {
-			key_ref = ERR_PTR(PTR_ERR(key));
+			key_ref = ERR_CAST(key);
 			goto error;
 		}
 
diff --git a/security/keys/request_key.c b/security/keys/request_key.c
index 5575001..9251e6a 100644
--- a/security/keys/request_key.c
+++ b/security/keys/request_key.c
@@ -418,7 +418,7 @@ struct key *request_key_and_link(struct key_type *type,
 		key = key_ref_to_ptr(key_ref);
 	}
 	else if (PTR_ERR(key_ref) != -EAGAIN) {
-		key = ERR_PTR(PTR_ERR(key_ref));
+		key = ERR_CAST(key_ref);
 	}
 	else  {
 		/* the search failed, but the keyrings were searchable, so we
@@ -458,7 +458,7 @@ struct key *request_key_and_link(struct key_type *type,
 			}
 
 			if (PTR_ERR(key_ref) != -EAGAIN) {
-				key = ERR_PTR(PTR_ERR(key_ref));
+				key = ERR_CAST(key_ref);
 				break;
 			}
 		}
diff --git a/security/keys/request_key_auth.c b/security/keys/request_key_auth.c
index cbf58a9..fcfe408 100644
--- a/security/keys/request_key_auth.c
+++ b/security/keys/request_key_auth.c
@@ -252,7 +252,7 @@ struct key *key_get_instantiation_authkey(key_serial_t target_id)
 		current);
 
 	if (IS_ERR(authkey_ref)) {
-		authkey = ERR_PTR(PTR_ERR(authkey_ref));
+		authkey = ERR_CAST(authkey_ref);
 		goto error;
 	}
 

