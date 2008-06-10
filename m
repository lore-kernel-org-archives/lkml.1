Return-Path: <linux-kernel-owner+w=401wt.eu-S1760447AbYFJW35@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760447AbYFJW35 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 18:29:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758065AbYFJW3W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 18:29:22 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:57843 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757998AbYFJW3V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 18:29:21 -0400
Date: Wed, 11 Jun 2008 01:28:22 +0300
From: Adrian Bunk <bunk@kernel.org>
To: takata@linux-m32r.org
Cc: linux-m32r@ml.linux-m32r.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] m32r: export __ndelay
Message-ID: <20080610222822.GK11685@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following build error:

<--  snip  -->

...
  MODPOST 1083 modules
ERROR: "__ndelay" [drivers/spi/spi_bitbang.ko] undefined!
...
make[2]: *** [__modpost] Error 1

<--  snip  -->

Reported-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 arch/m32r/lib/delay.c |    2 ++
 1 file changed, 2 insertions(+)

75460f5ec520539e33163ac455ffe4400da341c3 diff --git a/arch/m32r/lib/delay.c b/arch/m32r/lib/delay.c
index 59bfc34..ced549b 100644
--- a/arch/m32r/lib/delay.c
+++ b/arch/m32r/lib/delay.c
@@ -6,6 +6,7 @@
  */
 
 #include <linux/param.h>
+#include <linux/module.h>
 #ifdef CONFIG_SMP
 #include <linux/sched.h>
 #include <asm/current.h>
@@ -121,3 +122,4 @@ void __ndelay(unsigned long nsecs)
 {
 	__const_udelay(nsecs * 0x00005);  /* 2**32 / 1000000000 (rounded up) */
 }
+EXPORT_SYMBOL(__ndelay);

