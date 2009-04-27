Return-Path: <linux-kernel-owner+w=401wt.eu-S1757429AbZD0Omm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757429AbZD0Omm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 10:42:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757005AbZD0OlW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 10:41:22 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:62327 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756815AbZD0OlS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 10:41:18 -0400
Message-Id: <20090427143737.748969927@arndb.de>
From: <arnd@arndb.de>
To: unlisted-recipients:; (no To-header on input)
Date: Mon, 27 Apr 2009 10:41:18 -0400
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From arnd@arndb.de Mon Apr 27 16:28:40 2009
References: <20090427142010.587518220@arndb.de>
User-Agent: quilt/0.46-1
Date: Mon, 27 Apr 2009 16:20:17 +0200
From: arnd@arndb.de
To: linux-kernel@vger.kernel.org
Cc: john.williams@petalogix.com,
 monstr@monstr.eu,
 linux-api@vger.kernel.org,
 linux-arch@vger.kernel.org,
 liqin.chen@sunplusct.com,
 Sam Ravnborg <sam@ravnborg.org>,
 Remis Lima Baima <remis.developer@googlemail.com>
Subject: [RFC 07/17] asm-generic: make generic mman.h header generic
Content-Disposition: inline; filename=add-generic-mman-h.patch
X-Provags-ID: V01U2FsdGVkX19IU2MJc665e95jGBVpW8SuRMZdefJXXc5QAgD
 xnKqfDZvOGCeXFGyQ076PtX6UL3+Fulj7xqbS/Hj/kXij0w62N
 ua/vtP6sGyl+F5NSGKs/A==

The existing asm-generic/mman.h file is missing some definitions
if you want to use it out of the box. This renames the old file
and adds a new one based on the x86 implementation that can be
used for most architectures that copied from x86.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Remis Lima Baima <remis.developer@googlemail.com>
---
---
 include/asm-generic/Kbuild |    1 	1 +	0 -	0 !
 include/asm-generic/mman.h |   18 	18 +	0 -	0 !
 2 files changed, 19 insertions(+)

Index: linux-2.6/include/asm-generic/mman.h
===================================================================
--- /dev/null
+++ linux-2.6/include/asm-generic/mman.h
@@ -0,0 +1,18 @@
+#ifndef __ASM_GENERIC_MMAN_H
+#define __ASM_GENERIC_MMAN_H
+
+#include <asm-generic/mman-common.h>
+
+#define MAP_GROWSDOWN	0x0100		/* stack-like segment */
+#define MAP_DENYWRITE	0x0800		/* ETXTBSY */
+#define MAP_EXECUTABLE	0x1000		/* mark it as an executable */
+#define MAP_LOCKED	0x2000		/* pages are locked */
+#define MAP_NORESERVE	0x4000		/* don't check for reservations */
+#define MAP_POPULATE	0x8000		/* populate (prefault) pagetables */
+#define MAP_NONBLOCK	0x10000		/* do not block on IO */
+#define MAP_STACK	0x20000		/* give out an address that is best suited for process/thread stacks */
+
+#define MCL_CURRENT	1		/* lock all current mappings */
+#define MCL_FUTURE	2		/* lock all future mappings */
+
+#endif /* __ASM_GENERIC_MMAN_H */
Index: linux-2.6/include/asm-generic/Kbuild
===================================================================
--- linux-2.6.orig/include/asm-generic/Kbuild
+++ linux-2.6/include/asm-generic/Kbuild
@@ -3,6 +3,7 @@ header-y += errno.h
 header-y += fcntl.h
 header-y += ioctl.h
 header-y += mman-common.h
+header-y += mman.h
 header-y += poll.h
 header-y += signal-defs.h
 header-y += signal.h

-- 

