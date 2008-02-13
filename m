Return-Path: <linux-kernel-owner+w=401wt.eu-S932668AbYBMVi7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932668AbYBMVi7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 16:38:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763499AbYBMVa2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 16:30:28 -0500
Received: from smtp4.pp.htv.fi ([213.243.153.38]:50800 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763468AbYBMVaY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 16:30:24 -0500
Date: Wed, 13 Feb 2008 23:30:08 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Richard Purdie <rpurdie@rpsys.net>, David Woodhouse <dwmw2@infradead.org>
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] mtdoops.c: make struct oops_cxt static again
Message-ID: <20080213213008.GW3383@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

struct oops_cxt needlessly became global.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
--- linux-2.6/drivers/mtd/mtdoops.c.old	2008-02-11 23:19:45.000000000 +0200
+++ linux-2.6/drivers/mtd/mtdoops.c	2008-02-11 23:19:55.000000000 +0200
@@ -23,31 +23,31 @@
 
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/console.h>
 #include <linux/vmalloc.h>
 #include <linux/workqueue.h>
 #include <linux/sched.h>
 #include <linux/wait.h>
 #include <linux/delay.h>
 #include <linux/spinlock.h>
 #include <linux/interrupt.h>
 #include <linux/mtd/mtd.h>
 
 #define OOPS_PAGE_SIZE 4096
 
-struct mtdoops_context {
+static struct mtdoops_context {
 	int mtd_index;
 	struct work_struct work_erase;
 	struct work_struct work_write;
 	struct mtd_info *mtd;
 	int oops_pages;
 	int nextpage;
 	int nextcount;
 
 	void *oops_buf;
 
 	/* writecount and disabling ready are spin lock protected */
 	spinlock_t writecount_lock;
 	int ready;
 	int writecount;
 } oops_cxt;
