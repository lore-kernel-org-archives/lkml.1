Return-Path: <linux-kernel-owner+w=401wt.eu-S1751474AbYGaCwp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751474AbYGaCwp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 22:52:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755704AbYGaCtq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 22:49:46 -0400
Received: from SpacedOut.fries.net ([67.64.210.234]:60555 "EHLO
	SpacedOut.fries.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760123AbYGaCto (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 22:49:44 -0400
Date: Wed, 30 Jul 2008 21:49:32 -0500
From: David Fries <david@fries.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>, linux-kernel@vger.kernel.org
Subject: [PATCH 13/30] W1: w1_family, remove unused variable need_exit
Message-ID: <20080731024932.GN12181@spacedout.fries.net>
References: <20080729020433.GA24424@spacedout.fries.net> <20080729161356.2de456fb.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080729161356.2de456fb.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.4i
X-Greylist: Sender is SPF-compliant, not delayed by milter-greylist-3.0 (SpacedOut.fries.net [127.0.0.1]); Wed, 30 Jul 2008 21:49:32 -0500 (CDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed the w1_family structure member variable need_exit.  It was
only being set and never used.  Even if it were to be used it is a
polling type operation.

Signed-off-by: David Fries <david@fries.net>
Signed-off-by: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
---
 drivers/w1/w1_family.c |    7 +------
 drivers/w1/w1_family.h |    1 -
 2 files changed, 1 insertions(+), 7 deletions(-)

diff --git a/drivers/w1/w1_family.c b/drivers/w1/w1_family.c
index 8c35f9c..4a09904 100644
--- a/drivers/w1/w1_family.c
+++ b/drivers/w1/w1_family.c
@@ -48,7 +48,6 @@ int w1_register_family(struct w1_family *newf)
 
 	if (!ret) {
 		atomic_set(&newf->refcnt, 0);
-		newf->need_exit = 0;
 		list_add_tail(&newf->family_entry, &w1_families);
 	}
 	spin_unlock(&w1_flock);
@@ -73,9 +72,6 @@ void w1_unregister_family(struct w1_family *fent)
 			break;
 		}
 	}
-
-	fent->need_exit = 1;
-
 	spin_unlock(&w1_flock);
 
 	/* deatch devices using this family code */
@@ -113,8 +109,7 @@ struct w1_family * w1_family_registered(u8 fid)
 
 static void __w1_family_put(struct w1_family *f)
 {
-	if (atomic_dec_and_test(&f->refcnt))
-		f->need_exit = 1;
+	atomic_dec(&f->refcnt);
 }
 
 void w1_family_put(struct w1_family *f)
diff --git a/drivers/w1/w1_family.h b/drivers/w1/w1_family.h
index 296a87e..3053133 100644
--- a/drivers/w1/w1_family.h
+++ b/drivers/w1/w1_family.h
@@ -53,7 +53,6 @@ struct w1_family
 	struct w1_family_ops	*fops;
 
 	atomic_t		refcnt;
-	u8			need_exit;
 };
 
 extern spinlock_t w1_flock;
-- 
1.4.4.4
