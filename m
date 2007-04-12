Return-Path: <linux-kernel-owner+w=401wt.eu-S1161490AbXDLCXA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161490AbXDLCXA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 22:23:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161479AbXDLCVK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 22:21:10 -0400
Received: from ozlabs.org ([203.10.76.45]:55497 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161486AbXDLCUe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 22:20:34 -0400
To: Andrew Morton <akpm@linux-foundation.org>
CC: Linux Memory Management <linux-mm@kvack.org>,
       <linux-kernel@vger.kernel.org>
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Date: Thu, 12 Apr 2007 12:20:31 +1000
Subject: [PATCH 9/12] get_unmapped_area handles MAP_FIXED on x86_64
In-Reply-To: <1176344427.242579.337989891532.qpush@grosgo>
Message-Id: <20070412022033.B9584DDF24@ozlabs.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Handle MAP_FIXED in x86_64 arch_get_unmapped_area(), simple case, just
return the address as passed in

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>

 arch/x86_64/kernel/sys_x86_64.c |    3 +++
 1 file changed, 3 insertions(+)

Index: linux-cell/arch/x86_64/kernel/sys_x86_64.c
===================================================================
--- linux-cell.orig/arch/x86_64/kernel/sys_x86_64.c	2007-03-22 16:10:10.000000000 +1100
+++ linux-cell/arch/x86_64/kernel/sys_x86_64.c	2007-03-22 16:11:06.000000000 +1100
@@ -93,6 +93,9 @@ arch_get_unmapped_area(struct file *filp
 	unsigned long start_addr;
 	unsigned long begin, end;
 	
+	if (flags & MAP_FIXED)
+		return addr;
+
 	find_start_end(flags, &begin, &end); 
 
 	if (len > end)
