Return-Path: <linux-kernel-owner+w=401wt.eu-S1756185AbYK0Kjv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756185AbYK0Kjv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 05:39:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754397AbYK0Kcy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 05:32:54 -0500
Received: from mtagate7.de.ibm.com ([195.212.29.156]:62877 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752785AbYK0KcX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 05:32:23 -0500
Message-Id: <20081127103134.253514179@de.ibm.com>
References: <20081127103020.528516828@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Thu, 27 Nov 2008 11:30:43 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [patch 23/60] __page_to_pfn warnings
Content-Disposition: inline; filename=122-pfn-warnings.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Martin Schwidefsky <schwidefsky@de.ibm.com>

For CONFIG_SPARSEMEM_VMEMMAP=y on s390 I get warnings like

init/main.c: In function 'start_kernel':
init/main.c:641: warning: format '%08lx' expects type 'long unsigned int', but argument 2 has type 'int'

The warning can be suppressed with a cast to unsigned long in the
CONFIG_SPARSEMEM_VMEMMAP=y version of __page_to_pfn.

Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 include/asm-generic/memory_model.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: quilt-2.6/include/asm-generic/memory_model.h
===================================================================
--- quilt-2.6.orig/include/asm-generic/memory_model.h
+++ quilt-2.6/include/asm-generic/memory_model.h
@@ -49,7 +49,7 @@
 
 /* memmap is virtually contigious.  */
 #define __pfn_to_page(pfn)	(vmemmap + (pfn))
-#define __page_to_pfn(page)	((page) - vmemmap)
+#define __page_to_pfn(page)	(unsigned long)((page) - vmemmap)
 
 #elif defined(CONFIG_SPARSEMEM)
 /*

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

