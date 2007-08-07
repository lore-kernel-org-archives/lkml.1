Return-Path: <linux-kernel-owner+w=401wt.eu-S935381AbXHGWdw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935381AbXHGWdw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 18:33:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758287AbXHGWdH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 18:33:07 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:59078 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753878AbXHGWdE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 18:33:04 -0400
Subject: [RFC][PATCH 2/5] pagemap: use PAGE_MASK/PAGE_ALIGN()
To: mpm@selenic.com
Cc: linux-kernel@vger.kernel.org, serue@us.ibm.com,
       Dave Hansen <haveblue@us.ibm.com>
From: Dave Hansen <haveblue@us.ibm.com>
Date: Tue, 07 Aug 2007 15:33:01 -0700
References: <20070807223300.9228E0E0@kernel>
In-Reply-To: <20070807223300.9228E0E0@kernel>
Message-Id: <20070807223301.17F179D5@kernel>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Use existing macros (PAGE_MASK/PAGE_ALIGN()) instead of
open-coding them.

Signed-off-by: Dave Hansen <haveblue@us.ibm.com>
---

 lxc-dave/fs/proc/task_mmu.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/proc/task_mmu.c~pagemap-use-PAGE_MASK fs/proc/task_mmu.c
--- lxc/fs/proc/task_mmu.c~pagemap-use-PAGE_MASK	2007-08-07 15:30:52.000000000 -0700
+++ lxc-dave/fs/proc/task_mmu.c	2007-08-07 15:30:52.000000000 -0700
@@ -669,9 +669,9 @@ static ssize_t pagemap_read(struct file 
 		goto out;
 
 	ret = -ENOMEM;
-	uaddr = (unsigned long)buf & ~(PAGE_SIZE-1);
+	uaddr = (unsigned long)buf & PAGE_MASK;
 	uend = (unsigned long)(buf + count);
-	pagecount = (uend - uaddr + PAGE_SIZE-1) / PAGE_SIZE;
+	pagecount = (uend - PAGE_ALIGN(uaddr)) / PAGE_SIZE;
 	pages = kmalloc(pagecount * sizeof(struct page *), GFP_KERNEL);
 	if (!pages)
 		goto out_task;
_
