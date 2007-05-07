Return-Path: <linux-kernel-owner+w=401wt.eu-S966949AbXEGWp7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966949AbXEGWp7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 18:45:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754434AbXEGWp6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 18:45:58 -0400
Received: from mga09.intel.com ([134.134.136.24]:1868 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754430AbXEGWp6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 18:45:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.14,502,1170662400"; 
   d="scan'208";a="84734473"
Date: Mon, 7 May 2007 15:43:33 -0700
From: Venki Pallipadi <venkatesh.pallipadi@intel.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       john stultz <johnstul@us.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Chris Wright <chrisw@sous-sol.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>, Andi Kleen <ak@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] x86-64 highres/dyntick support
Message-ID: <20070507224333.GA14623@linux-os.sc.intel.com>
References: <1178485128.31213.98.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1178485128.31213.98.camel@localhost.localdomain>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Needs this minor fix to build on i386.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>

Index: linux-2.6.21-tolkml/include/asm-i386/hpet.h
===================================================================
--- linux-2.6.21-tolkml.orig/include/asm-i386/hpet.h	2007-05-07 14:32:37.000000000 -0700
+++ linux-2.6.21-tolkml/include/asm-i386/hpet.h	2007-05-07 14:43:54.000000000 -0700
@@ -71,17 +71,6 @@
 #ifdef CONFIG_X86_64
 /* hpet_readl/writel defines */
 #include <asm/vsyscall.h>
-
-#else
-static inline unsigned long hpet_readl(unsigned long a)
-{
-	return readl(hpet_virt_address + a);
-}
-
-static inline void hpet_writel(unsigned long d, unsigned long a)
-{
-	writel(d, hpet_virt_address + a);
-}
 #endif
 
 #ifdef CONFIG_HPET_EMULATE_RTC
Index: linux-2.6.21-tolkml/arch/i386/kernel/hpet.c
===================================================================
--- linux-2.6.21-tolkml.orig/arch/i386/kernel/hpet.c	2007-05-07 14:31:34.000000000 -0700
+++ linux-2.6.21-tolkml/arch/i386/kernel/hpet.c	2007-05-07 14:43:36.000000000 -0700
@@ -47,6 +47,16 @@
 
 static void __iomem * hpet_virt_address;
 
+static inline unsigned long hpet_readl(unsigned long a)
+{
+	return readl(hpet_virt_address + a);
+}
+
+static inline void hpet_writel(unsigned long d, unsigned long a)
+{
+	writel(d, hpet_virt_address + a);
+}
+
 static inline void hpet_set_mapping(void)
 {
 	hpet_virt_address = ioremap_nocache(hpet_address, HPET_MMAP_SIZE);
