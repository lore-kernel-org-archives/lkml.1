Return-Path: <linux-kernel-owner+w=401wt.eu-S1756829AbXG1Rej@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756829AbXG1Rej (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jul 2007 13:34:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754092AbXG1Rec
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jul 2007 13:34:32 -0400
Received: from smtp2.it.da.ut.ee ([193.40.5.67]:59434 "EHLO smtp2.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753433AbXG1Reb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jul 2007 13:34:31 -0400
Date: Sat, 28 Jul 2007 20:34:30 +0300 (EEST)
From: Meelis Roos <mroos@linux.ee>
To: Linux Kernel list <linux-kernel@vger.kernel.org>,
       Jay Estabrook <jay.estabrook@hp.com>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Richard Henderson <rth@twiddle.net>
Subject: [PATCH] fix alpha boot/main.c warning
Message-ID: <Pine.SOC.4.64.0707282030000.20474@math.ut.ee>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In current 2.6.23-rc1+git, make bootimage gives the following warning 
while compiling arch/alpha/boot/main.c. The patch below fixes the 
warning by casting callback argument explicitly to void*. The original 
value comes from START_ADDR macro and is clearly numeric so only cast it 
for the callback.

  CC      arch/alpha/boot/main.o
arch/alpha/boot/main.c: In function 'load':
arch/alpha/boot/main.c:135: warning: passing argument 3 of 'callback_read' makes pointer from integer without a cast

Signed-off-by: Meelis Roos <mroos@linux.ee>

diff --git a/arch/alpha/boot/main.c b/arch/alpha/boot/main.c
index 90ed55b..89f3be0 100644
--- a/arch/alpha/boot/main.c
+++ b/arch/alpha/boot/main.c
@@ -132,7 +132,7 @@ static inline long load(long dev, unsigned long addr, unsigned long count)
 	if (result)
 		srm_printk("Boot file specification (%s) not implemented\n",
 		       bootfile);
-	return callback_read(dev, count, addr, boot_size/512 + 1);
+	return callback_read(dev, count, (void *)addr, boot_size/512 + 1);
 }
 
 /*

-- 
Meelis Roos (mroos@linux.ee)
