Return-Path: <linux-kernel-owner+w=401wt.eu-S1765594AbXGSNwz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765594AbXGSNwz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 09:52:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935645AbXGSNsk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 09:48:40 -0400
Received: from mail.suse.de ([195.135.220.2]:54520 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935021AbXGSNsj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 09:48:39 -0400
From: Andi Kleen <ak@suse.de>
References: <20070719348.540885000@suse.de>
In-Reply-To: <20070719348.540885000@suse.de>
To: apw@shadowen.org, linux-kernel@vger.kernel.org
Subject: [PATCH for review] [9/48] i386: move the kernel to 16MB for NUMA-Q
Message-Id: <20070719134838.29F6314E6E@wotan.suse.de>
Date: Thu, 19 Jul 2007 15:48:38 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Andy Whitcroft <apw@shadowen.org>

We are seeing corruption of the decompressed kernel.  It is suspected that
this is platform specific as it has yet to be seen on any other x86.  Move
the kernel to the 16MB boundary.

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andi Kleen <ak@suse.de>

---

 arch/i386/Kconfig |    1 +
 1 file changed, 1 insertion(+)

Index: linux/arch/i386/Kconfig
===================================================================
--- linux.orig/arch/i386/Kconfig
+++ linux/arch/i386/Kconfig
@@ -823,6 +823,7 @@ config CRASH_DUMP
 
 config PHYSICAL_START
 	hex "Physical address where the kernel is loaded" if (EMBEDDED || CRASH_DUMP)
+	default "0x1000000" if X86_NUMAQ
 	default "0x100000"
 	help
 	  This gives the physical address where the kernel is loaded.
