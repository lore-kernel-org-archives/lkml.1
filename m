Return-Path: <linux-kernel-owner+w=401wt.eu-S1752818AbZJEOou@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752818AbZJEOou (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 10:44:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751690AbZJEOot
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 10:44:49 -0400
Received: from mail-qy0-f173.google.com ([209.85.221.173]:59896 "EHLO
	mail-qy0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750945AbZJEOos (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 10:44:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=jWiGqQaE1/QPgoP6J7+qBjD6MAvM+YblQG2RY0orNLZ0kyv4OowmfzGxs7JgrSoO41
         VGEiXaDp4ERE3ABTGyB9Qe0gwkRVAeA/hBvBOvIEJ1YUwdft1s0sX0PqSts906+VFUeb
         tmai6XRJ1Ayx0B3jftvbHEbszK+kfnJGbjMj0=
Subject: [PATCH] fs: added KERNEL-DEBUG flag to printk statments
From: Pete <greg.petr@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: trivial@kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain
Date: Mon, 05 Oct 2009 20:13:19 +0530
Message-Id: <1254753799.5279.37.camel@linux-k65f.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Greg Petr <greg.petr@gmail.com>

Hi, 

The following is a trivial patch which adds some KRENEL_DEBUG flags to
the printk. This is my first patch, please review the same.

 
--- linux-2.6/fs/aio.c	2009-10-05 14:46:11.000000000 +0530
+++ linux-2.6.test/fs/aio.c	2009-10-05 19:46:11.000000000 +0530
@@ -129,7 +129,7 @@ static int aio_setup_ring(struct kioctx
 	}
 
 	info->mmap_size = nr_pages * PAGE_SIZE;
-	dprintk("attempting mmap of %lu bytes\n", info->mmap_size);
+	dprintk(KERNEL_DEBUG "attempting mmap of %lu bytes\n",
info->mmap_size);
 	down_write(&ctx->mm->mmap_sem);
 	info->mmap_base = do_mmap(NULL, 0, info->mmap_size, 
 				  PROT_READ|PROT_WRITE, MAP_ANONYMOUS|MAP_PRIVATE,
@@ -141,7 +141,7 @@ static int aio_setup_ring(struct kioctx
 		return -EAGAIN;
 	}
 
-	dprintk("mmap address: 0x%08lx\n", info->mmap_base);
+	dprintk(KERNEL_DEBUG "mmap address: 0x%08lx\n", info->mmap_base);
 	info->nr_pages = get_user_pages(current, ctx->mm,
 					info->mmap_base, nr_pages, 
 					1, 0, info->ring_pages, NULL);
@@ -299,7 +299,7 @@ static struct kioctx *ioctx_alloc(unsign
 	hlist_add_head_rcu(&ctx->list, &mm->ioctx_list);
 	spin_unlock(&mm->ioctx_lock);
 
-	dprintk("aio: allocated ioctx %p[%ld]: mm=%p mask=0x%x\n",
+	dprintk(KERNEL_DEBUG "aio: allocated ioctx %p[%ld]: mm=%p mask=0x%x
\n",
 		ctx, ctx->user_id, current->mm, ctx->ring_info.nr);
 	return ctx;
 
@@ -312,7 +312,7 @@ out_freectx:
 	kmem_cache_free(kioctx_cachep, ctx);
 	ctx = ERR_PTR(-ENOMEM);
 
-	dprintk("aio: error allocating ioctx %p\n", ctx);
+	dprintk(KERNEL_DEBUG "aio: error allocating ioctx %p\n", ctx);
 	return ctx;
 }
 
@@ -407,7 +407,7 @@ void exit_aio(struct mm_struct *mm)
 		cancel_work_sync(&ctx->wq.work);
 
 		if (1 != atomic_read(&ctx->users))
-			printk(KERN_DEBUG
+			printk(KERN_DEBUG,
 				"exit_aio:ioctx still alive: %d %d %d\n",
 				atomic_read(&ctx->users), ctx->dead,
 				ctx->reqs_active);
@@ -952,7 +952,7 @@ int aio_complete(struct kiocb *iocb, lon
 	event->res = res;
 	event->res2 = res2;
 
-	dprintk("aio_complete: %p[%lu]: %p: %p %Lx %lx %lx\n",
+	dprintk(KERNEL_DEBUG "aio_complete: %p[%lu]: %p: %p %Lx %lx %lx\n",
 		ctx, tail, iocb, iocb->ki_obj.user, iocb->ki_user_data,
 		res, res2);
 
@@ -1011,7 +1011,7 @@ static int aio_read_evt(struct kioctx *i
 	int ret = 0;
 
 	ring = kmap_atomic(info->ring_pages[0], KM_USER0);
-	dprintk("in aio_read_evt h%lu t%lu m%lu\n",
+	dprintk(KERNEL_DEBUG "in aio_read_evt h%lu t%lu m%lu\n",
 		 (unsigned long)ring->head, (unsigned long)ring->tail,
 		 (unsigned long)ring->nr);
 
@@ -1034,7 +1034,7 @@ static int aio_read_evt(struct kioctx *i
 
 out:
 	kunmap_atomic(ring, KM_USER0);
-	dprintk("leaving aio_read_evt: %d  h%lu t%lu\n", ret,
+	dprintk(KERNEL_DEBUG "leaving aio_read_evt: %d  h%lu t%lu\n", ret,
 		 (unsigned long)ring->head, (unsigned long)ring->tail);
 	return ret;
 }
@@ -1100,13 +1100,13 @@ retry:
 		if (unlikely(ret <= 0))
 			break;
 
-		dprintk("read event: %Lx %Lx %Lx %Lx\n",
+		dprintk(KERNEL_DEBUG "read event: %Lx %Lx %Lx %Lx\n",
 			ent.data, ent.obj, ent.res, ent.res2);
 
 		/* Could we split the check in two? */
 		ret = -EFAULT;
 		if (unlikely(copy_to_user(event, &ent, sizeof(ent)))) {
-			dprintk("aio: lost an event due to EFAULT.\n");
+			dprintk(KERNEL_DEBUG "aio: lost an event due to EFAULT.\n");
 			break;
 		}
 		ret = 0;
@@ -1176,7 +1176,7 @@ retry:
 
 		ret = -EFAULT;
 		if (unlikely(copy_to_user(event, &ent, sizeof(ent)))) {
-			dprintk("aio: lost an event due to EFAULT.\n");
+			dprintk(KERNEL_DEBUG "aio: lost an event due to EFAULT.\n");
 			break;
 		}
 
@@ -1207,7 +1207,7 @@ static void io_destroy(struct kioctx *io
 	hlist_del_rcu(&ioctx->list);
 	spin_unlock(&mm->ioctx_lock);
 
-	dprintk("aio_release(%p)\n", ioctx);
+	dprintk(KERNEL_DEBUG "aio_release(%p)\n", ioctx);
 	if (likely(!was_dead))
 		put_ioctx(ioctx);	/* twice for the list */
 
@@ -1496,7 +1496,7 @@ static ssize_t aio_setup_iocb(struct kio
 			kiocb->ki_retry = aio_fsync;
 		break;
 	default:
-		dprintk("EINVAL: io_submit: no operation provided\n");
+		dprintk(KERNEL_DEBUG "EINVAL: io_submit: no operation provided\n");
 		ret = -EINVAL;
 	}
 
@@ -1581,7 +1581,7 @@ static int io_submit_one(struct kioctx *
 
 	ret = put_user(req->ki_key, &user_iocb->aio_key);
 	if (unlikely(ret)) {
-		dprintk("EFAULT: aio_key\n");
+		dprintk(KERNEL_DEBUG "EFAULT: aio_key\n");
 		goto out_put_req;
 	}
 


