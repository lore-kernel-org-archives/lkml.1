Return-Path: <linux-kernel-owner+w=401wt.eu-S965550AbXD3Kav@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965550AbXD3Kav (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 06:30:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965554AbXD3K3A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 06:29:00 -0400
Received: from ns2.suse.de ([195.135.220.15]:42934 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753191AbXD3K1n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 06:27:43 -0400
From: Andi Kleen <ak@suse.de>
References: <200704301227.598020000@suse.de>
In-Reply-To: <200704301227.598020000@suse.de>
To: jeremy@goop.org, patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [6/40] i386: Allocate a fixmap slot
Message-Id: <20070430102739.18739151D2@wotan.suse.de>
Date: Mon, 30 Apr 2007 12:27:39 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Jeremy Fitzhardinge <jeremy@goop.org>
Allocate a fixmap slot for use by a paravirt_ops implementation.  This
is intended for early-boot bootstrap mappings.  Once the zones and
allocator have been set up, it would be better to use get_vm_area() to
allocate some virtual space.

Xen uses this to map the hypervisor's shared info page, which doesn't
have a pseudo-physical page number, and therefore can't be mapped
ordinarily.  It is needed early because it contains the vcpu state,
including the interrupt mask.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Signed-off-by: Andi Kleen <ak@suse.de>
Acked-by: Ingo Molnar <mingo@elte.hu>

---
 include/asm-i386/fixmap.h |    3 +++
 1 file changed, 3 insertions(+)

===================================================================
Index: linux/include/asm-i386/fixmap.h
===================================================================
--- linux.orig/include/asm-i386/fixmap.h
+++ linux/include/asm-i386/fixmap.h
@@ -84,6 +84,9 @@ enum fixed_addresses {
 #ifdef CONFIG_PCI_MMCONFIG
 	FIX_PCIE_MCFG,
 #endif
+#ifdef CONFIG_PARAVIRT
+	FIX_PARAVIRT_BOOTMAP,
+#endif
 	__end_of_permanent_fixed_addresses,
 	/* temporary boot-time mappings, used before ioremap() is functional */
 #define NR_FIX_BTMAPS	16
