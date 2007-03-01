Return-Path: <linux-kernel-owner+w=401wt.eu-S1161272AbXCAX7F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161272AbXCAX7F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 18:59:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161263AbXCAX4z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 18:56:55 -0500
Received: from 207.47.60.4.static.nextweb.net ([207.47.60.4]:47895 "EHLO
	mail.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1161272AbXCAX4t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 18:56:49 -0500
Message-Id: <20070301232526.730138638@goop.org>
References: <20070301232443.195603797@goop.org>
User-Agent: quilt/0.46-1
Date: Thu, 01 Mar 2007 15:24:49 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Andi Kleen <ak@muc.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       virtualization@lists.osdl.org, xen-devel@lists.xensource.com,
       Chris Wright <chrisw@sous-sol.org>, Zachary Amsden <zach@vmware.com>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: [patch 06/26] Xen-paravirt_ops: paravirt_ops: allocate a fixmap slot
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

