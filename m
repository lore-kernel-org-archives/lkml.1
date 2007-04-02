Return-Path: <linux-kernel-owner+w=401wt.eu-S932659AbXDBGD3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932659AbXDBGD3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 02:03:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932500AbXDBGCW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 02:02:22 -0400
Received: from gw.goop.org ([64.81.55.164]:38279 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933673AbXDBF7M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 01:59:12 -0400
Message-Id: <20070402055704.449460943@goop.org>
References: <20070402055652.610711908@goop.org>
User-Agent: quilt/0.46-1
Date: Sun, 01 Apr 2007 22:56:58 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Andi Kleen <ak@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, virtualization@lists.osdl.org,
       lkml <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: [patch 06/17] Allocate a fixmap slot
Content-Disposition: inline; filename=paravirt-fixmap.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Allocate a fixmap slot for use by a paravirt_ops implementation.  This
is intended for early-boot bootstrap mappings.  Once the zones and
allocator have been set up, it would be better to use get_vm_area() to
allocate some virtual space.

Xen uses this to map the hypervisor's shared info page, which doesn't
have a pseudo-physical page number, and therefore can't be mapped
ordinarily.  It is needed early because it contains the vcpu state,
including the interrupt mask.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Acked-by: Ingo Molnar <mingo@elte.hu>

---
 include/asm-i386/fixmap.h |    3 +++
 1 file changed, 3 insertions(+)

===================================================================
--- a/include/asm-i386/fixmap.h
+++ b/include/asm-i386/fixmap.h
@@ -86,6 +86,9 @@ enum fixed_addresses {
 #ifdef CONFIG_PCI_MMCONFIG
 	FIX_PCIE_MCFG,
 #endif
+#ifdef CONFIG_PARAVIRT
+	FIX_PARAVIRT_BOOTMAP,
+#endif
 	__end_of_permanent_fixed_addresses,
 	/* temporary boot-time mappings, used before ioremap() is functional */
 #define NR_FIX_BTMAPS	16

-- 

