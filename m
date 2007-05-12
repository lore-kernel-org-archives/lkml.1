Return-Path: <linux-kernel-owner+w=401wt.eu-S1759987AbXELO2c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759987AbXELO2c (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2007 10:28:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756928AbXELO2Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 May 2007 10:28:25 -0400
Received: from lixom.net ([66.141.50.11]:47671 "EHLO mail.lixom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755579AbXELO2Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2007 10:28:24 -0400
Date: Sat, 12 May 2007 09:31:05 -0500
To: paulus@samba.org
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       linux-pcmcia@lists.infradead.org
Subject: [PATCH] pcmcia: ppc64 needs 64-bit ioaddr_t
Message-ID: <20070512143105.GA12890@lixom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
From: olof@lixom.net (Olof Johansson)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

ppc64 really needs ioaddr_t to be 64-bit, since I/O addresses really
are MMIO addresses, and remapped to a high range.

While the type is exported to userspace, there hasn't been any platforms
with PCMCIA on 64-bit powerpc until now, so changing it won't regress
any existing users.


Signed-off-by: Olof Johansson <olof@lixom.net>

Index: 2.6.21/include/pcmcia/cs_types.h
===================================================================
--- 2.6.21.orig/include/pcmcia/cs_types.h
+++ 2.6.21/include/pcmcia/cs_types.h
@@ -21,12 +21,17 @@
 #include <sys/types.h>
 #endif
 
+#if defined(__powerpc64__)
+/* I/O addresses are really MMIO addresses on PPC, and can thus be 64 bits */
+typedef unsigned long ioaddr_t;
+#else
 #if defined(__arm__) || defined(__mips__)
 /* This (ioaddr_t) is exposed to userspace & hence cannot be changed. */
 typedef u_int   ioaddr_t;
 #else
 typedef u_short	ioaddr_t;
 #endif
+#endif
 typedef unsigned long kio_addr_t;
 
 typedef u_short	socket_t;
