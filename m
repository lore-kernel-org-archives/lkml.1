Return-Path: <linux-kernel-owner+w=401wt.eu-S1754111AbYDPRpS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754111AbYDPRpS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 13:45:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751843AbYDPRpF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 13:45:05 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:28370 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751807AbYDPRpE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 13:45:04 -0400
Date: Wed, 16 Apr 2008 10:44:18 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: linux-next@vger.kernel.org, mingo <mingo@redhat.com>,
       tglx <tglx@linutronix.de>
Subject: [PATCH -next] x86/trace: uses/depends on PCI
Message-Id: <20080416104418.4fb7f1de.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Don't try to build mmiotrace when CONFIG_PCI=n.

next-20080416/kernel/trace/trace_mmiotrace.c: In function 'mmio_print_pcidev':
next-20080416/kernel/trace/trace_mmiotrace.c:62: error: implicit declaration of function 'pci_dev_driver'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 arch/x86/Kconfig.debug |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- next-20080416.orig/arch/x86/Kconfig.debug
+++ next-20080416/arch/x86/Kconfig.debug
@@ -186,7 +186,7 @@ config MMIOTRACE_HOOKS
 
 config MMIOTRACE
 	bool "Memory mapped IO tracing"
-	depends on DEBUG_KERNEL
+	depends on DEBUG_KERNEL && PCI
 	select TRACING
 	select MMIOTRACE_HOOKS
 	default y
@@ -194,7 +194,7 @@ config MMIOTRACE
 	  Mmiotrace traces Memory Mapped I/O access and is meant for
 	  debugging and reverse engineering. It is called from the ioremap
 	  implementation and works via page faults. Tracing is disabled by
-	  default and can be enabled run-time.
+	  default and can be enabled at run-time.
 
 	  See Documentation/tracers/mmiotrace.txt.
 	  If you are not helping to develop drivers, say N.
