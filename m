Return-Path: <linux-kernel-owner+w=401wt.eu-S1764773AbXKQSRn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764773AbXKQSRn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2007 13:17:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755727AbXKQSRe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Nov 2007 13:17:34 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:46451 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756850AbXKQSRd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2007 13:17:33 -0500
Date: Sat, 17 Nov 2007 10:15:52 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, tglx@tglx.de, akpm@linux-foundation.org
Subject: [patch] Printk kernel version in WARN_ON
Message-ID: <20071117101552.2a7f34cb@laptopd505.fenrus.org>
Organization: Intel
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

today, all oopses contain a version number of the kernel, which is nice
because the people who actually do bother to read the oops get this
vital bit of information always without having to ask the reporter in
another round trip.

However, WARN_ON() right now lacks this information; the patch below
adds this. This information is essential for getting people to use
their time effectively when looking at these things; in addition, it's
essential for tools that try to collect statistics about defects.

Please consider, maybe even for 2.6.24 since its so simple and
important for long term quality

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>

--- linux-2.6.24-rc3/include/asm-generic/bug.h.org	2007-11-17 09:55:00.000000000 -0800
+++ linux-2.6.24-rc3/include/asm-generic/bug.h	2007-11-17 10:11:23.000000000 -0800
@@ -2,6 +2,7 @@
 #define _ASM_GENERIC_BUG_H
 
 #include <linux/compiler.h>
+#include <linux/utsrelease.h>
 
 #ifdef CONFIG_BUG
 
@@ -35,8 +36,8 @@ struct bug_entry {
 #define WARN_ON(condition) ({						\
 	int __ret_warn_on = !!(condition);				\
 	if (unlikely(__ret_warn_on)) {					\
-		printk("WARNING: at %s:%d %s()\n", __FILE__,		\
-			__LINE__, __FUNCTION__);			\
+		printk("WARNING: at %s:%d %s()  (%s)\n", __FILE__,	\
+			__LINE__, __FUNCTION__, UTS_RELEASE);		\
 		dump_stack();						\
 	}								\
 	unlikely(__ret_warn_on);					\


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
