Return-Path: <linux-kernel-owner+w=401wt.eu-S1758145AbYADFlj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758145AbYADFlj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 00:41:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754068AbYADFjh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 00:39:37 -0500
Received: from gw.goop.org ([64.81.55.164]:48781 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753687AbYADFjf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 00:39:35 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 8 of 8] x86/efi: fix improper use of lvalue
X-Mercurial-Node: 5d35c92fdf0e2c52edbb6fc4ccd06c7f65f25009
Message-Id: <5d35c92fdf0e2c52edbb.1199391065@localhost>
In-Reply-To: <patchbomb.1199391057@localhost>
Date: Thu, 03 Jan 2008 12:11:05 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       Glauber de Oliveira Costa <glommer@gmail.com>,
       Jan Beulich <jbeulich@novell.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

# HG changeset patch
# User Jeremy Fitzhardinge <jeremy@xensource.com>
# Date 1199391030 28800
# Node ID 5d35c92fdf0e2c52edbb6fc4ccd06c7f65f25009
# Parent  22f6a5902285b58bfc1fbbd9e183498c9017bd78
x86/efi: fix improper use of lvalue

pgd_val is no longer valid as an lvalue, so don't try to assign to it.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>

---
 arch/x86/kernel/efi_64.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/efi_64.c b/arch/x86/kernel/efi_64.c
--- a/arch/x86/kernel/efi_64.c
+++ b/arch/x86/kernel/efi_64.c
@@ -84,7 +84,7 @@ void __init efi_call_phys_prelog(void)
 	local_irq_save(efi_flags);
 	early_runtime_code_mapping_set_exec(1);
 	vaddress = (unsigned long)__va(0x0UL);
-	pgd_val(save_pgd) = pgd_val(*pgd_offset_k(0x0UL));
+	save_pgd = *pgd_offset_k(0x0UL);
 	set_pgd(pgd_offset_k(0x0UL), *pgd_offset_k(vaddress));
 	__flush_tlb_all();
 }


