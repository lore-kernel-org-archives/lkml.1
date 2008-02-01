Return-Path: <linux-kernel-owner+w=401wt.eu-S1763542AbYBANGt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763542AbYBANGt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 08:06:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758931AbYBANGl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 08:06:41 -0500
Received: from mtagate6.de.ibm.com ([195.212.29.155]:54060 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758666AbYBANGk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 08:06:40 -0500
Date: Fri, 1 Feb 2008 14:06:36 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Ingo Molnar <mingo@elte.hu>, Arjan van de Ven <arjan@linux.intel.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Holger Wolf <wolf@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] latencytop: Change Kconfig dependency.
Message-ID: <20080201130636.GA29660@osiris.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heiko Carstens <heiko.carstens@de.ibm.com>

Change latencytop Kconfig entry so it doesn't list the archictectures
that support it. Instead introduce HAVE_LATENCY_SUPPORT which any
architecture can set. Should reduce patch conflicts.

Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Holger Wolf <wolf@linux.vnet.ibm.com>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---

If ok, should this go in via the x86 tree?

 arch/x86/Kconfig  |    3 +++
 lib/Kconfig.debug |    2 +-
 2 files changed, 4 insertions(+), 1 deletion(-)

Index: linux-2.6/arch/x86/Kconfig
===================================================================
--- linux-2.6.orig/arch/x86/Kconfig
+++ linux-2.6/arch/x86/Kconfig
@@ -44,6 +44,9 @@ config LOCKDEP_SUPPORT
 config STACKTRACE_SUPPORT
 	def_bool y
 
+config HAVE_LATENCYTOP_SUPPORT
+	def_bool y
+
 config SEMAPHORE_SLEEPERS
 	def_bool y
 
Index: linux-2.6/lib/Kconfig.debug
===================================================================
--- linux-2.6.orig/lib/Kconfig.debug
+++ linux-2.6/lib/Kconfig.debug
@@ -581,7 +581,7 @@ config LATENCYTOP
 	select STACKTRACE
 	select SCHEDSTATS
 	select SCHED_DEBUG
-	depends on X86 || X86_64
+	depends on HAVE_LATENCYTOP_SUPPORT
 	help
 	  Enable this option if you want to use the LatencyTOP tool
 	  to find out which userspace is blocking on what kernel operations.
