Return-Path: <linux-kernel-owner+w=401wt.eu-S1758177AbZCCLP6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758177AbZCCLP6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 06:15:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754242AbZCCLPO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 06:15:14 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:56906 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753297AbZCCLPI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 06:15:08 -0500
Subject: [PATCH 2/3] x86: make sure initmem is writable on 64-bit
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: mingo@elte.hu
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, arjan@linux.intel.com
Date: Tue, 03 Mar 2009 13:15:04 +0200
Message-Id: <1236078904.2675.17.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pekka Enberg <penberg@cs.helsinki.fi>

Impact: unification

This patch ports commit 3c1df68b848b39270752ff8d4b956cc4a4dce0f6 ("x86: make
sure initmem is writable") to the 64-bit version to unify implementations of
free_init_pages().

Cc: Arjan van de Ven <arjan@linux.intel.com>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 arch/x86/mm/init_64.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index e6d36b4..03da903 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -962,6 +962,13 @@ void free_init_pages(char *what, unsigned long begin, unsigned long end)
 		begin, PAGE_ALIGN(end));
 	set_memory_np(begin, (end - begin) >> PAGE_SHIFT);
 #else
+	/*
+	 * We just marked the kernel text read only above, now that
+	 * we are going to free part of that, we need to make that
+	 * writeable first.
+	 */
+	set_memory_rw(begin, (end - begin) >> PAGE_SHIFT);
+
 	printk(KERN_INFO "Freeing %s: %luk freed\n", what, (end - begin) >> 10);
 
 	for (; addr < end; addr += PAGE_SIZE) {
-- 
1.5.4.3



