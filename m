Return-Path: <linux-kernel-owner+w=401wt.eu-S938427AbXHILIE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938427AbXHILIE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 07:08:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756682AbXHILH5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 07:07:57 -0400
Received: from ozlabs.org ([203.10.76.45]:34690 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754517AbXHILH4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 07:07:56 -0400
Subject: [PATCH] ld.so on FC7 is mmap'ing shared libraries right in over
	guest memory.
From: Rusty Russell <rusty@rustcorp.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       ron minnich <rminnich@gmail.com>, lguest <lguest@ozlabs.org>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 09 Aug 2007 21:07:24 +1000
Message-Id: <1186657645.17752.60.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ronald G. Minnich <rminnich@gmail.com>

[ FC7 maps shared libraries very low, where the launcher maps guest's
physical memory.  Quick fix is to link Launcher static, real fix is for
2.6.24. ]

-static is a simple fix. I expect this problem will be more common than we
like, as different distro's make different "improvements" to ld.so

Signed-off-by: Ronald G. Minnich <rminnich@gmail.com>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff --git a/Documentation/lguest/Makefile b/Documentation/lguest/Makefile
index 31e794e..60136d8 100644
--- a/Documentation/lguest/Makefile
+++ b/Documentation/lguest/Makefile
@@ -13,7 +13,9 @@ LGUEST_GUEST_TOP := ($(CONFIG_PAGE_OFFSET) - 0x08000000)
 
 CFLAGS:=-Wall -Wmissing-declarations -Wmissing-prototypes -O3 -Wl,-T,lguest.lds
 LDLIBS:=-lz
-
+# Removing this works for some versions of ld.so (eg. Ubuntu Feisty) and
+# not others (eg. FC7).
+LDFLAGS+=-static
 all: lguest.lds lguest
 
 # The linker script on x86 is so complex the only way of creating one


