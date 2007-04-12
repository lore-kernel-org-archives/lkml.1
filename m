Return-Path: <linux-kernel-owner+w=401wt.eu-S1161495AbXDLCXC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161495AbXDLCXC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 22:23:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161485AbXDLCVH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 22:21:07 -0400
Received: from ozlabs.org ([203.10.76.45]:55493 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161484AbXDLCUd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 22:20:33 -0400
To: Andrew Morton <akpm@linux-foundation.org>
CC: Linux Memory Management <linux-mm@kvack.org>,
       <linux-kernel@vger.kernel.org>
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Date: Thu, 12 Apr 2007 12:20:30 +1000
Subject: [PATCH 7/12] get_unmapped_area handles MAP_FIXED on parisc
In-Reply-To: <1176344427.242579.337989891532.qpush@grosgo>
Message-Id: <20070412022032.A3F3BDDF2E@ozlabs.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Handle MAP_FIXED in parisc arch_get_unmapped_area(), just return the
address. We might want to also check for possible cache aliasing
issues now that we get called in that case (like ARM or MIPS),
leave a comment for the maintainers to pick up.

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>

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
 
