Return-Path: <linux-kernel-owner+w=401wt.eu-S1161630AbXDXFe1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161630AbXDXFe1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 01:34:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161633AbXDXFdl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 01:33:41 -0400
Received: from ozlabs.org ([203.10.76.45]:35018 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161580AbXDXFdi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 01:33:38 -0400
To: Andrew Morton <akpm@linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>,
       Linux Memory Management <linux-mm@kvack.org>
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Date: Tue, 24 Apr 2007 15:33:35 +1000
Subject: [PATCH 3/12] get_unmapped_area handles MAP_FIXED on arm
In-Reply-To: <1177392813.924664.32930750763.qpush@grosgo>
Message-Id: <20070424053337.C5FEBDDF09@ozlabs.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

ARM already had a case for MAP_FIXED in arch_get_unmapped_area() though
it was not called before. Fix the comment to reflect that it will now
be called.

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>

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
