Return-Path: <linux-kernel-owner+w=401wt.eu-S2992624AbXDDEJ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992624AbXDDEJ4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 00:09:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992564AbXDDEBn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 00:01:43 -0400
Received: from ozlabs.org ([203.10.76.45]:49613 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934059AbXDDEBj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 00:01:39 -0400
To: Andrew Morton <akpm@linux-foundation.org>
CC: <linux-arch@vger.kernel.org>, Linux Memory Management <linux-mm@kvack.org>,
       <linux-kernel@vger.kernel.org>
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Date: Wed, 04 Apr 2007 14:01:27 +1000
Subject: [PATCH 3/14] get_unmapped_area handles MAP_FIXED on arm
In-Reply-To: <1175659285.929428.835270667964.qpush@grosgo>
Message-Id: <20070404040138.9C870DDE3E@ozlabs.org>
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
