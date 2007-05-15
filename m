Return-Path: <linux-kernel-owner+w=401wt.eu-S1760936AbXEOEar@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760936AbXEOEar (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 00:30:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755886AbXEOEak
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 00:30:40 -0400
Received: from lixom.net ([66.141.50.11]:40870 "EHLO mail.lixom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755016AbXEOEaj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 00:30:39 -0400
Date: Mon, 14 May 2007 23:33:43 -0500
To: paulus@samba.org
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       linux-pcmcia@lists.infradead.org
Subject: [PATCH v2] pcmcia: ppc64 needs 32-bit ioaddr_t
Message-ID: <20070515043343.GA6561@lixom.net>
References: <20070512143105.GA12890@lixom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070512143105.GA12890@lixom.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: olof@lixom.net (Olof Johansson)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

ppc64 really needs ioaddr_t to be 32-bit, since I/O beyond the
first PCI bus might be mapped at a higher range.

While the type is exported to userspace, there hasn't been any platforms
with PCMCIA on 64-bit powerpc until now, so changing it won't regress
any existing users. Besides, those interfaces are overdue for removal
already.


Signed-off-by: Olof Johansson <olof@lixom.net>

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
