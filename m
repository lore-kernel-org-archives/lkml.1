Return-Path: <linux-kernel-owner+w=401wt.eu-S1161649AbXDXFhA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161649AbXDXFhA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 01:37:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161629AbXDXFed
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 01:34:33 -0400
Received: from ozlabs.org ([203.10.76.45]:35021 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161632AbXDXFdk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 01:33:40 -0400
To: Andrew Morton <akpm@linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>,
       Linux Memory Management <linux-mm@kvack.org>
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Date: Tue, 24 Apr 2007 15:33:37 +1000
Subject: [PATCH 7/12] get_unmapped_area handles MAP_FIXED on parisc
In-Reply-To: <1177392813.924664.32930750763.qpush@grosgo>
Message-Id: <20070424053339.D189DDDF0D@ozlabs.org>
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
 
