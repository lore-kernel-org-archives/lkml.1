Return-Path: <linux-kernel-owner+w=401wt.eu-S1161482AbXDLCVB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161482AbXDLCVB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 22:21:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161485AbXDLCUd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 22:20:33 -0400
Received: from ozlabs.org ([203.10.76.45]:55490 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161481AbXDLCUb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 22:20:31 -0400
To: Andrew Morton <akpm@linux-foundation.org>
CC: Linux Memory Management <linux-mm@kvack.org>,
       <linux-kernel@vger.kernel.org>
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Date: Thu, 12 Apr 2007 12:20:28 +1000
Subject: [PATCH 3/12] get_unmapped_area handles MAP_FIXED on arm
In-Reply-To: <1176344427.242579.337989891532.qpush@grosgo>
Message-Id: <20070412022030.976C9DDF27@ozlabs.org>
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
