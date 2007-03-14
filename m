Return-Path: <linux-kernel-owner+w=401wt.eu-S1422689AbXCNV5w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422689AbXCNV5w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 17:57:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422688AbXCNV5w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 17:57:52 -0400
Received: from mail.gmx.net ([213.165.64.20]:53022 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1422693AbXCNV5v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 17:57:51 -0400
X-Authenticated: #27750187
X-Provags-ID: V01U2FsdGVkX1+6mLdsIIu6sF1pQx1zwjv3dP+EA/E1P7G6WXS9cg
	OCjdKgvj+Smxqp
Date: Wed, 14 Mar 2007 22:57:47 +0100
From: Klaus Kudielka <klaus.kudielka@gmx.net>
To: linux-kernel@vger.kernel.org
Cc: ivan@cyclades.com
Subject: [PATCH] fix cyclades.h for x86_64 (and probably others)
Message-ID: <20070314215746.GA7781@mars.oe1kib.ampr.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

at least on x86_64 the present cyclades.h is broken due to the wrong size
of uclong. This affects, of course, both the kernel and the user-level
utilities. The symptom is that cyzload refuses to load the firmware.
I also managed to freeze the machine when unloading the module.

The patch below fixes this in an architecture-independent way.
I have tested it with 2.6.19 and the driver works fine again with a
Cyclades-Z on an Athlon 64 X2.

Please CC to me personally, as I am not subscribed to the list.
Thanks, Klaus

--- include/linux/cyclades.h.ORIG       2007-02-23 12:48:19.000000000 +0000
+++ include/linux/cyclades.h    2007-03-14 21:24:35.000000000 +0000
@@ -149,14 +149,12 @@
  *     architectures and compilers.
  */
 
-#if defined(__alpha__)
-typedef unsigned long  ucdouble;       /* 64 bits, unsigned */
-typedef unsigned int   uclong;         /* 32 bits, unsigned */
-#else
-typedef unsigned long  uclong;         /* 32 bits, unsigned */
-#endif
-typedef unsigned short ucshort;        /* 16 bits, unsigned */
-typedef unsigned char  ucchar;         /* 8 bits, unsigned */
+#include <asm/types.h>
+
+typedef __u64  ucdouble;       /* 64 bits, unsigned */
+typedef __u32  uclong;         /* 32 bits, unsigned */
+typedef __u16  ucshort;        /* 16 bits, unsigned */
+typedef __u8   ucchar;         /* 8 bits, unsigned */
 
 /*
  *     Memory Window Sizes

