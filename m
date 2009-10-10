Return-Path: <linux-kernel-owner+w=401wt.eu-S1761869AbZJJPhu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761869AbZJJPhu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Oct 2009 11:37:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761925AbZJJPht
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Oct 2009 11:37:49 -0400
Received: from www.tglx.de ([62.245.132.106]:55378 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761901AbZJJPhq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Oct 2009 11:37:46 -0400
Message-Id: <20091010153349.318535932@linutronix.de>
User-Agent: quilt/0.47-1
Date: Sat, 10 Oct 2009 15:35:52 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Vincent Sanders <vince@simtec.co.uk>, John Kacur <jkacur@redhat.com>,
       Jonathan Corbet <corbet@lwn.net>, Christoph Hellwig <hch@infradead.org>,
       David Brownell <dbrownell@users.sourceforge.net>
Subject: [patch 07/28] spi: Remove BKL from spidev_open
References: <20091010153314.827301943@linutronix.de>
Content-Disposition: inline; filename=spi-remove-bkl.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The BKL was added there with the big pushdown. Remove it as the code
is serialized already.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: David Brownell <dbrownell@users.sourceforge.net>

---
 drivers/spi/spidev.c |    3 ---
 1 file changed, 3 deletions(-)

Index: linux-2.6-tip/drivers/spi/spidev.c
===================================================================
--- linux-2.6-tip.orig/drivers/spi/spidev.c
+++ linux-2.6-tip/drivers/spi/spidev.c
@@ -30,7 +30,6 @@
 #include <linux/errno.h>
 #include <linux/mutex.h>
 #include <linux/slab.h>
-#include <linux/smp_lock.h>
 
 #include <linux/spi/spi.h>
 #include <linux/spi/spidev.h>
@@ -477,7 +476,6 @@ static int spidev_open(struct inode *ino
 	struct spidev_data	*spidev;
 	int			status = -ENXIO;
 
-	lock_kernel();
 	mutex_lock(&device_list_lock);
 
 	list_for_each_entry(spidev, &device_list, device_entry) {
@@ -503,7 +501,6 @@ static int spidev_open(struct inode *ino
 		pr_debug("spidev: nothing for minor %d\n", iminor(inode));
 
 	mutex_unlock(&device_list_lock);
-	unlock_kernel();
 	return status;
 }
 


