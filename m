Return-Path: <linux-kernel-owner+w=401wt.eu-S965582AbXBTACe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965582AbXBTACe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 19:02:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965578AbXBTACP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 19:02:15 -0500
Received: from mailout.stusta.mhn.de ([141.84.69.5]:35988 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965574AbXBTACK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 19:02:10 -0500
Date: Tue, 20 Feb 2007 01:02:09 +0100
From: Adrian Bunk <bunk@stusta.de>
To: Andrew Morton <akpm@linux-foundation.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: linux-kernel@vger.kernel.org
Subject: [-mm patch] marker exports must be EXPORT_SYMBOL_GPL
Message-ID: <20070220000209.GY13958@stusta.de>
References: <20070215051408.a7fb7d81.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070215051408.a7fb7d81.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 15, 2007 at 05:14:08AM -0800, Andrew Morton wrote:
>...
> - Added the Linux Kernel Markers code.  No idea how to use it and it
>   seems we're not to be told.
>...
> Changes since 2.6.20-rc6-mm3:
>...
> +linux-kernel-markers-kconfig-menus.patch
> +linux-kernel-markers-architecture-independant-code.patch
> +linux-kernel-markers-powerpc-optimization.patch
> +linux-kernel-markers-i386-optimization.patch
> +linux-kernel-markers-non-optimized-architectures.patch
> 
>  Linux Kenrel Markers
>...


This is definitely functionality illegal modules have no business to 
use.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---

 arch/i386/kernel/marker.c |    2 +-
 kernel/module.c           |   10 +++++-----
 2 files changed, 6 insertions(+), 6 deletions(-)

--- linux-2.6.20-mm1/kernel/module.c.old	2007-02-15 16:02:09.000000000 +0100
+++ linux-2.6.20-mm1/kernel/module.c	2007-02-15 16:03:08.000000000 +0100
@@ -304,7 +304,7 @@
 void __mark_empty_function(const char *fmt, ...)
 {
 }
-EXPORT_SYMBOL(__mark_empty_function);
+EXPORT_SYMBOL_GPL(__mark_empty_function);
 
 #ifdef MARK_POLYMORPHIC
 static int marker_set_ins_enable(void *address, char enable)
@@ -461,7 +461,7 @@
 	mutex_unlock(&module_mutex);
 	return found;
 }
-EXPORT_SYMBOL(marker_set_probe);
+EXPORT_SYMBOL_GPL(marker_set_probe);
 
 int marker_remove_probe(marker_probe_func *probe)
 {
@@ -481,7 +481,7 @@
 	mutex_unlock(&module_mutex);
 	return found;
 }
-EXPORT_SYMBOL(marker_remove_probe);
+EXPORT_SYMBOL_GPL(marker_remove_probe);
 
 int marker_list_probe(marker_probe_func *probe)
 {
@@ -505,7 +505,7 @@
 	mutex_unlock(&module_mutex);
 	return found;
 }
-EXPORT_SYMBOL(marker_list_probe);
+EXPORT_SYMBOL_GPL(marker_list_probe);
 #endif
 
 #ifdef CONFIG_SMP
@@ -2510,7 +2510,7 @@
 	}
 	mutex_unlock(&module_mutex);
 }
-EXPORT_SYMBOL(list_modules);
+EXPORT_SYMBOL_GPL(list_modules);
 
 /* Given an address, look for it in the module exception tables. */
 const struct exception_table_entry *search_module_extables(unsigned long addr)
--- linux-2.6.20-mm1/arch/i386/kernel/marker.c.old	2007-02-15 16:03:22.000000000 +0100
+++ linux-2.6.20-mm1/arch/i386/kernel/marker.c	2007-02-15 16:03:34.000000000 +0100
@@ -90,4 +90,4 @@
 	flush_icache_range(address, size);
 	return 0;
 }
-EXPORT_SYMBOL(arch_marker_set_ins_enable);
+EXPORT_SYMBOL_GPL(arch_marker_set_ins_enable);





