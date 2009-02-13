Return-Path: <linux-kernel-owner+w=401wt.eu-S1761843AbZBMOxv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761843AbZBMOxv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 09:53:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751546AbZBMOxn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 09:53:43 -0500
Received: from fk-out-0910.google.com ([209.85.128.190]:22637 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751438AbZBMOxm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 09:53:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=kYTwYLA2zZkyUNoxVU9paAncPGXvRuUPPScA5Qy5LSU1Ur8omzz6Bc7LoxB1qNHKKw
         MAKreAmKu7nVc50TeMzwyNuuAmMyaUXGSelRgWm5o18pgiRZIBQmZceh9y+xp6ZwQRJW
         Iu3AZtmVE9pR0CV2KNRayUBbkGTVZK74O7pLI=
Date: Fri, 13 Feb 2009 17:53:30 +0300
From: Alexander Beregalov <a.beregalov@gmail.com>
To: zbr@ioremap.net, gregkh@suse.de, frank@f-seidel.de,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH next] Staging: pohmelfs: fix printk format warnings v2
Message-ID: <20090213145330.GA7321@orion>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/staging/pohmelfs/inode.c:917: warning: format '%u' expects type 'unsigned int', but argument 4 has type 'size_t'
drivers/staging/pohmelfs/inode.c:1036: warning: format '%u' expects type 'unsigned int', but argument 7 has type 'size_t'
drivers/staging/pohmelfs/trans.c:164: warning: format '%u' expects type 'unsigned int', but argument 5 has type '__kernel_size_t'
drivers/staging/pohmelfs/trans.c:170: warning: format '%u' expects type 'unsigned int', but argument 7 has type '__kernel_size_t'
drivers/staging/pohmelfs/trans.c:517: warning: format '%u' expects type 'unsigned int', but argument 6 has type '__kernel_size_t'
drivers/staging/pohmelfs/trans.c:600: warning: format '%u' expects type 'unsigned int', but argument 6 has type '__kernel_size_t'
drivers/staging/pohmelfs/trans.c:610: warning: format '%u' expects type 'unsigned int', but argument 7 has type '__kernel_size_t'

Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
---

 drivers/staging/pohmelfs/inode.c |    4 ++--
 drivers/staging/pohmelfs/trans.c |   10 +++++-----
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/pohmelfs/inode.c b/drivers/staging/pohmelfs/inode.c
index 0980c3c..fdce752 100644
--- a/drivers/staging/pohmelfs/inode.c
+++ b/drivers/staging/pohmelfs/inode.c
@@ -914,7 +914,7 @@ ssize_t pohmelfs_write(struct file *file, const char __user *buf,
 	kiocb.ki_pos = pos;
 	kiocb.ki_left = len;
 
-	dprintk("%s: len: %u, pos: %llu.\n", __func__, len, pos);
+	dprintk("%s: len: %zu, pos: %llu.\n", __func__, len, pos);
 
 	mutex_lock(&inode->i_mutex);
 	ret = pohmelfs_data_lock(pi, pos, len, POHMELFS_WRITE_LOCK);
@@ -1033,7 +1033,7 @@ static int pohmelfs_send_xattr_req(struct pohmelfs_inode *pi, u64 id, u64 start,
 	struct netfs_cmd *cmd;
 	void *data;
 
-	dprintk("%s: id: %llu, start: %llu, name: '%s', attrsize: %u, cmd: %d.\n",
+	dprintk("%s: id: %llu, start: %llu, name: '%s', attrsize: %zu, cmd: %d.\n",
 			__func__, id, start, name, attrsize, command);
 
 	path_len = pohmelfs_path_length(pi);
diff --git a/drivers/staging/pohmelfs/trans.c b/drivers/staging/pohmelfs/trans.c
index 92054bd..bcb5942 100644
--- a/drivers/staging/pohmelfs/trans.c
+++ b/drivers/staging/pohmelfs/trans.c
@@ -160,14 +160,14 @@ int netfs_trans_send(struct netfs_trans *t, struct netfs_state *st)
 
 	err = kernel_sendmsg(st->socket, &msg, (struct kvec *)msg.msg_iov, 1, t->iovec.iov_len);
 	if (err <= 0) {
-		printk("%s: failed to send contig transaction: t: %p, gen: %u, size: %u, err: %d.\n",
+		printk("%s: failed to send contig transaction: t: %p, gen: %u, size: %zu, err: %d.\n",
 				__func__, t, t->gen, t->iovec.iov_len, err);
 		if (err == 0)
 			err = -ECONNRESET;
 		goto err_out_unlock_return;
 	}
 
-	dprintk("%s: sent %s transaction: t: %p, gen: %u, size: %u, page_num: %u.\n",
+	dprintk("%s: sent %s transaction: t: %p, gen: %u, size: %zu, page_num: %u.\n",
 			__func__, (t->page_num)?"partial":"full",
 			t, t->gen, t->iovec.iov_len, t->page_num);
 
@@ -514,7 +514,7 @@ int netfs_trans_finish(struct netfs_trans *t, struct pohmelfs_sb *psb)
 		cmd->csize = psb->crypto_attached_size;
 	}
 
-	dprintk("%s: t: %u, size: %u, iov_len: %u, attached_size: %u, attached_pages: %u.\n",
+	dprintk("%s: t: %u, size: %u, iov_len: %zu, attached_size: %u, attached_pages: %u.\n",
 			__func__, t->gen, cmd->size, t->iovec.iov_len, t->attached_size, t->attached_pages);
 	err = pohmelfs_trans_crypt(t, psb);
 	if (err) {
@@ -597,7 +597,7 @@ void *netfs_trans_add(struct netfs_trans *t, unsigned int size)
 	}
 
 	if (io->iov_len + size > t->total_size) {
-		dprintk("%s: too big size t: %p, gen: %u, iov_len: %u, size: %u, total: %u.\n",
+		dprintk("%s: too big size t: %p, gen: %u, iov_len: %zu, size: %u, total: %u.\n",
 				__func__, t, t->gen, io->iov_len, size, t->total_size);
 		ptr = ERR_PTR(-E2BIG);
 		goto out;
@@ -607,7 +607,7 @@ void *netfs_trans_add(struct netfs_trans *t, unsigned int size)
 	io->iov_len += size;
 
 out:
-	dprintk("%s: t: %p, gen: %u, size: %u, total: %u.\n",
+	dprintk("%s: t: %p, gen: %u, size: %u, total: %zu.\n",
 		__func__, t, t->gen, size, io->iov_len);
 	return ptr;
 }
