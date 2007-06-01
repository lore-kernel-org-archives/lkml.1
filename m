Return-Path: <linux-kernel-owner+w=401wt.eu-S1759973AbXFAXOs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759973AbXFAXOs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 19:14:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753428AbXFAXOm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 19:14:42 -0400
Received: from sccrmhc14.comcast.net ([204.127.200.84]:44157 "EHLO
	sccrmhc14.comcast.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753423AbXFAXOm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 19:14:42 -0400
Date: Fri, 1 Jun 2007 16:10:53 -0700
From: Deepak Saxena <dsaxena@plexity.net>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       rmk@arm.linux.org.uk
Subject: [PATCH RT] Fix NR_syscalls in ARM
Message-ID: <20070601231053.GA26602@plexity.net>
Reply-To: dsaxena@plexity.net
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: Plexity Networks
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


The -rt patch adds a NR_syscalls symbol to the arm/unistd.h but
it is not the correct value as there are 348 syscalls on ARM
and the existing change sets the symbol to 322.

Signed-off-by: Deepak Saxena <dsaxena@mvista.com>

---

Russell: Why isn't this in mainline? Other arches all seem to have 
this symbol already defined.

Index: linux-2.6.21/include/asm-arm/unistd.h
===================================================================
--- linux-2.6.21.orig/include/asm-arm/unistd.h
+++ linux-2.6.21/include/asm-arm/unistd.h
@@ -375,7 +375,7 @@
 #define __NR_kexec_load			(__NR_SYSCALL_BASE+347)
 
 #ifndef __ASSEMBLY__
-#define NR_syscalls			(__NR_set_mempolicy + 1 - __NR_SYSCALL_BASE)
+#define NR_syscalls			(__NR_kexec_load + 1 - __NR_SYSCALL_BASE)
 #endif
 
 /*

-- 
Deepak Saxena - dsaxena@plexity.net - http://www.plexity.net 
