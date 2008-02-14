Return-Path: <linux-kernel-owner+w=401wt.eu-S934594AbYBNVY7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934594AbYBNVY7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 16:24:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934306AbYBNVYU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 16:24:20 -0500
Received: from smtp4.pp.htv.fi ([213.243.153.38]:53427 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934274AbYBNVYS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 16:24:18 -0500
Date: Thu, 14 Feb 2008 23:23:57 +0200
From: Adrian Bunk <bunk@kernel.org>
To: "Ed L. Cashin" <ecashin@coraid.com>
Cc: Jan Engelhardt <jengelh@computergmbh.de>, linux-kernel@vger.kernel.org
Subject: [2.6 patch] remove aoedev_isbusy()
Message-ID: <20080214212357.GE23227@cs181133002.pp.htv.fi>
References: <20080213213002.GT3383@cs181133002.pp.htv.fi> <Pine.LNX.4.64.0802132303150.29154@fbirervta.pbzchgretzou.qr> <20080213220537.GA24319@cs181133002.pp.htv.fi> <20080213225653.GK4355@coraid.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080213225653.GK4355@coraid.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 13, 2008 at 05:56:53PM -0500, Ed L. Cashin wrote:
> On Thu, Feb 14, 2008 at 12:05:37AM +0200, Adrian Bunk wrote:
> > On Wed, Feb 13, 2008 at 11:03:35PM +0100, Jan Engelhardt wrote:
> > > 
> > > On Feb 13 2008 23:30, Adrian Bunk wrote:
> > > >
> > > >This patch #if 0's the no longer used aoedev_isbusy().
> > > 
> > > Why not just remove it? (It can be resurrected from earlier
> > > revisions should it be needed again.)
> > 
> > I've switched to doing #if 0 instead since this addresses the
> > "It might be needed in the future." answer I otherwise sometimes
> > got.
> > 
> > But if a maintainer wants to have such a function deleted instead that's 
> > fine with me.
> 
> Hello.  That function can go away.  I have some changes pending, but
> none of them use aoedev_isbusy.  Thanks for Cc-ing me.

Updated patch below

cu
Adrian


<--  snip  -->


This patch removes the no longer used aoedev_isbusy().

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 drivers/block/aoe/aoe.h    |    1 -
 drivers/block/aoe/aoedev.c |   18 ------------------
 2 files changed, 19 deletions(-)

13d7ce5f6fa02341f1642f684847ce409bbd5b1d diff --git a/drivers/block/aoe/aoe.h b/drivers/block/aoe/aoe.h
index 280e71e..5b4c6e6 100644
--- a/drivers/block/aoe/aoe.h
+++ b/drivers/block/aoe/aoe.h
@@ -195,7 +195,6 @@ void aoedev_exit(void);
 struct aoedev *aoedev_by_aoeaddr(int maj, int min);
 struct aoedev *aoedev_by_sysminor_m(ulong sysminor);
 void aoedev_downdev(struct aoedev *d);
-int aoedev_isbusy(struct aoedev *d);
 int aoedev_flush(const char __user *str, size_t size);
 
 int aoenet_init(void);
diff --git a/drivers/block/aoe/aoedev.c b/drivers/block/aoe/aoedev.c
index f9a1cd9..a1d813a 100644
--- a/drivers/block/aoe/aoedev.c
+++ b/drivers/block/aoe/aoedev.c
@@ -18,24 +18,6 @@ static void skbpoolfree(struct aoedev *d);
 static struct aoedev *devlist;
 static DEFINE_SPINLOCK(devlist_lock);
 
-int
-aoedev_isbusy(struct aoedev *d)
-{
-	struct aoetgt **t, **te;
-	struct frame *f, *e;
-
-	t = d->targets;
-	te = t + NTARGETS;
-	for (; t < te && *t; t++) {
-		f = (*t)->frames;
-		e = f + (*t)->nframes;
-		for (; f < e; f++)
-			if (f->tag != FREETAG)
-				return 1;
-	}
-	return 0;
-}
-
 struct aoedev *
 aoedev_by_aoeaddr(int maj, int min)
 {

