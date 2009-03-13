Return-Path: <linux-kernel-owner+w=401wt.eu-S1757724AbZCMIPh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757724AbZCMIPh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 04:15:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754103AbZCMIMS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 04:12:18 -0400
Received: from gw.goop.org ([64.81.55.164]:34814 "EHLO abulafia.goop.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751502AbZCMIMP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 04:12:15 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 08/24] xen: reserve i386 Xen pagetables
Date: Fri, 13 Mar 2009 01:11:44 -0700
Message-Id: <1236931920-6861-9-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1236931920-6861-1-git-send-email-jeremy@goop.org>
References: <1236931920-6861-1-git-send-email-jeremy@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

Make sure the Xen-provided pagetables are reserved on x86-32.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/xen/mmu.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index 2d30b74..065fe8d 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -1789,6 +1789,11 @@ __init pgd_t *xen_setup_kernel_pagetable(pgd_t *pgd,
 
 	pin_pagetable_pfn(MMUEXT_PIN_L3_TABLE, PFN_DOWN(__pa(swapper_pg_dir)));
 
+	reserve_early(__pa(xen_start_info->pt_base),
+		      __pa(xen_start_info->pt_base +
+			   xen_start_info->nr_pt_frames * PAGE_SIZE),
+		      "XEN PAGETABLES");
+
 	return swapper_pg_dir;
 }
 #endif	/* CONFIG_X86_64 */
-- 
1.6.0.6

