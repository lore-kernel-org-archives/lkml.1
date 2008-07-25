Return-Path: <linux-kernel-owner+w=401wt.eu-S1753938AbYGYUEY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753938AbYGYUEY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 16:04:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751396AbYGYUEQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 16:04:16 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:59551 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751373AbYGYUEP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 16:04:15 -0400
Date: Fri, 25 Jul 2008 23:03:48 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Nicolas Ferre <nicolas.ferre@atmel.com>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>,
       Andrew Victor <linux@maxim.org.za>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] include/video/atmel_lcdc.h must #include
	<linux/workqueue.h>
Message-ID: <20080725200348.GG19310@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following compile error caused by
commit d22579b837358cbef12ccca5adaf7e93ae09ab7a
(atmel_lcdfb: FIFO underflow management):

<--  snip  -->

...
  CC      arch/avr32/boards/atstk1000/atstk1004.o
In file included from /home/bunk/linux/kernel-2.6/git/linux-2.6/arch/avr32/boards/atstk1000/atstk1004.c:21:
/home/bunk/linux/kernel-2.6/git/linux-2.6/include/video/atmel_lcdc.h:40: error: field 'task' has incomplete type
make[2]: *** [arch/avr32/boards/atstk1000/atstk1004.o] Error 1

<--  snip  -->

Reported-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
1044a292a0de728d51b21a5b10cb459484d2a0aa 
diff --git a/include/video/atmel_lcdc.h b/include/video/atmel_lcdc.h
index 1ccf462..613173b 100644
--- a/include/video/atmel_lcdc.h
+++ b/include/video/atmel_lcdc.h
@@ -22,6 +22,7 @@
 #ifndef __ATMEL_LCDC_H__
 #define __ATMEL_LCDC_H__
 
+#include <linux/workqueue.h>
 
 /* Way LCD wires are connected to the chip:
  * Some Atmel chips use BGR color mode (instead of standard RGB)
