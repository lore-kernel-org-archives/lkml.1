Return-Path: <linux-kernel-owner+w=401wt.eu-S2992587AbXDDEIi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992587AbXDDEIi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 00:08:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992579AbXDDEGy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 00:06:54 -0400
Received: from ozlabs.org ([203.10.76.45]:49661 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992584AbXDDEC2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 00:02:28 -0400
To: Andrew Morton <akpm@linux-foundation.org>
CC: <linux-arch@vger.kernel.org>, Linux Memory Management <linux-mm@kvack.org>,
       <linux-kernel@vger.kernel.org>
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Date: Wed, 04 Apr 2007 14:02:16 +1000
Subject: [PATCH 3/14] get_unmapped_area handles MAP_FIXED on arm
In-Reply-To: <1175659331.690672.592289266160.qpush@grosgo>
Message-Id: <20070404040227.48AEDDDE3E@ozlabs.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---

 arch/arm/mm/mmap.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

Index: linux-cell/arch/arm/mm/mmap.c
===================================================================
--- linux-cell.orig/arch/arm/mm/mmap.c	2007-03-22 14:59:51.000000000 +1100
+++ linux-cell/arch/arm/mm/mmap.c	2007-03-22 15:00:01.000000000 +1100
@@ -49,8 +49,7 @@ arch_get_unmapped_area(struct file *filp
 #endif
 
 	/*
-	 * We should enforce the MAP_FIXED case.  However, currently
-	 * the generic kernel code doesn't allow us to handle this.
+	 * We enforce the MAP_FIXED case.
 	 */
 	if (flags & MAP_FIXED) {
 		if (aliasing && flags & MAP_SHARED && addr & (SHMLBA - 1))
