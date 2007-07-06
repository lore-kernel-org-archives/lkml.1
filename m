Return-Path: <linux-kernel-owner+w=401wt.eu-S1754796AbXGFWx5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754796AbXGFWx5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 18:53:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754077AbXGFWxk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 18:53:40 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:53082 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753265AbXGFWxj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 18:53:39 -0400
Date: Sat, 7 Jul 2007 00:54:09 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [2.6.22 regression fix] include/linux/kallsyms.h must #include
	<linux/errno.h>
Message-ID: <20070706225409.GS3492@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following 2.6.22 regression with CONFIG_KALLSYMS=n:

<--  snip  -->

...
  CC      arch/m32r/kernel/traps.o
In file included from /home/bunk/linux/kernel-2.6/linux-2.6.22-rc6-mm1/arch/m32r/kernel/traps.c:14:
/home/bunk/linux/kernel-2.6/linux-2.6.22-rc6-mm1/include/linux/kallsyms.h: In function 'lookup_symbol_name':
/home/bunk/linux/kernel-2.6/linux-2.6.22-rc6-mm1/include/linux/kallsyms.h:66: error: 'ERANGE' undeclared (first use in this function)
/home/bunk/linux/kernel-2.6/linux-2.6.22-rc6-mm1/include/linux/kallsyms.h:66: error: (Each undeclared identifier is reported only once
/home/bunk/linux/kernel-2.6/linux-2.6.22-rc6-mm1/include/linux/kallsyms.h:66: error: for each function it appears in.)
/home/bunk/linux/kernel-2.6/linux-2.6.22-rc6-mm1/include/linux/kallsyms.h: In function 'lookup_symbol_attrs':
/home/bunk/linux/kernel-2.6/linux-2.6.22-rc6-mm1/include/linux/kallsyms.h:71: error: 'ERANGE' undeclared (first use in this function)
make[2]: *** [arch/m32r/kernel/traps.o] Error 1

<--  snip  -->

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---
--- linux-2.6.22-rc6-mm1/include/linux/kallsyms.h.old	2007-07-06 05:18:28.000000000 +0200
+++ linux-2.6.22-rc6-mm1/include/linux/kallsyms.h	2007-07-06 05:19:09.000000000 +0200
@@ -5,6 +5,7 @@
 #ifndef _LINUX_KALLSYMS_H
 #define _LINUX_KALLSYMS_H
 
+#include <linux/errno.h>
 
 #define KSYM_NAME_LEN 127
 #define KSYM_SYMBOL_LEN (sizeof("%s+%#lx/%#lx [%s]") + KSYM_NAME_LEN +	\

