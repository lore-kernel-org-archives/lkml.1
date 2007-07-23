Return-Path: <linux-kernel-owner+w=401wt.eu-S932718AbXGWKW0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932718AbXGWKW0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 06:22:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759393AbXGWKWR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 06:22:17 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:41897 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759390AbXGWKWQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 06:22:16 -0400
Date: Mon, 23 Jul 2007 12:21:40 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: chris@zankel.net, linux-kernel@vger.kernel.org, Jan Dittmer <jdi@l4x.org>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Subject: [2.6.23 regression fix] include/asm-xtensa/io.h must #include
	<asm/page.h>
Message-ID: <20070723102140.GG26212@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following compile error:

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

This patch has been sent on:
- 7 Jul 2007

--- linux-2.6.22-rc6-mm1/include/asm-xtensa/io.h.old	2007-07-07 10:16:54.000000000 +0200
+++ linux-2.6.22-rc6-mm1/include/asm-xtensa/io.h	2007-07-07 10:17:08.000000000 +0200
@@ -13,6 +13,7 @@
 
 #ifdef __KERNEL__
 #include <asm/byteorder.h>
+#include <asm/page.h>
 
 #include <linux/types.h>
 

