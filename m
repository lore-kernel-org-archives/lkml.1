Return-Path: <linux-kernel-owner+w=401wt.eu-S966386AbZLHVSw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966386AbZLHVSw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 16:18:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966331AbZLHVSr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 16:18:47 -0500
Received: from one.firstfloor.org ([213.235.205.2]:49562 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966293AbZLHVQf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 16:16:35 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <200912081016.198135742@firstfloor.org>
In-Reply-To: <200912081016.198135742@firstfloor.org>
To: fengguang.wu@intel.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH] [25/31] HWPOISON: Don't do early filtering if filter is disabled
Message-Id: <20091208211641.8A2FBB151F@basil.firstfloor.org>
Date: Tue,  8 Dec 2009 22:16:41 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 mm/hwpoison-inject.c |    3 +++
 1 file changed, 3 insertions(+)

Index: linux/mm/hwpoison-inject.c
===================================================================
--- linux.orig/mm/hwpoison-inject.c
+++ linux/mm/hwpoison-inject.c
@@ -18,6 +18,8 @@ static int hwpoison_inject(void *data, u
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
+	if (!hwpoison_filter_enable)
+		goto inject;
 	if (!pfn_valid(pfn))
 		return -ENXIO;
 
@@ -48,6 +50,7 @@ static int hwpoison_inject(void *data, u
 	if (err)
 		return 0;
 
+inject:
 	printk(KERN_INFO "Injecting memory failure at pfn %lx\n", pfn);
 	return __memory_failure(pfn, 18, MF_COUNT_INCREASED);
 }
