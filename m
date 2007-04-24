Return-Path: <linux-kernel-owner+w=401wt.eu-S1161647AbXDXFgM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161647AbXDXFgM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 01:36:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161626AbXDXFeg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 01:34:36 -0400
Received: from ozlabs.org ([203.10.76.45]:35025 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161634AbXDXFdl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 01:33:41 -0400
To: Andrew Morton <akpm@linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>,
       Linux Memory Management <linux-mm@kvack.org>
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Date: Tue, 24 Apr 2007 15:33:38 +1000
Subject: [PATCH 9/12] get_unmapped_area handles MAP_FIXED on x86_64
In-Reply-To: <1177392813.924664.32930750763.qpush@grosgo>
Message-Id: <20070424053340.DE26BDDF0F@ozlabs.org>
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
