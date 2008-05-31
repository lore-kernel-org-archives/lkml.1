Return-Path: <linux-kernel-owner+w=401wt.eu-S1752769AbYEaNa7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752769AbYEaNa7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2008 09:30:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753066AbYEaNaK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 May 2008 09:30:10 -0400
Received: from mx1.riseup.net ([204.13.164.18]:44784 "EHLO mx1.riseup.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752937AbYEaNaJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2008 09:30:09 -0400
Message-Id: <20080531132808.984625508@kaehlcke.net>
References: <20080531132808.644758754@kaehlcke.net>
User-Agent: quilt/0.46-1
Date: Sat, 31 May 2008 15:28:09 +0200
From: matthias@kaehlcke.net
To: dwmw2@infradead.org, linux-mtd@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Matthias Kaehlcke <matthias@kaehlcke.net>
Subject: [patch 1/2] MTD: use list_for_each_entry() in add_mtd_device()
Content-Disposition: inline; filename=mtd-add_mtd_device-use-list_for_each_entry.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

MTD: use list_for_each_entry() instead of list_for_each() in add_mtd_device()

Signed-off-by: Matthias Kaehlcke <matthias@kaehlcke.net>

Index: linux-2.6/drivers/mtd/mtdcore.c
===================================================================
--- linux-2.6.orig/drivers/mtd/mtdcore.c	2008-05-31 14:46:00.000000000 +0200
+++ linux-2.6/drivers/mtd/mtdcore.c	2008-05-31 14:46:20.000000000 +0200
@@ -53,7 +53,7 @@
 
 	for (i=0; i < MAX_MTD_DEVICES; i++)
 		if (!mtd_table[i]) {
-			struct list_head *this;
+			struct mtd_notifier *not
 
 			mtd_table[i] = mtd;
 			mtd->index = i;
@@ -72,8 +72,7 @@
 			DEBUG(0, "mtd: Giving out device %d to %s\n",i, mtd->name);
 			/* No need to get a refcount on the module containing
 			   the notifier, since we hold the mtd_table_mutex */
-			list_for_each(this, &mtd_notifiers) {
-				struct mtd_notifier *not = list_entry(this, struct mtd_notifier, list);
+			list_for_each_entry(not, &mtd_notifiers, list) {
 				not->add(mtd);
 			}
 

-- 
Matthias Kaehlcke
Embedded Linux Engineer
Barcelona

              We build too many walls and not enough bridges
                             (Isaac Newton)
                                                                 .''`.
    using free software / Debian GNU/Linux | http://debian.org  : :'  :
                                                                `. `'`
gpg --keyserver pgp.mit.edu --recv-keys 47D8E5D4                  `-
