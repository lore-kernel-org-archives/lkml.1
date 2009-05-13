Return-Path: <linux-kernel-owner+w=401wt.eu-S1756619AbZEMIbI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756619AbZEMIbI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 04:31:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753868AbZEMIaw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 04:30:52 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:34751 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753343AbZEMIav (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 04:30:51 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Minchan Kim <minchan.kim@gmail.com>
Subject: [PATCH] Kconfig: CONFIG_UNEVICTABLE_LRU move into EMBEDDED submenu
Cc: kosaki.motohiro@jp.fujitsu.com
Message-Id: <20090513172904.7234.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Wed, 13 May 2009 17:30:45 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: [PATCH] Kconfig: CONFIG_UNEVICTABLE_LRU move into EMBEDDED submenu

Almost people always turn on CONFIG_UNEVICTABLE_LRU. this configuration is
used only embedded people.
Thus, moving it into embedded submenu is better.


Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
---
 init/Kconfig |   12 ++++++++++++
 mm/Kconfig   |   12 ------------
 2 files changed, 12 insertions(+), 12 deletions(-)

Index: b/mm/Kconfig
===================================================================
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -203,18 +203,6 @@ config VIRT_TO_BUS
 	def_bool y
 	depends on !ARCH_NO_VIRT_TO_BUS
 
-config UNEVICTABLE_LRU
-	bool "Add LRU list to track non-evictable pages"
-	default y
-	help
-	  Keeps unevictable pages off of the active and inactive pageout
-	  lists, so kswapd will not waste CPU time or have its balancing
-	  algorithms thrown off by scanning these pages.  Selecting this
-	  will use one page flag and increase the code size a little,
-	  say Y unless you know what you are doing.
-
-	  See Documentation/vm/unevictable-lru.txt for more information.
-
 config HAVE_MLOCK
 	bool
 	default y if MMU=y
Index: b/init/Kconfig
===================================================================
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -954,6 +954,18 @@ config SLUB_DEBUG
 	  SLUB sysfs support. /sys/slab will not exist and there will be
 	  no support for cache validation etc.
 
+config UNEVICTABLE_LRU
+	bool "Add LRU list to track non-evictable pages" if EMBEDDED
+	default y
+	help
+	  Keeps unevictable pages off of the active and inactive pageout
+	  lists, so kswapd will not waste CPU time or have its balancing
+	  algorithms thrown off by scanning these pages.  Selecting this
+	  will use one page flag and increase the code size a little,
+	  say Y unless you know what you are doing.
+
+	  See Documentation/vm/unevictable-lru.txt for more information.
+
 config STRIP_ASM_SYMS
 	bool "Strip assembler-generated symbols during link"
 	default n


