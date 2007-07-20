Return-Path: <linux-kernel-owner+w=401wt.eu-S935540AbXGTXdM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935540AbXGTXdM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 19:33:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751386AbXGTXc7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 19:32:59 -0400
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:37869 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758828AbXGTXc6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 19:32:58 -0400
Message-Id: <20070720225817.050195257@ayoka.breakpoint.cc>
User-Agent: quilt/0.46-1
Date: Sat, 21 Jul 2007 00:58:00 +0200
From: Sebastian Siewior <sebastian@breakpoint.cc>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] compat_ioctl requires CONFIG_BLOCK
Content-Disposition: inline; filename=compat_ioctl_fix.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Got with randconfig
include/linux/loop.h:66: error: expected specifier-qualifier-list before
'request_queue_t'
make[1]: *** [fs/compat_ioctl.o] Error 1

parts of compat ioctl require CONFIG_BLOCK to be set.

Signed-off-by: Sebastian Siewior <sebastian@breakpoint.cc>
Index: b/fs/compat_ioctl.c
===================================================================
--- a/fs/compat_ioctl.c
+++ b/fs/compat_ioctl.c
@@ -63,7 +63,9 @@
 #include <linux/wireless.h>
 #include <linux/atalk.h>
 #include <linux/blktrace_api.h>
+#ifdef CONFIG_BLOCK
 #include <linux/loop.h>
+#endif
 
 #include <net/bluetooth/bluetooth.h>
 #include <net/bluetooth/hci.h>
@@ -3491,8 +3493,10 @@ HANDLE_IOCTL(LPSETTIMEOUT, lp_timeout_tr
 IGNORE_IOCTL(VFAT_IOCTL_READDIR_BOTH32)
 IGNORE_IOCTL(VFAT_IOCTL_READDIR_SHORT32)
 
+#ifdef CONFIG_BLOCK
 /* loop */
 IGNORE_IOCTL(LOOP_CLR_FD)
+#endif
 };
 
 #define IOCTL_HASHSIZE 256

-- 

