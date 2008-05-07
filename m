Return-Path: <linux-kernel-owner+w=401wt.eu-S1756604AbYEGAxX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756604AbYEGAxX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 20:53:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753509AbYEGAxO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 20:53:14 -0400
Received: from rex.securecomputing.com ([203.24.151.4]:51813 "EHLO
	snapgear.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751656AbYEGAxO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 20:53:14 -0400
Date: Wed, 7 May 2008 10:52:39 +1000
From: Greg Ungerer <gerg@snapgear.com>
Message-Id: <200805070052.m470qdod017612@goober>
To: torvalds@linux-foundation.org
Subject: [PATCH] m68knommu: missing sections for linker script
Cc: akpm@linux-foundation.org, gerg@uclinux.org, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Inlucde the missing kcrctab and kcrctab_unused sections into the
m68knommu linker script.

Signed-off-by: Greg Ungerer <gerg@uclinux.org>
---

diff -Naurp linux-2.6.25-rc1/arch/m68knommu/kernel/vmlinux.lds.S linux-2.6.25-rc1-uc0/arch/m68knommu/kernel/vmlinux.lds.S
--- linux-2.6.25-rc1/arch/m68knommu/kernel/vmlinux.lds.S	2008-05-06 14:52:00.000000000 +1000
+++ linux-2.6.25-rc1-uc0/arch/m68knommu/kernel/vmlinux.lds.S	2008-05-06 16:56:47.000000000 +1000
@@ -114,6 +114,16 @@ SECTIONS {
 		*(__kcrctab_gpl)
 		__stop___kcrctab_gpl = .;
 
+		/* Kernel symbol table: Normal unused symbols */
+		__start___kcrctab_unused = .;
+		*(__kcrctab_unused)
+		__stop___kcrctab_unused = .;
+
+		/* Kernel symbol table: GPL-only unused symbols */
+		__start___kcrctab_unused_gpl = .;
+		*(__kcrctab_unused_gpl)
+		__stop___kcrctab_unused_gpl = .;
+
 		/* Kernel symbol table: GPL-future symbols */
 		__start___kcrctab_gpl_future = .;
 		*(__kcrctab_gpl_future)
