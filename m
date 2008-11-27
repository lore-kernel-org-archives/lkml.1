Return-Path: <linux-kernel-owner+w=401wt.eu-S1756659AbYK0Kmw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756659AbYK0Kmw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 05:42:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754637AbYK0KdF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 05:33:05 -0500
Received: from mtagate5.de.ibm.com ([195.212.29.154]:55438 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753233AbYK0Kc1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 05:32:27 -0500
Message-Id: <20081127103138.391189595@de.ibm.com>
References: <20081127103020.528516828@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Thu, 27 Nov 2008 11:30:58 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
       Christian Borntraeger <borntraeger@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [patch 38/60] convert cpcmd printks to pr_xxx macros.
Content-Disposition: inline; filename=153-kmsg-cpcmd.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christian Borntraeger <borntraeger@de.ibm.com>

Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 arch/s390/kernel/cpcmd.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

Index: quilt-2.6/arch/s390/kernel/cpcmd.c
===================================================================
--- quilt-2.6.orig/arch/s390/kernel/cpcmd.c
+++ quilt-2.6/arch/s390/kernel/cpcmd.c
@@ -7,6 +7,9 @@
  *               Christian Borntraeger (cborntra@de.ibm.com),
  */
 
+#define KMSG_COMPONENT "cpcmd"
+#define pr_fmt(fmt) KMSG_COMPONENT ": " fmt
+
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/slab.h>
@@ -104,8 +107,8 @@ int cpcmd(const char *cmd, char *respons
 			(((unsigned long)response + rlen) >> 31)) {
 		lowbuf = kmalloc(rlen, GFP_KERNEL | GFP_DMA);
 		if (!lowbuf) {
-			printk(KERN_WARNING
-				"cpcmd: could not allocate response buffer\n");
+			pr_warning("The cpcmd kernel function failed to "
+				   "allocate a response buffer\n");
 			return -ENOMEM;
 		}
 		spin_lock_irqsave(&cpcmd_lock, flags);

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

