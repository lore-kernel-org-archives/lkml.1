Return-Path: <linux-kernel-owner+w=401wt.eu-S965811AbXCVGCy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965811AbXCVGCy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 02:02:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965780AbXCVGCa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 02:02:30 -0400
Received: from ozlabs.org ([203.10.76.45]:41771 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965786AbXCVGCU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 02:02:20 -0400
To: Linux Memory Management <linux-mm@kvack.org>
CC: <linux-kernel@vger.kernel.org>
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Date: Thu, 22 Mar 2007 17:00:37 +1100
Subject: [RFC/PATCH 4/15] get_unmapped_area handles MAP_FIXED on frv 
In-Reply-To: <1174543217.531981.572863804039.qpush@grosgo>
Message-Id: <20070322060219.2907DDDF2F@ozlabs.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---

 arch/frv/mm/elf-fdpic.c |    4 ++++
 1 file changed, 4 insertions(+)

Index: linux-cell/arch/frv/mm/elf-fdpic.c
===================================================================
--- linux-cell.orig/arch/frv/mm/elf-fdpic.c	2007-03-22 15:00:50.000000000 +1100
+++ linux-cell/arch/frv/mm/elf-fdpic.c	2007-03-22 15:01:06.000000000 +1100
@@ -64,6 +64,10 @@ unsigned long arch_get_unmapped_area(str
 	if (len > TASK_SIZE)
 		return -ENOMEM;
 
+	/* handle MAP_FIXED */
+	if (flags & MAP_FIXED)
+		return addr;
+
 	/* only honour a hint if we're not going to clobber something doing so */
 	if (addr) {
 		addr = PAGE_ALIGN(addr);
