Return-Path: <linux-kernel-owner+w=401wt.eu-S2992571AbXDDECA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992571AbXDDECA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 00:02:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992569AbXDDEBp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 00:01:45 -0400
Received: from ozlabs.org ([203.10.76.45]:49616 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992557AbXDDEBk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 00:01:40 -0400
To: Andrew Morton <akpm@linux-foundation.org>
CC: <linux-arch@vger.kernel.org>, Linux Memory Management <linux-mm@kvack.org>,
       <linux-kernel@vger.kernel.org>
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Date: Wed, 04 Apr 2007 14:01:28 +1000
Subject: [PATCH 4/14] get_unmapped_area handles MAP_FIXED on frv 
In-Reply-To: <1175659285.929428.835270667964.qpush@grosgo>
Message-Id: <20070404040139.2B61FDDE3F@ozlabs.org>
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
