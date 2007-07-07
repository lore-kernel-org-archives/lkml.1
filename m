Return-Path: <linux-kernel-owner+w=401wt.eu-S1754535AbXGGIas@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754535AbXGGIas (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2007 04:30:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751033AbXGGIaj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jul 2007 04:30:39 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:53323 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752145AbXGGIaj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2007 04:30:39 -0400
Date: Sat, 7 Jul 2007 10:31:09 +0200
From: Adrian Bunk <bunk@stusta.de>
To: chris@zankel.net
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] include/asm-xtensa/io.h must #include <asm/page.h>
Message-ID: <20070707083109.GG3492@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following compile error with 
-Werror-implicit-function-declaration:

<--  snip  -->

...
  CC      kernel/time/clocksource.o
In file included from 
/home/bunk/linux/kernel-2.6/linux-2.6.22-rc6-mm1/include/linux/clocksource.h:18,
                 from 
/home/bunk/linux/kernel-2.6/linux-2.6.22-rc6-mm1/kernel/time/clocksource.c:27:
include2/asm/io.h: In function 'virt_to_phys':
include2/asm/io.h:46: error: implicit declaration of function '__pa'
include2/asm/io.h: In function 'phys_to_virt':
include2/asm/io.h:51: error: implicit declaration of function '__va'
include2/asm/io.h:51: warning: return makes pointer from integer without a cast
make[3]: *** [kernel/time/clocksource.o] Error 1


<--  snip  -->

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---
--- linux-2.6.22-rc6-mm1/include/asm-xtensa/io.h.old	2007-07-07 10:16:54.000000000 +0200
+++ linux-2.6.22-rc6-mm1/include/asm-xtensa/io.h	2007-07-07 10:17:08.000000000 +0200
@@ -13,6 +13,7 @@
 
 #ifdef __KERNEL__
 #include <asm/byteorder.h>
+#include <asm/page.h>
 
 #include <linux/types.h>
 

