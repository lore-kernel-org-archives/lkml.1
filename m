Return-Path: <linux-kernel-owner+w=401wt.eu-S1751243AbXDKIxW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751243AbXDKIxW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 04:53:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751450AbXDKIxW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 04:53:22 -0400
Received: from jurassic.park.msu.ru ([195.208.223.243]:1557 "EHLO
	jurassic.park.msu.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751243AbXDKIxV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 04:53:21 -0400
X-Greylist: delayed 1540 seconds by postgrey-1.27 at vger.kernel.org; Wed, 11 Apr 2007 04:53:20 EDT
Date: Wed, 11 Apr 2007 12:28:08 +0400
From: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Richard Henderson <rth@twiddle.net>, Jay Estabrook <jay.estabrook@hp.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 1/7] ALPHA: fix BOOTP image creation
Message-ID: <20070411122808.B17547@jurassic.park.msu.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.2.5i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Files:

arch/alpha/boot/bootpz.c

	Create a dummy "__kmalloc()" to satisfy the loader; never called.

arch/alpha/boot/tools/objstrip.c

	Remove an include that is now (2.6.x) unnecessary.



Signed-off-by: Jay Estabrook <jay.estabrook@hp.com>
Signed-off-by: Ivan Kokshaysky <ink@jurassic.park.msu.ru>

---

diff -Naurp a/arch/alpha/boot/bootpz.c b/arch/alpha/boot/bootpz.c
--- a/arch/alpha/boot/bootpz.c	2007-02-04 13:44:54.000000000 -0500
+++ b/arch/alpha/boot/bootpz.c	2007-03-16 11:07:33.000000000 -0400
@@ -467,3 +467,9 @@ start_kernel(void)
 #endif
 	runkernel();
 }
+
+ /* dummy function, should never be called. */
+void *__kmalloc(size_t size, gfp_t flags)
+{
+	return (void *)NULL;
+}
diff -Naurp a/arch/alpha/boot/tools/objstrip.c b/arch/alpha/boot/tools/objstrip.c
--- a/arch/alpha/boot/tools/objstrip.c	2007-02-04 13:44:54.000000000 -0500
+++ b/arch/alpha/boot/tools/objstrip.c	2007-02-14 14:40:02.000000000 -0500
@@ -25,7 +25,6 @@
 #include <linux/a.out.h>
 #include <linux/coff.h>
 #include <linux/param.h>
-#include <linux/string.h>
 #ifdef __ELF__
 # include <linux/elf.h>
 #endif
