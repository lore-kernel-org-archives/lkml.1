Return-Path: <linux-kernel-owner+w=401wt.eu-S1756036AbYG3FHA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756036AbYG3FHA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 01:07:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751278AbYG3FGw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 01:06:52 -0400
Received: from ausmtp04.au.ibm.com ([202.81.18.152]:38974 "EHLO
	ausmtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751167AbYG3FGu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 01:06:50 -0400
Date: Wed, 30 Jul 2008 14:59:13 +1000
From: Stephen Rothwell <sfr@au1.ibm.com>
To: "David S. Miller" <davem@davemloft.net>
Cc: "William L.Irwin" <wli@holomorphy.com>, sparclinux@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] sparc: merge of_platform_{32,64}.h
Message-Id: <20080730145913.10c124a9.sfr@au.ibm.com>
Organization: IBM Ozlabs Linux Technology Centre
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The only difference between these files is that the 64 bit version has an
extra declaration.

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 arch/sparc/include/asm/of_platform.h    |   27 +++++++++++++++++++++++----
 arch/sparc/include/asm/of_platform_32.h |   24 ------------------------
 arch/sparc/include/asm/of_platform_64.h |   25 -------------------------
 3 files changed, 23 insertions(+), 53 deletions(-)
 delete mode 100644 arch/sparc/include/asm/of_platform_32.h
 delete mode 100644 arch/sparc/include/asm/of_platform_64.h

This has been built for defconfig for sparc32 and sparc64.

diff --git a/arch/sparc/include/asm/of_platform.h b/arch/sparc/include/asm/of_platform.h
index aa69977..972352f 100644
--- a/arch/sparc/include/asm/of_platform.h
+++ b/arch/sparc/include/asm/of_platform.h
@@ -1,8 +1,27 @@
 #ifndef ___ASM_SPARC_OF_PLATFORM_H
 #define ___ASM_SPARC_OF_PLATFORM_H
-#if defined(__sparc__) && defined(__arch64__)
-#include <asm/of_platform_64.h>
-#else
-#include <asm/of_platform_32.h>
+/*
+ *    Copyright (C) 2006 Benjamin Herrenschmidt, IBM Corp.
+ *			 <benh@kernel.crashing.org>
+ *    Modified for Sparc by merging parts of asm/of_device.h
+ *		by Stephen Rothwell
+ *
+ *  This program is free software; you can redistribute it and/or
+ *  modify it under the terms of the GNU General Public License
+ *  as published by the Free Software Foundation; either version
+ *  2 of the License, or (at your option) any later version.
+ *
+ */
+
+/* This is just here during the transition */
+#include <linux/of_platform.h>
+
+#ifdef CONFIG_SPARC64
+extern struct bus_type isa_bus_type;
 #endif
+extern struct bus_type ebus_bus_type;
+extern struct bus_type sbus_bus_type;
+
+#define of_bus_type	of_platform_bus_type	/* for compatibility */
+
 #endif
diff --git a/arch/sparc/include/asm/of_platform_32.h b/arch/sparc/include/asm/of_platform_32.h
deleted file mode 100644
index 723f7c9..0000000
--- a/arch/sparc/include/asm/of_platform_32.h
+++ /dev/null
@@ -1,24 +0,0 @@
-#ifndef _ASM_SPARC_OF_PLATFORM_H
-#define _ASM_SPARC_OF_PLATFORM_H
-/*
- *    Copyright (C) 2006 Benjamin Herrenschmidt, IBM Corp.
- *			 <benh@kernel.crashing.org>
- *    Modified for Sparc by merging parts of asm/of_device.h
- *		by Stephen Rothwell
- *
- *  This program is free software; you can redistribute it and/or
- *  modify it under the terms of the GNU General Public License
- *  as published by the Free Software Foundation; either version
- *  2 of the License, or (at your option) any later version.
- *
- */
-
-/* This is just here during the transition */
-#include <linux/of_platform.h>
-
-extern struct bus_type ebus_bus_type;
-extern struct bus_type sbus_bus_type;
-
-#define of_bus_type	of_platform_bus_type	/* for compatibility */
-
-#endif	/* _ASM_SPARC_OF_PLATFORM_H */
diff --git a/arch/sparc/include/asm/of_platform_64.h b/arch/sparc/include/asm/of_platform_64.h
deleted file mode 100644
index 4f66a5f..0000000
--- a/arch/sparc/include/asm/of_platform_64.h
+++ /dev/null
@@ -1,25 +0,0 @@
-#ifndef _ASM_SPARC64_OF_PLATFORM_H
-#define _ASM_SPARC64_OF_PLATFORM_H
-/*
- *    Copyright (C) 2006 Benjamin Herrenschmidt, IBM Corp.
- *			 <benh@kernel.crashing.org>
- *    Modified for Sparc by merging parts of asm/of_device.h
- *		by Stephen Rothwell
- *
- *  This program is free software; you can redistribute it and/or
- *  modify it under the terms of the GNU General Public License
- *  as published by the Free Software Foundation; either version
- *  2 of the License, or (at your option) any later version.
- *
- */
-
-/* This is just here during the transition */
-#include <linux/of_platform.h>
-
-extern struct bus_type isa_bus_type;
-extern struct bus_type ebus_bus_type;
-extern struct bus_type sbus_bus_type;
-
-#define of_bus_type	of_platform_bus_type	/* for compatibility */
-
-#endif	/* _ASM_SPARC64_OF_PLATFORM_H */
-- 
1.5.6.3

-- 
Cheers,
Stephen Rothwell                    sfr@au.ibm.com
IBM OzLabs Linux Technology Centre
