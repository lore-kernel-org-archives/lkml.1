Return-Path: <linux-kernel-owner+w=401wt.eu-S933769AbXEERTi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933769AbXEERTi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2007 13:19:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933859AbXEERTh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 May 2007 13:19:37 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:38952 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933769AbXEERTf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2007 13:19:35 -0400
Date: Sat, 5 May 2007 19:19:35 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Andrew Morton <akpm@linux-foundation.org>, Anton Vorontsov <cbou@mail.ru>,
       David Woodhouse <dwmw2@infradead.org>
Cc: linux-kernel@vger.kernel.org
Subject: [-mm patch] drivers/battery/olpc_battery.c: fix compilation
Message-ID: <20070505171935.GG8975@stusta.de>
References: <20070505014955.8f3990b5.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070505014955.8f3990b5.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 05, 2007 at 01:49:55AM -0700, Andrew Morton wrote:
> 
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21/2.6.21-mm1/
> 
> 
> - Added the git-battery tree to the -mm lineup (Anton Vorontsov
>   <cbou@mail.ru>).  It presently generates mysterious depmod error messages.
>...
> Changes since 2.6.21-rc7-mm2:
>...
>  git-battery.patch
>...
>  git trees
>...

This patch fixes the following compile error:

<--  snip  -->

...
  CC      drivers/battery/olpc_battery.o
/home/bunk/linux/kernel-2.6/linux-2.6.21-mm1/drivers/battery/olpc_battery.c: In function ‘lock_ec’:
/home/bunk/linux/kernel-2.6/linux-2.6.21-mm1/drivers/battery/olpc_battery.c:42: error: ‘jiffies’ undeclared (first use in this function)
/home/bunk/linux/kernel-2.6/linux-2.6.21-mm1/drivers/battery/olpc_battery.c:42: error: (Each undeclared identifier is reported only once
/home/bunk/linux/kernel-2.6/linux-2.6.21-mm1/drivers/battery/olpc_battery.c:42: error: for each function it appears in.)
/home/bunk/linux/kernel-2.6/linux-2.6.21-mm1/drivers/battery/olpc_battery.c:42: error: ‘HZ’ undeclared (first use in this function)
/home/bunk/linux/kernel-2.6/linux-2.6.21-mm1/drivers/battery/olpc_battery.c:48: error: implicit declaration of function ‘time_after’
/home/bunk/linux/kernel-2.6/linux-2.6.21-mm1/drivers/battery/olpc_battery.c:53: error: implicit declaration of function ‘yield’
make[3]: *** [drivers/battery/olpc_battery.o] Error 1

<--  snip  -->

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---
--- linux-2.6.21-mm1/drivers/battery/olpc_battery.c.old	2007-05-05 19:05:17.000000000 +0200
+++ linux-2.6.21-mm1/drivers/battery/olpc_battery.c	2007-05-05 19:07:30.000000000 +0200
@@ -13,6 +13,8 @@
 #include <linux/platform_device.h>
 #include <linux/external_power.h>
 #include <linux/battery.h>
+#include <linux/jiffies.h>
+#include <linux/sched.h>
 #include <asm/io.h>
 
 #define wBAT_VOLTAGE     0xf900  /* *9.76/32,    mV   */

