Return-Path: <linux-kernel-owner+w=401wt.eu-S1756328AbYDBShW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756328AbYDBShW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 14:37:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757271AbYDBSfj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 14:35:39 -0400
Received: from 21.sub-75-208-3.myvzw.com ([75.208.3.21]:38409 "EHLO
	mail.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756756AbYDBSfg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 14:35:36 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 23 of 24] xen: allow compilation with non-flat memory
X-Mercurial-Node: 6554d3fbcffe7a3529dae53c5915e188de427f73
Message-Id: <6554d3fbcffe7a3529da.1207158852@localhost>
In-Reply-To: <patchbomb.1207158829@localhost>
Date: Wed, 02 Apr 2008 10:54:12 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Isaku Yamahata <yamahata@valinux.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's no real reason we can't support sparsemem/discontigmem, so do so.
This is mostly useful to support hotplug memory.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/xen/Kconfig     |    2 +-
 arch/x86/xen/enlighten.c |    2 ++
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/xen/Kconfig b/arch/x86/xen/Kconfig
--- a/arch/x86/xen/Kconfig
+++ b/arch/x86/xen/Kconfig
@@ -6,7 +6,7 @@
 	bool "Xen guest support"
 	select PARAVIRT
 	depends on X86_32
-	depends on X86_CMPXCHG && X86_TSC && !NEED_MULTIPLE_NODES && !(X86_VISWS || X86_VOYAGER)
+	depends on X86_CMPXCHG && X86_TSC && !(X86_VISWS || X86_VOYAGER)
 	help
 	  This is the Linux Xen port.  Enabling this will allow the
 	  kernel to boot in a paravirtualized environment under the
diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -669,7 +669,9 @@
    everything is pinned. */
 static __init void xen_alloc_pte_init(struct mm_struct *mm, u32 pfn)
 {
+#ifdef CONFIG_FLATMEM
 	BUG_ON(mem_map);	/* should only be used early */
+#endif
 	make_lowmem_page_readonly(__va(PFN_PHYS(pfn)));
 }
 


