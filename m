Return-Path: <linux-kernel-owner+w=401wt.eu-S1752858AbXLaWh7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752858AbXLaWh7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Dec 2007 17:37:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751085AbXLaWhw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Dec 2007 17:37:52 -0500
Received: from lixom.net ([66.141.50.11]:44825 "EHLO mail.lixom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751036AbXLaWhv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Dec 2007 17:37:51 -0500
Date: Mon, 31 Dec 2007 16:45:58 -0600
From: Olof Johansson <olof@lixom.net>
To: paulus@samba.org
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [2.6.24] Add PPC nvram ioctls to compat_ioctl
Message-ID: <20071231224558.GA16517@lixom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the following console warning when running 'nvsetenv', and makes
setting of new variables work again:

ioctl32(nvsetenv:4022): Unknown cmd fd(3) cmd(20007043){t:'p';sz:0}
arg(00000003) on /dev/nvram

That's the IOC_NVRAM_SYNC call.


Signed-off-by: Olof Johansson <olof@lixom.net>

diff --git a/fs/compat_ioctl.c b/fs/compat_ioctl.c
index e8b7c3a..7be6765 100644
--- a/fs/compat_ioctl.c
+++ b/fs/compat_ioctl.c
@@ -113,6 +113,10 @@
 #include <asm/fbio.h>
 #endif
 
+#ifdef CONFIG_PPC
+#include <asm/nvram.h>
+#endif
+
 static int do_ioctl32_pointer(unsigned int fd, unsigned int cmd,
 			      unsigned long arg, struct file *f)
 {
@@ -2859,6 +2863,13 @@ IGNORE_IOCTL(FBIOGETCMAP32)
 IGNORE_IOCTL(FBIOSCURSOR32)
 IGNORE_IOCTL(FBIOGCURSOR32)
 #endif
+
+#ifdef CONFIG_PPC
+/* PPC-specific NVRAM IOCTLs */
+COMPATIBLE_IOCTL(OBSOLETE_PMAC_NVRAM_GET_OFFSET)
+COMPATIBLE_IOCTL(IOC_NVRAM_GET_OFFSET)
+COMPATIBLE_IOCTL(IOC_NVRAM_SYNC)
+#endif
 };
 
 #define IOCTL_HASHSIZE 256
