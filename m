Return-Path: <linux-kernel-owner+w=401wt.eu-S1753856AbXDNVWY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753856AbXDNVWY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2007 17:22:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753862AbXDNVWB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Apr 2007 17:22:01 -0400
Received: from gw.goop.org ([64.81.55.164]:59540 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753830AbXDNVUR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2007 17:20:17 -0400
Message-Id: <20070414204924.349072869@goop.org>
References: <20070414204154.871250608@goop.org>
User-Agent: quilt/0.46-1
Date: Sat, 14 Apr 2007 13:42:07 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Andi Kleen <ak@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, virtualization@lists.osdl.org,
       lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH 13/28] paravirt: flush lazy mmu updates on kunmap_atomic
Content-Disposition: inline; filename=paravirt-flush-on-kunmap_atomic.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

kunmap_atomic should flush any pending lazy mmu updates, mainly to be
consistent with kmap_atomic, and to preserve its normal behaviour.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>

---
 arch/i386/mm/highmem.c |    1 +
 1 file changed, 1 insertion(+)

===================================================================
--- a/arch/i386/mm/highmem.c
+++ b/arch/i386/mm/highmem.c
@@ -72,6 +72,7 @@ void kunmap_atomic(void *kvaddr, enum km
 #endif
 	}
 
+	arch_flush_lazy_mmu_mode();
 	pagefault_enable();
 }
 

-- 

