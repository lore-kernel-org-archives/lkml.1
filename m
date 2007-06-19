Return-Path: <linux-kernel-owner+w=401wt.eu-S1759111AbXFSKHt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759111AbXFSKHt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 06:07:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756113AbXFSKHm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 06:07:42 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:57961 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756067AbXFSKHl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 06:07:41 -0400
Date: Tue, 19 Jun 2007 15:38:10 +0530
From: "S. P. Prasanna" <prasanna@in.ibm.com>
To: Andi Kleen <ak@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Chuck Ebbert <cebbert@redhat.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       linux-kernel@vger.kernel.org, ananth@in.ibm.com,
       mathieu.desnoyers@polymtl.ca
Subject: Re: [patch 2/2] kprobes x86_64 quick fix mark-ro-data
Message-ID: <20070619100810.GA301@in.ibm.com>
Reply-To: prasanna@in.ibm.com
References: <20070615202310.178466032@polymtl.ca> <4676D2A9.6090403@redhat.com> <20070618115632.7aca8c0f.akpm@linux-foundation.org> <200706182132.56559.ak@suse.de> <20070619100644.GA5478@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070619100644.GA5478@in.ibm.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is a quick fix for x86_64 to enable kprobes only if DEBUG_RODATA is
not configured. Since DEBUG_RODATA markes the kernel text pages as read-only.

Signed-off-by: Prasanna S P. <prasanna@in.ibm.com>


 arch/x86_64/Kconfig |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff -puN arch/x86_64/Kconfig~kprobes-quick-fix-mark-ro-data-x86_64 arch/x86_64/Kconfig
--- linux-2.6.22-rc5/arch/x86_64/Kconfig~kprobes-quick-fix-mark-ro-data-x86_64	2007-06-19 14:55:56.000000000 +0530
+++ linux-2.6.22-rc5-prasanna/arch/x86_64/Kconfig	2007-06-19 14:55:56.000000000 +0530
@@ -764,6 +764,8 @@ source "drivers/firmware/Kconfig"
 
 source fs/Kconfig
 
+source "arch/x86_64/Kconfig.debug"
+
 menu "Instrumentation Support"
         depends on EXPERIMENTAL
 
@@ -771,7 +773,7 @@ source "arch/x86_64/oprofile/Kconfig"
 
 config KPROBES
 	bool "Kprobes (EXPERIMENTAL)"
-	depends on KALLSYMS && EXPERIMENTAL && MODULES
+	depends on KALLSYMS && EXPERIMENTAL && MODULES && !DEBUG_RODATA
 	help
 	  Kprobes allows you to trap at almost any kernel address and
 	  execute a callback function.  register_kprobe() establishes
@@ -780,8 +782,6 @@ config KPROBES
 	  If in doubt, say "N".
 endmenu
 
-source "arch/x86_64/Kconfig.debug"
-
 source "security/Kconfig"
 
 source "crypto/Kconfig"

_
-- 
Prasanna S.P.
Linux Technology Center
India Software Labs, IBM Bangalore
Email: prasanna@in.ibm.com
Ph: 91-80-41776329
