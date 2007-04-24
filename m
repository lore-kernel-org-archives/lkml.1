Return-Path: <linux-kernel-owner+w=401wt.eu-S1161640AbXDXFh4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161640AbXDXFh4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 01:37:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161641AbXDXFea
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 01:34:30 -0400
Received: from ozlabs.org ([203.10.76.45]:35021 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161612AbXDXFdj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 01:33:39 -0400
To: Andrew Morton <akpm@linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>,
       Linux Memory Management <linux-mm@kvack.org>
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Date: Tue, 24 Apr 2007 15:33:35 +1000
Subject: [PATCH 4/12] get_unmapped_area handles MAP_FIXED on frv 
In-Reply-To: <1177392813.924664.32930750763.qpush@grosgo>
Message-Id: <20070424053338.4FCC5DDF0A@ozlabs.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Handle MAP_FIXED in arch_get_unmapped_area on frv. Trivial case, just
return the address.

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>

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
