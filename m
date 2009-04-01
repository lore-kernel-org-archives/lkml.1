Return-Path: <linux-kernel-owner+w=401wt.eu-S932994AbZDATCH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932994AbZDATCH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 15:02:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933830AbZDATBG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 15:01:06 -0400
Received: from relay3.sgi.com ([192.48.156.57]:48118 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933837AbZDATBE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 15:01:04 -0400
X-Greylist: delayed 474 seconds by postgrey-1.27 at vger.kernel.org; Wed, 01 Apr 2009 15:01:04 EDT
Date: Wed, 1 Apr 2009 13:53:03 -0500
From: Robin Holt <holt@sgi.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [Patch 1/1] Remove SGI_GRU as a valid config option for ia64
	configs with SGI_UV.
Message-ID: <20090401185303.GG8925@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some current configs turn on GRU for ia64.  The GRU code does not
correctly load on boot on ia64 (GRU does continue to work for
x86-64), so changing the IA64 Kconfig to not select GRU on ia64
configs for now until we have time to fix.

Signed-off-by: Robin Holt <holt@sgi.com>
Acked-by: Jack Steiner <steiner@sgi.com>

---

 arch/ia64/configs/generic_defconfig |    3 ---
 drivers/misc/Kconfig                |    4 ++--
 2 files changed, 2 insertions(+), 5 deletions(-)
Index: 20090401-ia64-xpc-no-gru/arch/ia64/configs/generic_defconfig
===================================================================
--- 20090401-ia64-xpc-no-gru.orig/arch/ia64/configs/generic_defconfig	2009-04-01 11:09:18.000000000 -0500
+++ 20090401-ia64-xpc-no-gru/arch/ia64/configs/generic_defconfig	2009-04-01 11:16:42.121430058 -0500
@@ -193,7 +193,6 @@ CONFIG_BOUNCE=y
 CONFIG_NR_QUICK=1
 CONFIG_VIRT_TO_BUS=y
 CONFIG_UNEVICTABLE_LRU=y
-CONFIG_MMU_NOTIFIER=y
 CONFIG_ARCH_SELECT_MEMORY_MODEL=y
 CONFIG_ARCH_DISCONTIGMEM_ENABLE=y
 CONFIG_ARCH_FLATMEM_ENABLE=y
@@ -416,8 +415,6 @@ CONFIG_SGI_IOC4=y
 # CONFIG_ENCLOSURE_SERVICES is not set
 CONFIG_SGI_XP=m
 # CONFIG_HP_ILO is not set
-CONFIG_SGI_GRU=m
-# CONFIG_SGI_GRU_DEBUG is not set
 # CONFIG_C2PORT is not set
 CONFIG_HAVE_IDE=y
 CONFIG_IDE=y
Index: 20090401-ia64-xpc-no-gru/drivers/misc/Kconfig
===================================================================
--- 20090401-ia64-xpc-no-gru.orig/drivers/misc/Kconfig	2009-04-01 11:09:18.000000000 -0500
+++ 20090401-ia64-xpc-no-gru/drivers/misc/Kconfig	2009-04-01 11:09:22.145583991 -0500
@@ -165,7 +165,7 @@ config SGI_XP
 	depends on (IA64_GENERIC || IA64_SGI_SN2 || IA64_SGI_UV || X86_UV) && SMP
 	select IA64_UNCACHED_ALLOCATOR if IA64_GENERIC || IA64_SGI_SN2
 	select GENERIC_ALLOCATOR if IA64_GENERIC || IA64_SGI_SN2
-	select SGI_GRU if (IA64_GENERIC || IA64_SGI_UV || X86_64) && SMP
+	select SGI_GRU if X86_64 && SMP
 	---help---
 	  An SGI machine can be divided into multiple Single System
 	  Images which act independently of each other and have
@@ -189,7 +189,7 @@ config HP_ILO
 
 config SGI_GRU
 	tristate "SGI GRU driver"
-	depends on (X86_UV || IA64_SGI_UV || IA64_GENERIC) && SMP
+	depends on X86_UV && SMP
 	default n
 	select MMU_NOTIFIER
 	---help---
