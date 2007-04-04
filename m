Return-Path: <linux-kernel-owner+w=401wt.eu-S2992644AbXDDELp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992644AbXDDELp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 00:11:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992579AbXDDEKA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 00:10:00 -0400
Received: from ozlabs.org ([203.10.76.45]:49616 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934060AbXDDEBl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 00:01:41 -0400
To: Andrew Morton <akpm@linux-foundation.org>
CC: <linux-arch@vger.kernel.org>, Linux Memory Management <linux-mm@kvack.org>,
       <linux-kernel@vger.kernel.org>
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Date: Wed, 04 Apr 2007 14:01:29 +1000
Subject: [PATCH 7/14] get_unmapped_area handles MAP_FIXED on parisc
In-Reply-To: <1175659285.929428.835270667964.qpush@grosgo>
Message-Id: <20070404040140.BEE42DDE4A@ozlabs.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---

 arch/parisc/kernel/sys_parisc.c |    5 +++++
 1 file changed, 5 insertions(+)

Index: linux-cell/arch/parisc/kernel/sys_parisc.c
===================================================================
--- linux-cell.orig/arch/parisc/kernel/sys_parisc.c	2007-03-22 15:28:05.000000000 +1100
+++ linux-cell/arch/parisc/kernel/sys_parisc.c	2007-03-22 15:29:08.000000000 +1100
@@ -106,6 +106,11 @@ unsigned long arch_get_unmapped_area(str
 {
 	if (len > TASK_SIZE)
 		return -ENOMEM;
+	/* Might want to check for cache aliasing issues for MAP_FIXED case
+	 * like ARM or MIPS ??? --BenH.
+	 */
+	if (flags & MAP_FIXED)
+		return addr;
 	if (!addr)
 		addr = TASK_UNMAPPED_BASE;
 
