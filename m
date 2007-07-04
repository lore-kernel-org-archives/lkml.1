Return-Path: <linux-kernel-owner+w=401wt.eu-S1760049AbXGDBEw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760049AbXGDBEw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 21:04:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755302AbXGDBEo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 21:04:44 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:49838 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755276AbXGDBEn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 21:04:43 -0400
Date: Wed, 4 Jul 2007 03:05:10 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org
Subject: [2.6 patch] remove mm/backing-dev.c:congestion_wait_interruptible()
Message-ID: <20070704010509.GG3492@stusta.de>
References: <20070701202051.GG10869@stusta.de> <20070703144843.4d402c32.akpm@linux-foundation.org> <1183502136.6494.74.camel@heimdal.trondhjem.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1183502136.6494.74.camel@heimdal.trondhjem.org>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 03, 2007 at 06:35:36PM -0400, Trond Myklebust wrote:
> On Tue, 2007-07-03 at 14:48 -0700, Andrew Morton wrote:
> > On Sun, 1 Jul 2007 22:20:51 +0200
> > Adrian Bunk <bunk@stusta.de> wrote:
> > 
> > > congestion_wait_interruptible() is no longer used.
> > 
> > We might as well just delete it?
> 
> I agree. We're better off deleting it, but either would be fine by me.

Updated patch below.

> Trond

cu
Adrian


<--  snip  -->


congestion_wait_interruptible() is no longer used.

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Acked-by: Trond Myklebust <trond.myklebust@fys.uio.no>

---

 include/linux/backing-dev.h |    1 -
 mm/backing-dev.c            |   16 ----------------
 2 files changed, 17 deletions(-)

--- linux-2.6.22-rc4-mm2/include/linux/backing-dev.h.old	2007-06-12 01:21:52.000000000 +0200
+++ linux-2.6.22-rc4-mm2/include/linux/backing-dev.h	2007-06-12 01:22:00.000000000 +0200
@@ -93,7 +93,6 @@
 void clear_bdi_congested(struct backing_dev_info *bdi, int rw);
 void set_bdi_congested(struct backing_dev_info *bdi, int rw);
 long congestion_wait(int rw, long timeout);
-long congestion_wait_interruptible(int rw, long timeout);
 void congestion_end(int rw);
 
 #define bdi_cap_writeback_dirty(bdi) \
--- linux-2.6.22-rc6-mm1/mm/backing-dev.c.old	2007-07-04 00:44:10.000000000 +0200
+++ linux-2.6.22-rc6-mm1/mm/backing-dev.c	2007-07-04 00:44:24.000000000 +0200
@@ -55,22 +55,6 @@
 }
 EXPORT_SYMBOL(congestion_wait);
 
-long congestion_wait_interruptible(int rw, long timeout)
-{
-	long ret;
-	DEFINE_WAIT(wait);
-	wait_queue_head_t *wqh = &congestion_wqh[rw];
-
-	prepare_to_wait(wqh, &wait, TASK_INTERRUPTIBLE);
-	if (signal_pending(current))
-		ret = -ERESTARTSYS;
-	else
-		ret = io_schedule_timeout(timeout);
-	finish_wait(wqh, &wait);
-	return ret;
-}
-EXPORT_SYMBOL(congestion_wait_interruptible);
-
 /**
  * congestion_end - wake up sleepers on a congested backing_dev_info
  * @rw: READ or WRITE

