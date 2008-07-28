Return-Path: <linux-kernel-owner+w=401wt.eu-S1757433AbYG1P2O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757433AbYG1P2O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 11:28:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752410AbYG1P17
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 11:27:59 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:60335 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751717AbYG1P17 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 11:27:59 -0400
Date: Mon, 28 Jul 2008 18:27:16 +0300
From: Adrian Bunk <bunk@kernel.org>
To: David Brownell <dbrownell@users.sourceforge.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [2.6 patch] asm-generic/gpio.h must #include <linux/errno.h>
Message-ID: <20080728152716.GC30612@cs181140183.pp.htv.fi>
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
  CC      arch/mips/kernel/gpio_txx9.o
In file included from 
/home/bunk/linux/kernel-2.6/git/linux-2.6/include/asm-mips/mach-generic/gpio.h:19,
                 from include2/asm/gpio.h:4,
                 from /home/bunk/linux/kernel-2.6/git/linux-2.6/include/linux/gpio.h:7,
                 from /home/bunk/linux/kernel-2.6/git/linux-2.6/arch/mips/kernel/gpio_txx9.c:13:
/home/bunk/linux/kernel-2.6/git/linux-2.6/include/asm-generic/gpio.h: In function 'gpio_export':
/home/bunk/linux/kernel-2.6/git/linux-2.6/include/asm-generic/gpio.h:163: error: 'ENOSYS' undeclared (first use in this function)
/home/bunk/linux/kernel-2.6/git/linux-2.6/include/asm-generic/gpio.h:163: error: (Each undeclared identifier is reported only once
/home/bunk/linux/kernel-2.6/git/linux-2.6/include/asm-generic/gpio.h:163: error: for each function it appears in.)
make[2]: *** [arch/mips/kernel/gpio_txx9.o] Error 1

<--  snip  -->

Reported-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
ae0b61bdf413151d7587e9488c8e60dd3ff8f20d 
diff --git a/include/asm-generic/gpio.h b/include/asm-generic/gpio.h
index c764a8f..0f99ad3 100644
--- a/include/asm-generic/gpio.h
+++ b/include/asm-generic/gpio.h
@@ -2,6 +2,7 @@
 #define _ASM_GENERIC_GPIO_H
 
 #include <linux/types.h>
+#include <linux/errno.h>
 
 #ifdef CONFIG_GPIOLIB
 

