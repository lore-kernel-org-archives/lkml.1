Return-Path: <linux-kernel-owner+w=401wt.eu-S1751934AbXDPKEt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751934AbXDPKEt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 06:04:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751980AbXDPKEt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 06:04:49 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:46835 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751934AbXDPKEs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 06:04:48 -0400
Date: Mon, 16 Apr 2007 14:12:45 +0400
From: Alexey Dobriyan <adobriyan@sw.ru>
To: akpm@osdl.org
Cc: linux-kernel@vger.kernel.org, devel@openvz.org
Subject: [PATCH] paride drivers: initialize spinlocks
Message-ID: <20070416101245.GA19016@localhost.sw.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

pcd_lock and pf_spin_lock are passed to blk_init_queue() which,
seeing them as valid lock pointer, sets it as ->queue_lock.

The problem is that pcd_lock and pf_spin_lock aren't initialized
anywhere.

Signed-off-by: Alexey Dobriyan <adobriyan@sw.ru>
---

 drivers/block/paride/pcd.c |    2 +-
 drivers/block/paride/pf.c  |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/block/paride/pcd.c
+++ b/drivers/block/paride/pcd.c
@@ -140,7 +140,7 @@ #include <linux/spinlock.h>
 #include <linux/blkdev.h>
 #include <asm/uaccess.h>
 
-static spinlock_t pcd_lock;
+static DEFINE_SPINLOCK(pcd_lock);
 
 module_param(verbose, bool, 0644);
 module_param(major, int, 0);
--- a/drivers/block/paride/pf.c
+++ b/drivers/block/paride/pf.c
@@ -154,7 +154,7 @@ #include <linux/blkdev.h>
 #include <linux/blkpg.h>
 #include <asm/uaccess.h>
 
-static spinlock_t pf_spin_lock;
+static DEFINE_SPINLOCK(pf_spin_lock);
 
 module_param(verbose, bool, 0644);
 module_param(major, int, 0);

