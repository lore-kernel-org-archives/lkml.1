Return-Path: <linux-kernel-owner+w=401wt.eu-S1760624AbYGKNu5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760624AbYGKNu5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 09:50:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755875AbYGKNr6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 09:47:58 -0400
Received: from zbr.yandex.ru ([213.180.219.33]:34979 "EHLO gavana.yandex.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759366AbYGKNrx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 09:47:53 -0400
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, David Fries <david@fries.net>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: [PATCH 13/30] W1: w1_family, remove unused variable need_exit
Date: Fri, 11 Jul 2008 17:51:28 +0400
Message-Id: <12157843062959-git-send-email-johnpol@2ka.mipt.ru>
X-Mailer: git-send-email 1.5.2.5
In-Reply-To: <12157843054074-git-send-email-johnpol@2ka.mipt.ru>
References: <12157843054074-git-send-email-johnpol@2ka.mipt.ru>
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

