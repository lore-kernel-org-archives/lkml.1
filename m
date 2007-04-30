Return-Path: <linux-kernel-owner+w=401wt.eu-S1754640AbXD3Kat@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754640AbXD3Kat (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 06:30:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965158AbXD3K2v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 06:28:51 -0400
Received: from ns.suse.de ([195.135.220.2]:51196 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754643AbXD3K1w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 06:27:52 -0400
From: Andi Kleen <ak@suse.de>
References: <200704301227.598020000@suse.de>
In-Reply-To: <200704301227.598020000@suse.de>
To: jeremy@goop.org, patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [18/40] i386: flush lazy mmu updates on kunmap_atomic
Message-Id: <20070430102751.E388C151CA@wotan.suse.de>
Date: Mon, 30 Apr 2007 12:27:51 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Jeremy Fitzhardinge <jeremy@goop.org>
kunmap_atomic should flush any pending lazy mmu updates, mainly to be
consistent with kmap_atomic, and to preserve its normal behaviour.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/i386/mm/highmem.c |    1 +
 1 file changed, 1 insertion(+)

===================================================================
Index: linux/arch/i386/mm/highmem.c
===================================================================
--- linux.orig/arch/i386/mm/highmem.c
+++ linux/arch/i386/mm/highmem.c
@@ -72,6 +72,7 @@ void kunmap_atomic(void *kvaddr, enum km
 #endif
 	}
 
+	arch_flush_lazy_mmu_mode();
 	pagefault_enable();
 }
 
