Return-Path: <linux-kernel-owner+w=401wt.eu-S1754524AbXFYAph@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754524AbXFYAph (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2007 20:45:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751850AbXFYApa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jun 2007 20:45:30 -0400
Received: from lixom.net ([66.141.50.11]:49002 "EHLO mail.lixom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751376AbXFYAp3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2007 20:45:29 -0400
Date: Sun, 24 Jun 2007 19:54:39 -0500
To: linux-kernel@vger.kernel.org, linux-pcmcia@lists.infradead.org
Cc: paulus@samba.org, linuxppc-dev@ozlabs.org, akpm@osdl.org
Subject: [PATCH] pcmcia: ppc64 needs 32-bit ioaddr_t
Message-ID: <20070625005439.GA31289@lixom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
From: olof@lixom.net (Olof Johansson)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

ppc64 really needs ioaddr_t to be 32-bit, since I/O addresses really are
MMIO addresses, and remapped at an offset that's well above 16 bits in
some cases.

While the type is exported to userspace, there hasn't been any platforms
with PCMCIA on 64-bit powerpc until now, so changing it won't regress
any existing users.


Signed-off-by: Olof Johansson <olof@lixom.net>
Acked-by: Paul Mackerras <paulus@samba.org>

Index: 2.6.21/include/pcmcia/cs_types.h
===================================================================
--- 2.6.21.orig/include/pcmcia/cs_types.h
+++ 2.6.21/include/pcmcia/cs_types.h
@@ -21,7 +21,7 @@
 #include <sys/types.h>
 #endif
 
-#if defined(__arm__) || defined(__mips__)
+#if defined(__arm__) || defined(__mips__) || defined(__powerpc64__)
 /* This (ioaddr_t) is exposed to userspace & hence cannot be changed. */
 typedef u_int   ioaddr_t;
 #else
