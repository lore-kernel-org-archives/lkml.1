Return-Path: <linux-kernel-owner+w=401wt.eu-S1760720AbYGKNz7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760720AbYGKNz7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 09:55:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758710AbYGKNsT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 09:48:19 -0400
Received: from zbr.yandex.ru ([213.180.219.33]:34985 "EHLO gavana.yandex.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759403AbYGKNrz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 09:47:55 -0400
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, David Fries <david@fries.net>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: [PATCH 16/30] W1: w1.c s/printk/dev_dbg/
Date: Fri, 11 Jul 2008 17:51:31 +0400
Message-Id: <12157843062360-git-send-email-johnpol@2ka.mipt.ru>
X-Mailer: git-send-email 1.5.2.5
In-Reply-To: <12157843054074-git-send-email-johnpol@2ka.mipt.ru>
References: <12157843054074-git-send-email-johnpol@2ka.mipt.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

s/printk/dev_dbg/

Signed-off-by: David Fries <david@fries.net>
Signed-off-by: Evgeniy Polyakov <johnpol@2ka.mipt.ru>

---
 drivers/w1/w1.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/w1/w1.c b/drivers/w1/w1.c
index 67b4b99..0084619 100644
--- a/drivers/w1/w1.c
+++ b/drivers/w1/w1.c
@@ -81,10 +81,10 @@ static void w1_slave_release(struct device *dev)
 {
 	struct w1_slave *sl = dev_to_w1_slave(dev);
 
-	printk("%s: Releasing %s.\n", __func__, sl->name);
+	dev_dbg(dev, "%s: Releasing %s.\n", __func__, sl->name);
 
 	while (atomic_read(&sl->refcnt)) {
-		printk("Waiting for %s to become free: refcnt=%d.\n",
+		dev_dbg(dev, "Waiting for %s to become free: refcnt=%d.\n",
 				sl->name, atomic_read(&sl->refcnt));
 		if (msleep_interruptible(1000))
 			flush_signals(current);
@@ -911,7 +911,7 @@ void w1_search(struct w1_master *dev, u8 search_type, w1_slave_found_callback cb
 			rn |= (tmp64 << i);
 
 			if (kthread_should_stop()) {
-				printk(KERN_INFO "Abort w1_search (exiting)\n");
+				dev_dbg(&dev->dev, "Abort w1_search\n");
 				return;
 			}
 		}
-- 
1.4.4.4

