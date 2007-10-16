Return-Path: <linux-kernel-owner+w=401wt.eu-S935750AbXJPT5i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935750AbXJPT5i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 15:57:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934295AbXJPT52
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 15:57:28 -0400
Received: from ozlabs.org ([203.10.76.45]:53016 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934231AbXJPT51 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 15:57:27 -0400
Date: Tue, 16 Oct 2007 14:57:06 -0500
From: Anton Blanchard <anton@samba.org>
To: torvalds@linux-foundation.org, paulus@samba.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] Update PowerPC vmemmap code for 1TB segments
Message-ID: <20071016195706.GB15297@kryten>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


htab_bolt_mapping takes another argument now the 1TB code has been
merged. Update vmemmap_populate to match.

Signed-off-by: Anton Blanchard <anton@samba.org>
---

diff --git a/arch/powerpc/mm/init_64.c b/arch/powerpc/mm/init_64.c
index 29ed495..702d884 100644
--- a/arch/powerpc/mm/init_64.c
+++ b/arch/powerpc/mm/init_64.c
@@ -243,7 +243,8 @@ int __meminit vmemmap_populate(struct page *start_page,
 					"physical %p.\n", start, p, __pa(p));
 
 		mapped = htab_bolt_mapping(start, start + page_size,
-					__pa(p), mode_rw, mmu_linear_psize);
+					__pa(p), mode_rw, mmu_linear_psize,
+					mmu_kernel_ssize);
 		BUG_ON(mapped < 0);
 	}
 
