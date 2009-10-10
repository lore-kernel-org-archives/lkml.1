Return-Path: <linux-kernel-owner+w=401wt.eu-S964894AbZJJPkj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964894AbZJJPkj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Oct 2009 11:40:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934437AbZJJPkh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Oct 2009 11:40:37 -0400
Received: from www.tglx.de ([62.245.132.106]:55747 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934412AbZJJPkf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Oct 2009 11:40:35 -0400
Message-Id: <20091010153349.844488872@linutronix.de>
User-Agent: quilt/0.47-1
Date: Sat, 10 Oct 2009 15:36:52 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Vincent Sanders <vince@simtec.co.uk>, John Kacur <jkacur@redhat.com>,
       Jonathan Corbet <corbet@lwn.net>, Christoph Hellwig <hch@infradead.org>,
       Herbert Xu <herbert@gondor.apana.org.au>
Subject: [patch 19/28] hw_random: Remove BKL from core
References: <20091010153314.827301943@linutronix.de>
Content-Disposition: inline; filename=driver-hw-random-core-remove-bkl.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hw_random core is completely serialized with rng_mutex. No need for
the cycle_kernel_lock() magic.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
---
 drivers/char/hw_random/core.c |    1 -
 1 file changed, 1 deletion(-)

Index: linux-2.6-tip/drivers/char/hw_random/core.c
===================================================================
--- linux-2.6-tip.orig/drivers/char/hw_random/core.c
+++ linux-2.6-tip/drivers/char/hw_random/core.c
@@ -87,7 +87,6 @@ static int rng_dev_open(struct inode *in
 		return -EINVAL;
 	if (filp->f_mode & FMODE_WRITE)
 		return -EINVAL;
-	cycle_kernel_lock();
 	return 0;
 }
 


