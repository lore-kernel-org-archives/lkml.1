Return-Path: <linux-kernel-owner+w=401wt.eu-S1753714AbZBWJf2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753714AbZBWJf2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 04:35:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752286AbZBWJfQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 04:35:16 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:43429 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752198AbZBWJfP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 04:35:15 -0500
Subject: [PATCH] kmemcheck: Disable SLUB and SLAB debugging when kmemcheck
	is enabled
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, vegard.nossum@gmail.com,
       cl@linux-foundation.org
Date: Mon, 23 Feb 2009 11:35:12 +0200
Message-Id: <1235381712.6216.22.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pekka Enberg <penberg@cs.helsinki.fi>

Enabling kmemcheck in Kconfig is a painful experience. Lets make it a
tad bit easier by inverting the dependencies to SLUB and SLAB debugging.
As kmemcheck is more powerful than slab debugging, disable the latter
functionality if an user enables kmemcheck.

Cc: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Christoph Lameter <cl@linux-foundation.org>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 arch/x86/Kconfig.debug |    2 +-
 init/Kconfig           |    2 +-
 lib/Kconfig.debug      |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/Kconfig.debug b/arch/x86/Kconfig.debug
index de186c5..3d1d593 100644
--- a/arch/x86/Kconfig.debug
+++ b/arch/x86/Kconfig.debug
@@ -276,7 +276,7 @@ menuconfig KMEMCHECK
 	bool "kmemcheck: trap use of uninitialized memory"
 	depends on X86
 	depends on !X86_USE_3DNOW
-	depends on (SLUB && !SLUB_DEBUG_ON) || (SLAB && !DEBUG_SLAB)
+	depends on SLUB || SLAB
 	depends on !CC_OPTIMIZE_FOR_SIZE
 	depends on !DEBUG_PAGEALLOC
 	depends on !FUNCTION_TRACER
diff --git a/init/Kconfig b/init/Kconfig
index f068071..36617a4 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -890,7 +890,7 @@ config PCI_QUIRKS
 config SLUB_DEBUG
 	default y
 	bool "Enable SLUB debugging support" if EMBEDDED
-	depends on SLUB && SYSFS
+	depends on SLUB && SYSFS && !KMEMCHECK
 	help
 	  SLUB has extensive debug support features. Disabling these can
 	  result in significant savings in code size. This also disables
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 29044f5..768e426 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -262,7 +262,7 @@ config DEBUG_OBJECTS_ENABLE_DEFAULT
 
 config DEBUG_SLAB
 	bool "Debug slab memory allocations"
-	depends on DEBUG_KERNEL && SLAB
+	depends on DEBUG_KERNEL && SLAB && !KMEMCHECK
 	help
 	  Say Y here to have the kernel do limited verification on memory
 	  allocation as well as poisoning memory on free to catch use of freed
-- 
1.5.4.3



