Return-Path: <linux-kernel-owner+w=401wt.eu-S932114AbXDEAQn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932114AbXDEAQn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 20:16:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932140AbXDEAQn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 20:16:43 -0400
Received: from 230.sub-75-208-113.myvzw.com ([75.208.113.230]:36875 "EHLO
	mail.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932114AbXDEAQm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 20:16:42 -0400
Message-Id: <20070404191205.293858634@goop.org>
References: <20070404191151.009821039@goop.org>
User-Agent: quilt/0.46-1
Date: Wed, 04 Apr 2007 12:11:57 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Andi Kleen <ak@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, virtualization@lists.osdl.org,
       lkml <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: [patch 06/20] Allocate a fixmap slot
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

