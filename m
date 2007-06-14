Return-Path: <linux-kernel-owner+w=401wt.eu-S1752045AbXFNKes@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752045AbXFNKes (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 06:34:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751245AbXFNKek
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 06:34:40 -0400
Received: from wip-cdc-wd.wipro.com ([203.91.201.26]:59865 "EHLO
	wip-cdc-wd.wipro.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751239AbXFNKej (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 06:34:39 -0400
Subject: [PATCH]is_power_of_2-kernel/kfifo.c
From: vignesh babu <vignesh.babu@wipro.com>
Reply-To: vignesh.babu@wipro.com
To: stelian <stelian@popies.net>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Kernel Janitors List <kernel-janitors@lists.osdl.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: WIPRO Technologies
Date: Thu, 14 Jun 2007 16:05:06 +0530
Message-Id: <1181817306.2474.22.camel@merlin.linuxcoe.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7) 
X-OriginalArrivalTime: 14 Jun 2007 10:34:52.0739 (UTC) FILETIME=[A479B130:01C7AE6F]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Replacing (n & (n-1)) in the context of power of 2 checks
with is_power_of_2

Signed-off-by: vignesh babu <vignesh.babu@wipro.com>
--- 
diff --git a/kernel/kfifo.c b/kernel/kfifo.c
index cee4191..bc41ad0 100644
--- a/kernel/kfifo.c
+++ b/kernel/kfifo.c
@@ -24,6 +24,7 @@
 #include <linux/slab.h>
 #include <linux/err.h>
 #include <linux/kfifo.h>
+#include <linux/log2.h>
 
 /**
  * kfifo_init - allocates a new FIFO using a preallocated buffer
@@ -41,7 +42,7 @@ struct kfifo *kfifo_init(unsigned char *buffer, unsigned int size,
 	struct kfifo *fifo;
 
 	/* size must be a power of 2 */
-	BUG_ON(size & (size - 1));
+	BUG_ON(!is_power_of_2(size));
 
 	fifo = kmalloc(sizeof(struct kfifo), gfp_mask);
 	if (!fifo)

-- 
Vignesh Babu BM 
_____________________________________________________________ 
"Why is it that every time I'm with you, makes me believe in magic?"

