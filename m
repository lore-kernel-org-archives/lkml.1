Return-Path: <linux-kernel-owner+w=401wt.eu-S1760080AbXEQTvd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760080AbXEQTvd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 15:51:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758827AbXEQTvX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 15:51:23 -0400
Received: from pat.uio.no ([129.240.10.15]:38316 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758574AbXEQTvT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 15:51:19 -0400
Subject: [GIT] Please pull the following bugfixes for the NFS client
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: nfs@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Christoph Hellwig <hch@lst.de>, Nate Diller <nate.diller@gmail.com>,
       Oleg Nesterov <oleg@tv-sign.ru>
Content-Type: text/plain; charset=UTF-8
Date: Thu, 17 May 2007 15:51:04 -0400
Message-Id: <1179431464.15508.23.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 8BIT
X-UiO-Resend: resent
X-UiO-Spam-info: not spam, SpamAssassin (score=-0.1, required=12.0, autolearn=disabled, AWL=-0.133)
X-UiO-Scanned: BDF6FEA8A4027E5CA47D494FD40B0A96326FBF7C
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: 0 maxlevel 200 minaction 2 bait 0 mail/h: 378 total 1791177 max/h 8345 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from the repository at

   git pull git://git.linux-nfs.org/pub/linux/nfs-2.6.git

This will update the following files through the appended changesets.

  Cheers,
    Trond

----
 fs/lockd/clntlock.c                |    2 +-
 fs/lockd/host.c                    |    2 +-
 fs/lockd/xdr.c                     |    4 --
 fs/lockd/xdr4.c                    |    6 ++-
 fs/nfs/callback.h                  |    4 +-
 fs/nfs/delegation.c                |    2 +-
 fs/nfs/dir.c                       |    4 +-
 fs/nfs/nfs4proc.c                  |    4 +-
 fs/nfs/nfs4state.c                 |    2 +-
 fs/nfs/nfs4xdr.c                   |   96 ++++++++++++++++++------------------
 fs/nfs/read.c                      |   10 ++--
 fs/nfs/write.c                     |    6 +-
 include/linux/lockd/xdr4.h         |    1 +
 include/linux/nfs4.h               |    3 +-
 include/linux/sunrpc/rpc_pipe_fs.h |    2 +
 include/linux/sunrpc/xprt.h        |    2 +
 net/sunrpc/sched.c                 |    2 -
 net/sunrpc/sunrpc_syms.c           |    4 --
 18 files changed, 77 insertions(+), 79 deletions(-)

commit 7531d692d4174789d583eb50fcb83cefa121b790
Author: Trond Myklebust <Trond.Myklebust@netapp.com>
Date:   Mon May 14 17:21:26 2007 -0400

    SUNRPC: Fix sparse warnings
    
     - net/sunrpc/xprtsock.c:1635:5: warning: symbol 'init_socket_xprt' was not
       declared. Should it be static?
     - net/sunrpc/xprtsock.c:1649:6: warning: symbol 'cleanup_socket_xprt' was
       not declared. Should it be static?
    
    Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>

commit d48c5f41000ad176df71d2d43932c6c50f938196
Author: Trond Myklebust <Trond.Myklebust@netapp.com>
Date:   Mon May 14 17:21:26 2007 -0400

    NLM: Fix sparse warnings
    
     - fs/lockd/xdr4.c:140:27: warning: incorrect type in argument 2 (different
       explicit signedness)
     - fs/lockd/xdr4.c:141:27: warning: incorrect type in argument 2 (different
       explicit signedness)
     - fs/lockd/xdr4.c:432:28: warning: incorrect type in argument 2 (different
       explicit signedness)
     - fs/lockd/xdr4.c:433:28: warning: incorrect type in argument 2 (different
       explicit signedness)
     - fs/lockd/xdr4.c:587:20: warning: symbol 'nlm_version4' was not declared.
       Should it be static?
    
    Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>

commit 2e42c3e2aec6e24e58c4c601e1a33f0e9e36e314
Author: Trond Myklebust <Trond.Myklebust@netapp.com>
Date:   Mon May 14 17:20:41 2007 -0400

    NFS: Fix more sparse warnings
    
     - fs/nfs/nfs4xdr.c:2499:42: warning: incorrect type in argument 2
       (different signedness)
     - fs/nfs/nfs4xdr.c:2658:49: warning: incorrect type in argument 4
       (different explicit signedness)
     - fs/nfs/nfs4xdr.c:2683:50: warning: incorrect type in argument 4
       (different explicit signedness)
     - fs/nfs/nfs4xdr.c:3063:68: warning: incorrect type in argument 4
       (different explicit signedness)
     - fs/nfs/nfs4xdr.c:3065:68: warning: incorrect type in argument 4
       (different explicit signedness)
    
     - fs/nfs/callback_xdr.c:138:31: warning: incorrect type in argument 2
       (different signedness)
    
    Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>

commit 10afec9081fee7e48995fa396fba22c7de4b99d4
Author: Trond Myklebust <Trond.Myklebust@netapp.com>
Date:   Mon May 14 17:16:04 2007 -0400

    NFS: Fix some 'sparse' warnings...
    
     - fs/nfs/dir.c:610:8: warning: symbol 'nfs_llseek_dir' was not declared.
       Should it be static?
     - fs/nfs/dir.c:636:5: warning: symbol 'nfs_fsync_dir' was not declared.
       Should it be static?
     - fs/nfs/write.c:925:19: warning: symbol 'req' shadows an earlier one
     - fs/nfs/write.c:61:6: warning: symbol 'nfs_commit_rcu_free' was not
       declared. Should it be static?
     - fs/nfs/nfs4proc.c:793:5: warning: symbol 'nfs4_recover_expired_lease'
       was not declared. Should it be static?
    
    Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>

commit 9c9cc93ad2a5d9972672e03685af20e8cea1e5a4
Author: Christoph Hellwig <hch@infradead.org>
Date:   Fri Feb 9 20:06:49 2007 +0000

    SUNRPC: remove dead variable 'rpciod_running'
    
    rpciod_running is not used at all, but due to the way DECLARE_MUTEX_LOCKED
    works we don't get a warning for it.
    
    
    Signed-off-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>

commit 8ae20abdd18c6c7f21bbae931353e7cfad77d7b6
Author: Trond Myklebust <Trond.Myklebust@netapp.com>
Date:   Mon May 14 16:50:45 2007 -0400

    NFS4: Fix incorrect use of sizeof() in fs/nfs/nfs4xdr.c
    
    The XDR code should not depend on the physical allocation size of
    structures like nfs4_stateid and nfs4_verifier since those may have to
    change at some future date. We therefore replace all uses of
    sizeof() with constants like NFS4_VERIFIER_SIZE and NFS4_STATEID_SIZE.
    
    This also has the side-effect of fixing some warnings of the type
    	format ‘%u’ expects type ‘unsigned int’, but argument X has type
    		‘long unsigned int’
    on 64-bit systems
    
    Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>

commit 60945cb7c8377b727288275f21791914fe65311c
Author: Nate Diller <nate.diller@gmail.com>
Date:   Thu May 10 22:55:08 2007 -0700

    NFS: use zero_user_page
    
    Use zero_user_page() instead of the newly deprecated memclear_highpage_flush().
    
    Signed-off-by: Nate Diller <nate.diller@gmail.com>
    Cc: Trond Myklebust <trond.myklebust@fys.uio.no>
    Cc: "J. Bruce Fields" <bfields@fieldses.org>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>

commit 550facd138d8f6b0ca683c1e894b5cd0f381cb63
Author: Oleg Nesterov <oleg@tv-sign.ru>
Date:   Thu May 10 22:55:07 2007 -0700

    NLM: don't use CLONE_SIGHAND in nlmclnt_recovery
    
    reclaimer() calls allow_signal() which plays with parent process's ->sighand.
    
    Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
    Cc: Trond Myklebust <trond.myklebust@fys.uio.no>
    Cc: "J. Bruce Fields" <bfields@fieldses.org>
    Cc: Neil Brown <neilb@suse.de>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>

commit 21051ba6259c519e20a7d575ddceb16e84ad2a5d
Author: Trond Myklebust <Trond.Myklebust@netapp.com>
Date:   Mon May 14 16:50:44 2007 -0400

    NLM: Fix locking client timeouts...
    
    nlmsvc_timeout is already in units of HZ...
    
    Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>

diff --git a/fs/lockd/clntlock.c b/fs/lockd/clntlock.c
index f4d45d4..d070b18 100644
--- a/fs/lockd/clntlock.c
+++ b/fs/lockd/clntlock.c
@@ -153,7 +153,7 @@ nlmclnt_recovery(struct nlm_host *host)
 	if (!host->h_reclaiming++) {
 		nlm_get_host(host);
 		__module_get(THIS_MODULE);
-		if (kernel_thread(reclaimer, host, CLONE_KERNEL) < 0)
+		if (kernel_thread(reclaimer, host, CLONE_FS | CLONE_FILES) < 0)
 			module_put(THIS_MODULE);
 	}
 }
diff --git a/fs/lockd/host.c b/fs/lockd/host.c
index ad21c07..96070bf 100644
--- a/fs/lockd/host.c
+++ b/fs/lockd/host.c
@@ -221,7 +221,7 @@ nlm_bind_host(struct nlm_host *host)
 					host->h_nextrebind - jiffies);
 		}
 	} else {
-		unsigned long increment = nlmsvc_timeout * HZ;
+		unsigned long increment = nlmsvc_timeout;
 		struct rpc_timeout timeparms = {
 			.to_initval	= increment,
 			.to_increment	= increment,
diff --git a/fs/lockd/xdr.c b/fs/lockd/xdr.c
index 9702956..5316e30 100644
--- a/fs/lockd/xdr.c
+++ b/fs/lockd/xdr.c
@@ -586,10 +586,6 @@ static struct rpc_version	nlm_version3 = {
 		.procs		= nlm_procedures,
 };
 
-#ifdef 	CONFIG_LOCKD_V4
-extern struct rpc_version nlm_version4;
-#endif
-
 static struct rpc_version *	nlm_versions[] = {
 	[1] = &nlm_version1,
 	[3] = &nlm_version3,
diff --git a/fs/lockd/xdr4.c b/fs/lockd/xdr4.c
index ce1efdb..846fc1d 100644
--- a/fs/lockd/xdr4.c
+++ b/fs/lockd/xdr4.c
@@ -123,7 +123,8 @@ static __be32 *
 nlm4_decode_lock(__be32 *p, struct nlm_lock *lock)
 {
 	struct file_lock	*fl = &lock->fl;
-	__s64			len, start, end;
+	__u64			len, start;
+	__s64			end;
 
 	if (!(p = xdr_decode_string_inplace(p, &lock->caller,
 					    &lock->len, NLM_MAXSTRLEN))
@@ -417,7 +418,8 @@ nlm4clt_decode_testres(struct rpc_rqst *req, __be32 *p, struct nlm_res *resp)
 	if (resp->status == nlm_lck_denied) {
 		struct file_lock	*fl = &resp->lock.fl;
 		u32			excl;
-		s64			start, end, len;
+		__u64			start, len;
+		__s64			end;
 
 		memset(&resp->lock, 0, sizeof(resp->lock));
 		locks_init_lock(fl);
diff --git a/fs/nfs/callback.h b/fs/nfs/callback.h
index db3d791..c2bb14e 100644
--- a/fs/nfs/callback.h
+++ b/fs/nfs/callback.h
@@ -24,7 +24,7 @@ enum nfs4_callback_opnum {
 };
 
 struct cb_compound_hdr_arg {
-	int taglen;
+	unsigned int taglen;
 	const char *tag;
 	unsigned int callback_ident;
 	unsigned nops;
@@ -32,7 +32,7 @@ struct cb_compound_hdr_arg {
 
 struct cb_compound_hdr_res {
 	__be32 *status;
-	int taglen;
+	unsigned int taglen;
 	const char *tag;
 	__be32 *nops;
 };
diff --git a/fs/nfs/delegation.c b/fs/nfs/delegation.c
index 841c99a..7f37d1b 100644
--- a/fs/nfs/delegation.c
+++ b/fs/nfs/delegation.c
@@ -226,7 +226,7 @@ restart:
 	spin_unlock(&clp->cl_lock);
 }
 
-int nfs_do_expire_all_delegations(void *ptr)
+static int nfs_do_expire_all_delegations(void *ptr)
 {
 	struct nfs_client *clp = ptr;
 	struct nfs_delegation *delegation;
diff --git a/fs/nfs/dir.c b/fs/nfs/dir.c
index 3df4288..ac92e45 100644
--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -607,7 +607,7 @@ static int nfs_readdir(struct file *filp, void *dirent, filldir_t filldir)
 	return res;
 }
 
-loff_t nfs_llseek_dir(struct file *filp, loff_t offset, int origin)
+static loff_t nfs_llseek_dir(struct file *filp, loff_t offset, int origin)
 {
 	mutex_lock(&filp->f_path.dentry->d_inode->i_mutex);
 	switch (origin) {
@@ -633,7 +633,7 @@ out:
  * All directory operations under NFS are synchronous, so fsync()
  * is a dummy operation.
  */
-int nfs_fsync_dir(struct file *filp, struct dentry *dentry, int datasync)
+static int nfs_fsync_dir(struct file *filp, struct dentry *dentry, int datasync)
 {
 	dfprintk(VFS, "NFS: fsync_dir(%s/%s) datasync %d\n",
 			dentry->d_parent->d_name.name, dentry->d_name.name,
diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index d6a30e9..648e0ac 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -790,7 +790,7 @@ out:
 	return -EACCES;
 }
 
-int nfs4_recover_expired_lease(struct nfs_server *server)
+static int nfs4_recover_expired_lease(struct nfs_server *server)
 {
 	struct nfs_client *clp = server->nfs_client;
 	int ret;
@@ -2748,7 +2748,7 @@ static int nfs4_delay(struct rpc_clnt *clnt, long *timeout)
 /* This is the error handling routine for processes that are allowed
  * to sleep.
  */
-int nfs4_handle_exception(const struct nfs_server *server, int errorcode, struct nfs4_exception *exception)
+static int nfs4_handle_exception(const struct nfs_server *server, int errorcode, struct nfs4_exception *exception)
 {
 	struct nfs_client *clp = server->nfs_client;
 	int ret = errorcode;
diff --git a/fs/nfs/nfs4state.c b/fs/nfs/nfs4state.c
index 5fffbdf..8ed79d5 100644
--- a/fs/nfs/nfs4state.c
+++ b/fs/nfs/nfs4state.c
@@ -104,7 +104,7 @@ struct rpc_cred *nfs4_get_renew_cred(struct nfs_client *clp)
 	return cred;
 }
 
-struct rpc_cred *nfs4_get_setclientid_cred(struct nfs_client *clp)
+static struct rpc_cred *nfs4_get_setclientid_cred(struct nfs_client *clp)
 {
 	struct nfs4_state_owner *sp;
 
diff --git a/fs/nfs/nfs4xdr.c b/fs/nfs/nfs4xdr.c
index 938f371..8003c91 100644
--- a/fs/nfs/nfs4xdr.c
+++ b/fs/nfs/nfs4xdr.c
@@ -646,10 +646,10 @@ static int encode_close(struct xdr_stream *xdr, const struct nfs_closeargs *arg)
 {
 	__be32 *p;
 
-	RESERVE_SPACE(8+sizeof(arg->stateid->data));
+	RESERVE_SPACE(8+NFS4_STATEID_SIZE);
 	WRITE32(OP_CLOSE);
 	WRITE32(arg->seqid->sequence->counter);
-	WRITEMEM(arg->stateid->data, sizeof(arg->stateid->data));
+	WRITEMEM(arg->stateid->data, NFS4_STATEID_SIZE);
 	
 	return 0;
 }
@@ -793,17 +793,17 @@ static int encode_lock(struct xdr_stream *xdr, const struct nfs_lock_args *args)
 	WRITE64(nfs4_lock_length(args->fl));
 	WRITE32(args->new_lock_owner);
 	if (args->new_lock_owner){
-		RESERVE_SPACE(40);
+		RESERVE_SPACE(4+NFS4_STATEID_SIZE+20);
 		WRITE32(args->open_seqid->sequence->counter);
-		WRITEMEM(args->open_stateid->data, sizeof(args->open_stateid->data));
+		WRITEMEM(args->open_stateid->data, NFS4_STATEID_SIZE);
 		WRITE32(args->lock_seqid->sequence->counter);
 		WRITE64(args->lock_owner.clientid);
 		WRITE32(4);
 		WRITE32(args->lock_owner.id);
 	}
 	else {
-		RESERVE_SPACE(20);
-		WRITEMEM(args->lock_stateid->data, sizeof(args->lock_stateid->data));
+		RESERVE_SPACE(NFS4_STATEID_SIZE+4);
+		WRITEMEM(args->lock_stateid->data, NFS4_STATEID_SIZE);
 		WRITE32(args->lock_seqid->sequence->counter);
 	}
 
@@ -830,11 +830,11 @@ static int encode_locku(struct xdr_stream *xdr, const struct nfs_locku_args *arg
 {
 	__be32 *p;
 
-	RESERVE_SPACE(44);
+	RESERVE_SPACE(12+NFS4_STATEID_SIZE+16);
 	WRITE32(OP_LOCKU);
 	WRITE32(nfs4_lock_type(args->fl, 0));
 	WRITE32(args->seqid->sequence->counter);
-	WRITEMEM(args->stateid->data, sizeof(args->stateid->data));
+	WRITEMEM(args->stateid->data, NFS4_STATEID_SIZE);
 	WRITE64(args->fl->fl_start);
 	WRITE64(nfs4_lock_length(args->fl));
 
@@ -966,9 +966,9 @@ static inline void encode_claim_delegate_cur(struct xdr_stream *xdr, const struc
 {
 	__be32 *p;
 
-	RESERVE_SPACE(4+sizeof(stateid->data));
+	RESERVE_SPACE(4+NFS4_STATEID_SIZE);
 	WRITE32(NFS4_OPEN_CLAIM_DELEGATE_CUR);
-	WRITEMEM(stateid->data, sizeof(stateid->data));
+	WRITEMEM(stateid->data, NFS4_STATEID_SIZE);
 	encode_string(xdr, name->len, name->name);
 }
 
@@ -996,9 +996,9 @@ static int encode_open_confirm(struct xdr_stream *xdr, const struct nfs_open_con
 {
 	__be32 *p;
 
-	RESERVE_SPACE(8+sizeof(arg->stateid->data));
+	RESERVE_SPACE(4+NFS4_STATEID_SIZE+4);
 	WRITE32(OP_OPEN_CONFIRM);
-	WRITEMEM(arg->stateid->data, sizeof(arg->stateid->data));
+	WRITEMEM(arg->stateid->data, NFS4_STATEID_SIZE);
 	WRITE32(arg->seqid->sequence->counter);
 
 	return 0;
@@ -1008,9 +1008,9 @@ static int encode_open_downgrade(struct xdr_stream *xdr, const struct nfs_closea
 {
 	__be32 *p;
 
-	RESERVE_SPACE(8+sizeof(arg->stateid->data));
+	RESERVE_SPACE(4+NFS4_STATEID_SIZE+4);
 	WRITE32(OP_OPEN_DOWNGRADE);
-	WRITEMEM(arg->stateid->data, sizeof(arg->stateid->data));
+	WRITEMEM(arg->stateid->data, NFS4_STATEID_SIZE);
 	WRITE32(arg->seqid->sequence->counter);
 	encode_share_access(xdr, arg->open_flags);
 	return 0;
@@ -1045,12 +1045,12 @@ static void encode_stateid(struct xdr_stream *xdr, const struct nfs_open_context
 	nfs4_stateid stateid;
 	__be32 *p;
 
-	RESERVE_SPACE(16);
+	RESERVE_SPACE(NFS4_STATEID_SIZE);
 	if (ctx->state != NULL) {
 		nfs4_copy_stateid(&stateid, ctx->state, ctx->lockowner);
-		WRITEMEM(stateid.data, sizeof(stateid.data));
+		WRITEMEM(stateid.data, NFS4_STATEID_SIZE);
 	} else
-		WRITEMEM(zero_stateid.data, sizeof(zero_stateid.data));
+		WRITEMEM(zero_stateid.data, NFS4_STATEID_SIZE);
 }
 
 static int encode_read(struct xdr_stream *xdr, const struct nfs_readargs *args)
@@ -1079,10 +1079,10 @@ static int encode_readdir(struct xdr_stream *xdr, const struct nfs4_readdir_arg
 	int replen;
 	__be32 *p;
 
-	RESERVE_SPACE(32+sizeof(nfs4_verifier));
+	RESERVE_SPACE(12+NFS4_VERIFIER_SIZE+20);
 	WRITE32(OP_READDIR);
 	WRITE64(readdir->cookie);
-	WRITEMEM(readdir->verifier.data, sizeof(readdir->verifier.data));
+	WRITEMEM(readdir->verifier.data, NFS4_VERIFIER_SIZE);
 	WRITE32(readdir->count >> 1);  /* We're not doing readdirplus */
 	WRITE32(readdir->count);
 	WRITE32(2);
@@ -1190,9 +1190,9 @@ encode_setacl(struct xdr_stream *xdr, struct nfs_setaclargs *arg)
 {
 	__be32 *p;
 
-	RESERVE_SPACE(4+sizeof(zero_stateid.data));
+	RESERVE_SPACE(4+NFS4_STATEID_SIZE);
 	WRITE32(OP_SETATTR);
-	WRITEMEM(zero_stateid.data, sizeof(zero_stateid.data));
+	WRITEMEM(zero_stateid.data, NFS4_STATEID_SIZE);
 	RESERVE_SPACE(2*4);
 	WRITE32(1);
 	WRITE32(FATTR4_WORD0_ACL);
@@ -1220,9 +1220,9 @@ static int encode_setattr(struct xdr_stream *xdr, const struct nfs_setattrargs *
 	int status;
 	__be32 *p;
 	
-        RESERVE_SPACE(4+sizeof(arg->stateid.data));
+        RESERVE_SPACE(4+NFS4_STATEID_SIZE);
         WRITE32(OP_SETATTR);
-	WRITEMEM(arg->stateid.data, sizeof(arg->stateid.data));
+	WRITEMEM(arg->stateid.data, NFS4_STATEID_SIZE);
 
         if ((status = encode_attrs(xdr, arg->iap, server)))
 		return status;
@@ -1234,9 +1234,9 @@ static int encode_setclientid(struct xdr_stream *xdr, const struct nfs4_setclien
 {
 	__be32 *p;
 
-	RESERVE_SPACE(4 + sizeof(setclientid->sc_verifier->data));
+	RESERVE_SPACE(4 + NFS4_VERIFIER_SIZE);
 	WRITE32(OP_SETCLIENTID);
-	WRITEMEM(setclientid->sc_verifier->data, sizeof(setclientid->sc_verifier->data));
+	WRITEMEM(setclientid->sc_verifier->data, NFS4_VERIFIER_SIZE);
 
 	encode_string(xdr, setclientid->sc_name_len, setclientid->sc_name);
 	RESERVE_SPACE(4);
@@ -1253,10 +1253,10 @@ static int encode_setclientid_confirm(struct xdr_stream *xdr, const struct nfs_c
 {
         __be32 *p;
 
-        RESERVE_SPACE(12 + sizeof(client_state->cl_confirm.data));
+        RESERVE_SPACE(12 + NFS4_VERIFIER_SIZE);
         WRITE32(OP_SETCLIENTID_CONFIRM);
         WRITE64(client_state->cl_clientid);
-        WRITEMEM(client_state->cl_confirm.data, sizeof(client_state->cl_confirm.data));
+        WRITEMEM(client_state->cl_confirm.data, NFS4_VERIFIER_SIZE);
 
         return 0;
 }
@@ -1284,10 +1284,10 @@ static int encode_delegreturn(struct xdr_stream *xdr, const nfs4_stateid *statei
 {
 	__be32 *p;
 
-	RESERVE_SPACE(20);
+	RESERVE_SPACE(4+NFS4_STATEID_SIZE);
 
 	WRITE32(OP_DELEGRETURN);
-	WRITEMEM(stateid->data, sizeof(stateid->data));
+	WRITEMEM(stateid->data, NFS4_STATEID_SIZE);
 	return 0;
 
 }
@@ -2494,7 +2494,7 @@ static int decode_attr_fs_locations(struct xdr_stream *xdr, uint32_t *bitmap, st
 				int i;
 				dprintk("%s: using first %d of %d servers returned for location %d\n", __FUNCTION__, NFS4_FS_LOCATION_MAXSERVERS, m, res->nlocations);
 				for (i = loc->nservers; i < m; i++) {
-					int len;
+					unsigned int len;
 					char *data;
 					status = decode_opaque_inline(xdr, &len, &data);
 					if (unlikely(status != 0))
@@ -2642,7 +2642,7 @@ static int decode_attr_nlink(struct xdr_stream *xdr, uint32_t *bitmap, uint32_t
 	return 0;
 }
 
-static int decode_attr_owner(struct xdr_stream *xdr, uint32_t *bitmap, struct nfs_client *clp, int32_t *uid)
+static int decode_attr_owner(struct xdr_stream *xdr, uint32_t *bitmap, struct nfs_client *clp, uint32_t *uid)
 {
 	uint32_t len;
 	__be32 *p;
@@ -2667,7 +2667,7 @@ static int decode_attr_owner(struct xdr_stream *xdr, uint32_t *bitmap, struct nf
 	return 0;
 }
 
-static int decode_attr_group(struct xdr_stream *xdr, uint32_t *bitmap, struct nfs_client *clp, int32_t *gid)
+static int decode_attr_group(struct xdr_stream *xdr, uint32_t *bitmap, struct nfs_client *clp, uint32_t *gid)
 {
 	uint32_t len;
 	__be32 *p;
@@ -2897,8 +2897,8 @@ static int decode_close(struct xdr_stream *xdr, struct nfs_closeres *res)
 	status = decode_op_hdr(xdr, OP_CLOSE);
 	if (status)
 		return status;
-	READ_BUF(sizeof(res->stateid.data));
-	COPYMEM(res->stateid.data, sizeof(res->stateid.data));
+	READ_BUF(NFS4_STATEID_SIZE);
+	COPYMEM(res->stateid.data, NFS4_STATEID_SIZE);
 	return 0;
 }
 
@@ -3186,8 +3186,8 @@ static int decode_lock(struct xdr_stream *xdr, struct nfs_lock_res *res)
 
 	status = decode_op_hdr(xdr, OP_LOCK);
 	if (status == 0) {
-		READ_BUF(sizeof(res->stateid.data));
-		COPYMEM(res->stateid.data, sizeof(res->stateid.data));
+		READ_BUF(NFS4_STATEID_SIZE);
+		COPYMEM(res->stateid.data, NFS4_STATEID_SIZE);
 	} else if (status == -NFS4ERR_DENIED)
 		return decode_lock_denied(xdr, NULL);
 	return status;
@@ -3209,8 +3209,8 @@ static int decode_locku(struct xdr_stream *xdr, struct nfs_locku_res *res)
 
 	status = decode_op_hdr(xdr, OP_LOCKU);
 	if (status == 0) {
-		READ_BUF(sizeof(res->stateid.data));
-		COPYMEM(res->stateid.data, sizeof(res->stateid.data));
+		READ_BUF(NFS4_STATEID_SIZE);
+		COPYMEM(res->stateid.data, NFS4_STATEID_SIZE);
 	}
 	return status;
 }
@@ -3251,8 +3251,8 @@ static int decode_delegation(struct xdr_stream *xdr, struct nfs_openres *res)
 		res->delegation_type = 0;
 		return 0;
 	}
-	READ_BUF(20);
-	COPYMEM(res->delegation.data, sizeof(res->delegation.data));
+	READ_BUF(NFS4_STATEID_SIZE+4);
+	COPYMEM(res->delegation.data, NFS4_STATEID_SIZE);
 	READ32(res->do_recall);
 	switch (delegation_type) {
 		case NFS4_OPEN_DELEGATE_READ:
@@ -3275,8 +3275,8 @@ static int decode_open(struct xdr_stream *xdr, struct nfs_openres *res)
         status = decode_op_hdr(xdr, OP_OPEN);
         if (status)
                 return status;
-        READ_BUF(sizeof(res->stateid.data));
-        COPYMEM(res->stateid.data, sizeof(res->stateid.data));
+        READ_BUF(NFS4_STATEID_SIZE);
+        COPYMEM(res->stateid.data, NFS4_STATEID_SIZE);
 
         decode_change_info(xdr, &res->cinfo);
 
@@ -3302,8 +3302,8 @@ static int decode_open_confirm(struct xdr_stream *xdr, struct nfs_open_confirmre
         status = decode_op_hdr(xdr, OP_OPEN_CONFIRM);
         if (status)
                 return status;
-        READ_BUF(sizeof(res->stateid.data));
-        COPYMEM(res->stateid.data, sizeof(res->stateid.data));
+        READ_BUF(NFS4_STATEID_SIZE);
+        COPYMEM(res->stateid.data, NFS4_STATEID_SIZE);
         return 0;
 }
 
@@ -3315,8 +3315,8 @@ static int decode_open_downgrade(struct xdr_stream *xdr, struct nfs_closeres *re
 	status = decode_op_hdr(xdr, OP_OPEN_DOWNGRADE);
 	if (status)
 		return status;
-	READ_BUF(sizeof(res->stateid.data));
-	COPYMEM(res->stateid.data, sizeof(res->stateid.data));
+	READ_BUF(NFS4_STATEID_SIZE);
+	COPYMEM(res->stateid.data, NFS4_STATEID_SIZE);
 	return 0;
 }
 
@@ -3590,9 +3590,9 @@ static int decode_setclientid(struct xdr_stream *xdr, struct nfs_client *clp)
 	}
 	READ32(nfserr);
 	if (nfserr == NFS_OK) {
-		READ_BUF(8 + sizeof(clp->cl_confirm.data));
+		READ_BUF(8 + NFS4_VERIFIER_SIZE);
 		READ64(clp->cl_clientid);
-		COPYMEM(clp->cl_confirm.data, sizeof(clp->cl_confirm.data));
+		COPYMEM(clp->cl_confirm.data, NFS4_VERIFIER_SIZE);
 	} else if (nfserr == NFSERR_CLID_INUSE) {
 		uint32_t len;
 
diff --git a/fs/nfs/read.c b/fs/nfs/read.c
index 9a55807..7bd7cb9 100644
--- a/fs/nfs/read.c
+++ b/fs/nfs/read.c
@@ -79,7 +79,7 @@ void nfs_readdata_release(void *data)
 static
 int nfs_return_empty_page(struct page *page)
 {
-	memclear_highpage_flush(page, 0, PAGE_CACHE_SIZE);
+	zero_user_page(page, 0, PAGE_CACHE_SIZE, KM_USER0);
 	SetPageUptodate(page);
 	unlock_page(page);
 	return 0;
@@ -103,10 +103,10 @@ static void nfs_readpage_truncate_uninitialised_page(struct nfs_read_data *data)
 	pglen = PAGE_CACHE_SIZE - base;
 	for (;;) {
 		if (remainder <= pglen) {
-			memclear_highpage_flush(*pages, base, remainder);
+			zero_user_page(*pages, base, remainder, KM_USER0);
 			break;
 		}
-		memclear_highpage_flush(*pages, base, pglen);
+		zero_user_page(*pages, base, pglen, KM_USER0);
 		pages++;
 		remainder -= pglen;
 		pglen = PAGE_CACHE_SIZE;
@@ -130,7 +130,7 @@ static int nfs_readpage_async(struct nfs_open_context *ctx, struct inode *inode,
 		return PTR_ERR(new);
 	}
 	if (len < PAGE_CACHE_SIZE)
-		memclear_highpage_flush(page, len, PAGE_CACHE_SIZE - len);
+		zero_user_page(page, len, PAGE_CACHE_SIZE - len, KM_USER0);
 
 	nfs_list_add_request(new, &one_request);
 	if (NFS_SERVER(inode)->rsize < PAGE_CACHE_SIZE)
@@ -532,7 +532,7 @@ readpage_async_filler(void *data, struct page *page)
 			return PTR_ERR(new);
 	}
 	if (len < PAGE_CACHE_SIZE)
-		memclear_highpage_flush(page, len, PAGE_CACHE_SIZE - len);
+		zero_user_page(page, len, PAGE_CACHE_SIZE - len, KM_USER0);
 	nfs_pageio_add_request(desc->pgio, new);
 	return 0;
 }
diff --git a/fs/nfs/write.c b/fs/nfs/write.c
index de92b95..b084c03 100644
--- a/fs/nfs/write.c
+++ b/fs/nfs/write.c
@@ -58,7 +58,7 @@ struct nfs_write_data *nfs_commit_alloc(void)
 	return p;
 }
 
-void nfs_commit_rcu_free(struct rcu_head *head)
+static void nfs_commit_rcu_free(struct rcu_head *head)
 {
 	struct nfs_write_data *p = container_of(head, struct nfs_write_data, task.u.tk_rcu);
 	if (p && (p->pagevec != &p->page_array[0]))
@@ -168,7 +168,7 @@ static void nfs_mark_uptodate(struct page *page, unsigned int base, unsigned int
 	if (count != nfs_page_length(page))
 		return;
 	if (count != PAGE_CACHE_SIZE)
-		memclear_highpage_flush(page, count, PAGE_CACHE_SIZE - count);
+		zero_user_page(page, count, PAGE_CACHE_SIZE - count, KM_USER0);
 	SetPageUptodate(page);
 }
 
@@ -922,7 +922,7 @@ static int nfs_flush_one(struct inode *inode, struct list_head *head, unsigned i
 	return 0;
  out_bad:
 	while (!list_empty(head)) {
-		struct nfs_page *req = nfs_list_entry(head->next);
+		req = nfs_list_entry(head->next);
 		nfs_list_remove_request(req);
 		nfs_redirty_request(req);
 		nfs_end_page_writeback(req->wb_page);
diff --git a/include/linux/lockd/xdr4.h b/include/linux/lockd/xdr4.h
index dd12b4c..12bfe09 100644
--- a/include/linux/lockd/xdr4.h
+++ b/include/linux/lockd/xdr4.h
@@ -42,5 +42,6 @@ int	nlmclt_encode_lockargs(struct rpc_rqst *, u32 *, struct nlm_args *);
 int	nlmclt_encode_cancargs(struct rpc_rqst *, u32 *, struct nlm_args *);
 int	nlmclt_encode_unlockargs(struct rpc_rqst *, u32 *, struct nlm_args *);
  */
+extern struct rpc_version nlm_version4;
 
 #endif /* LOCKD_XDR4_H */
diff --git a/include/linux/nfs4.h b/include/linux/nfs4.h
index 1be5be8..7e7f33a 100644
--- a/include/linux/nfs4.h
+++ b/include/linux/nfs4.h
@@ -16,6 +16,7 @@
 #include <linux/types.h>
 
 #define NFS4_VERIFIER_SIZE	8
+#define NFS4_STATEID_SIZE	16
 #define NFS4_FHSIZE		128
 #define NFS4_MAXPATHLEN		PATH_MAX
 #define NFS4_MAXNAMLEN		NAME_MAX
@@ -113,7 +114,7 @@ struct nfs4_acl {
 };
 
 typedef struct { char data[NFS4_VERIFIER_SIZE]; } nfs4_verifier;
-typedef struct { char data[16]; } nfs4_stateid;
+typedef struct { char data[NFS4_STATEID_SIZE]; } nfs4_stateid;
 
 enum nfs_opnum4 {
 	OP_ACCESS = 3,
diff --git a/include/linux/sunrpc/rpc_pipe_fs.h b/include/linux/sunrpc/rpc_pipe_fs.h
index 4a68125..ad29376 100644
--- a/include/linux/sunrpc/rpc_pipe_fs.h
+++ b/include/linux/sunrpc/rpc_pipe_fs.h
@@ -47,6 +47,8 @@ extern struct dentry *rpc_mkpipe(struct dentry *, const char *, void *, struct r
 extern int rpc_unlink(struct dentry *);
 extern struct vfsmount *rpc_get_mount(void);
 extern void rpc_put_mount(void);
+extern int register_rpc_pipefs(void);
+extern void unregister_rpc_pipefs(void);
 
 #endif
 #endif
diff --git a/include/linux/sunrpc/xprt.h b/include/linux/sunrpc/xprt.h
index fa89ce6..34f7590 100644
--- a/include/linux/sunrpc/xprt.h
+++ b/include/linux/sunrpc/xprt.h
@@ -244,6 +244,8 @@ void			xprt_disconnect(struct rpc_xprt *xprt);
  */
 struct rpc_xprt *	xs_setup_udp(struct sockaddr *addr, size_t addrlen, struct rpc_timeout *to);
 struct rpc_xprt *	xs_setup_tcp(struct sockaddr *addr, size_t addrlen, struct rpc_timeout *to);
+int			init_socket_xprt(void);
+void			cleanup_socket_xprt(void);
 
 /*
  * Reserved bit positions in xprt->state
diff --git a/net/sunrpc/sched.c b/net/sunrpc/sched.c
index b011eb6..944d753 100644
--- a/net/sunrpc/sched.c
+++ b/net/sunrpc/sched.c
@@ -989,8 +989,6 @@ void rpc_killall_tasks(struct rpc_clnt *clnt)
 	spin_unlock(&rpc_sched_lock);
 }
 
-static DECLARE_MUTEX_LOCKED(rpciod_running);
-
 static void rpciod_killall(void)
 {
 	unsigned long flags;
diff --git a/net/sunrpc/sunrpc_syms.c b/net/sunrpc/sunrpc_syms.c
index 0d35bc7..73075de 100644
--- a/net/sunrpc/sunrpc_syms.c
+++ b/net/sunrpc/sunrpc_syms.c
@@ -134,11 +134,7 @@ EXPORT_SYMBOL(nfsd_debug);
 EXPORT_SYMBOL(nlm_debug);
 #endif
 
-extern int register_rpc_pipefs(void);
-extern void unregister_rpc_pipefs(void);
 extern struct cache_detail ip_map_cache, unix_gid_cache;
-extern int init_socket_xprt(void);
-extern void cleanup_socket_xprt(void);
 
 static int __init
 init_sunrpc(void)


