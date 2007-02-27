Return-Path: <linux-kernel-owner+w=401wt.eu-S933010AbXB0InL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933010AbXB0InL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 03:43:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932799AbXB0IiY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 03:38:24 -0500
Received: from gw.goop.org ([64.81.55.164]:46812 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932807AbXB0IiU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 03:38:20 -0500
Message-Id: <20070227081631.122933982@goop.org>
References: <20070227081337.434798469@goop.org>
User-Agent: quilt/0.46-1
Date: Tue, 27 Feb 2007 00:13:43 -0800
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

Allocate a fixmap slot for use by a paravirt_ops implementation.  Xen
uses this to map the hypervisor's shared info page, which doesn't have
a pseudo-physical page number, and therefore can't be mapped
ordinarily.

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
+	FIX_PARAVIRT,
+#endif
 	__end_of_permanent_fixed_addresses,
 	/* temporary boot-time mappings, used before ioremap() is functional */
 #define NR_FIX_BTMAPS	16

-- 

