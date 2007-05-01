Return-Path: <linux-kernel-owner+w=401wt.eu-S1423792AbXEAEKk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423792AbXEAEKk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 00:10:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946596AbXEAEAj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 00:00:39 -0400
Received: from ns2.suse.de ([195.135.220.15]:48987 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933482AbXEAD6Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 23:58:24 -0400
From: Andi Kleen <ak@suse.de>
References: <20070501557.815359000@suse.de>
In-Reply-To: <20070501557.815359000@suse.de>
To: patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [25/30] x86_64: Fix allnoconfig error in genapic_flat.c
Message-Id: <20070501035823.C0C9E13CAF@wotan.suse.de>
Date: Tue,  1 May 2007 05:58:23 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Fix:

In file included from include2/asm/apic.h:5,
                 from include2/asm/smp.h:15,
                 from linux/arch/x86_64/kernel/genapic_flat.c:18:
linux/include/linux/pm.h: In function ‘call_platform_enable_wakeup’:
linux/include/linux/pm.h:331: error: ‘EIO’ undeclared (first use in this function)
linux/include/linux/pm.h:331: error: (Each undeclared identifier is reported only once
linux/include/linux/pm.h:331: error: for each function it appears in.)

Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/x86_64/kernel/genapic_flat.c |    1 +
 1 file changed, 1 insertion(+)

Index: linux/arch/x86_64/kernel/genapic_flat.c
===================================================================
--- linux.orig/arch/x86_64/kernel/genapic_flat.c
+++ linux/arch/x86_64/kernel/genapic_flat.c
@@ -8,6 +8,7 @@
  * Martin Bligh, Andi Kleen, James Bottomley, John Stultz, and
  * James Cleverdon.
  */
+#include <linux/errno.h>
 #include <linux/threads.h>
 #include <linux/cpumask.h>
 #include <linux/string.h>
