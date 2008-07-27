Return-Path: <linux-kernel-owner+w=401wt.eu-S1758667AbYG0Qmu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758667AbYG0Qmu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2008 12:42:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755730AbYG0Qmm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jul 2008 12:42:42 -0400
Received: from mx2.suse.de ([195.135.220.15]:40308 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752479AbYG0Qmm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2008 12:42:42 -0400
Date: Sun, 27 Jul 2008 18:42:40 +0200
From: Karsten Keil <kkeil@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] Fix namespace issue with Hisax
Message-ID: <20080727164240.GC13004@pingi.kke.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

you can pull this  git://git./linux/kernel/git/kkeil/ISDN-2.6 master

rename release_tei() to TEIrelease() because release_tei() was
already exported bei the old HiSax driver.

Signed-off-by: Karsten Keil <kkeil@suse.de>
---
 drivers/isdn/mISDN/layer2.c |    2 +-
 drivers/isdn/mISDN/layer2.h |    2 +-
 drivers/isdn/mISDN/tei.c    |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/isdn/mISDN/layer2.c b/drivers/isdn/mISDN/layer2.c
index f5ad888..a7915a1 100644
--- a/drivers/isdn/mISDN/layer2.c
+++ b/drivers/isdn/mISDN/layer2.c
@@ -2030,7 +2030,7 @@ release_l2(struct layer2 *l2)
 	skb_queue_purge(&l2->down_queue);
 	ReleaseWin(l2);
 	if (test_bit(FLG_LAPD, &l2->flag)) {
-		release_tei(l2);
+		TEIrelease(l2);
 		if (l2->ch.st)
 			l2->ch.st->dev->D.ctrl(&l2->ch.st->dev->D,
 			    CLOSE_CHANNEL, NULL);
diff --git a/drivers/isdn/mISDN/layer2.h b/drivers/isdn/mISDN/layer2.h
index de2dd02..6293f80 100644
--- a/drivers/isdn/mISDN/layer2.h
+++ b/drivers/isdn/mISDN/layer2.h
@@ -96,7 +96,7 @@ extern int		tei_l2(struct layer2 *, u_int, u_long arg);
 
 /* from tei.c */
 extern int 		l2_tei(struct layer2 *, u_int, u_long arg);
-extern void 		release_tei(struct layer2 *);
+extern void 		TEIrelease(struct layer2 *);
 extern int 		TEIInit(u_int *);
 extern void 		TEIFree(void);
 
diff --git a/drivers/isdn/mISDN/tei.c b/drivers/isdn/mISDN/tei.c
index 56a76a0..6fbae42 100644
--- a/drivers/isdn/mISDN/tei.c
+++ b/drivers/isdn/mISDN/tei.c
@@ -945,7 +945,7 @@ l2_tei(struct layer2 *l2, u_int cmd, u_long arg)
 }
 
 void
-release_tei(struct layer2 *l2)
+TEIrelease(struct layer2 *l2)
 {
 	struct teimgr	*tm = l2->tm;
 	u_long		flags;
-- 
1.5.6.4


-- 
Karsten Keil
SuSE Labs
ISDN and VOIP development
SUSE LINUX Products GmbH, Maxfeldstr.5 90409 Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
