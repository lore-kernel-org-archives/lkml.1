Return-Path: <linux-kernel-owner+w=401wt.eu-S965805AbXCVGEG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965805AbXCVGEG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 02:04:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965824AbXCVGEF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 02:04:05 -0400
Received: from ozlabs.org ([203.10.76.45]:57880 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965805AbXCVGD7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 02:03:59 -0400
To: Linux Memory Management <linux-mm@kvack.org>
CC: <linux-kernel@vger.kernel.org>
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Date: Thu, 22 Mar 2007 17:01:24 +1100
Subject: [RFC/PATCH 9/15] get_unmapped_area handles MAP_FIXED on x86_64
In-Reply-To: <1174543217.531981.572863804039.qpush@grosgo>
Message-Id: <20070322060259.DDB25DE3D7@ozlabs.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---

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
