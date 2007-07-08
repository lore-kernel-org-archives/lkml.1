Return-Path: <linux-kernel-owner+w=401wt.eu-S1755965AbXGHGUA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755965AbXGHGUA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2007 02:20:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752404AbXGHGTv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jul 2007 02:19:51 -0400
Received: from ozlabs.org ([203.10.76.45]:47407 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751988AbXGHGTu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2007 02:19:50 -0400
Subject: maps2-make-proc-pid-smaps-optional-under-config_embedded.patch
From: Rusty Russell <rusty@rustcorp.com.au>
To: Matt Mackall <mpm@selenic.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       David Rientjes <rientjes@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sun, 08 Jul 2007 16:19:34 +1000
Message-Id: <1183875574.6005.275.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Matt wrote:
> This interface is primarily useful for doing memory profiling and not much use
> on deployed embedded boxes.  Make it optional.  Together with
> /proc/pid/clear_refs, this save a few K.

How about a single config option for all these?

===
maps2-CONFIG_PROC_PAGE_MONITOR.patch

Merge the three config options PROC_SMAPS/PROC_CLEAR_REFS/PROC_PAGEMAP
and report the approximate memory usage (i386 SMP).

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff -r 5a7ada4f5442 init/Kconfig
--- a/init/Kconfig	Sun Jul 08 15:29:26 2007 +1000
+++ b/init/Kconfig	Sun Jul 08 16:01:35 2007 +1000
@@ -636,32 +636,14 @@ config SLOB
 
 endchoice
 
-config PROC_SMAPS
-	default y
-	bool "Enable /proc/pid/smaps support" if EMBEDDED && PROC_FS && MMU
-	help
-	  The /proc/pid/smaps interface reports a process's private and
-          shared memory per mapping. Disabling this interface will reduce
-          the size of the kernel for small machines.
-
-config PROC_CLEAR_REFS
-	default y
-	bool "Enable /proc/pid/clear_refs support" if EMBEDDED && PROC_FS && MMU
-	help
-	  The /proc/pid/clear_refs interface allows clearing the
-          referenced bits on a process's memory maps to allow monitoring
-          working set size. Disabling this interface will reduce
-          the size of the kernel for small machines.
-
-config PROC_PAGEMAP
-	default y
-	bool "Enable /proc/pid/pagemap support" if EMBEDDED && PROC_FS && MMU
-	help
-	  The /proc/pid/pagemap interface allows reading the
-          kernel's virtual memory to page frame mapping to determine which
-          individual pages a process has mapped and which pages it shares
-          with other processes. Disabling this interface will reduce the
-          size of the kernel for small machines.
+config PROC_PAGE_MONITOR
+	default y
+	bool "Enable /proc page monitoring" if EMBEDDED && PROC_FS && MMU
+	help
+	  Various /proc files exist to monitor process memory utilization:
+	  /proc/pid/smaps, /proc/pid/clear_refs and /proc/pid/pagemap.
+	  Disabling these interfaces will reduce the size of the kernel by
+	  approximately 4kb.
 
 config PROC_KPAGEMAP
 	default y
@@ -670,7 +652,7 @@ config PROC_KPAGEMAP
 	  The /proc/pid/kpagemap interface allows reading the
           kernel's per-page flag and usage counts to gather precise
           information on page-level memory usage. Disabling this interface
-          will reduce the size of the kernel for small machines.
+          will reduce the size of the kernel by around 600 bytes.
 
 endmenu		# General setup
 


