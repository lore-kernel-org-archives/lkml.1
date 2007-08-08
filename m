Return-Path: <linux-kernel-owner+w=401wt.eu-S1758456AbXHHHJZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758456AbXHHHJZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 03:09:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757404AbXHHHHm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 03:07:42 -0400
Received: from mx1.redhat.com ([66.187.233.31]:43545 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755435AbXHHHHf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 03:07:35 -0400
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, rusty@rustcorp.com.au, ak@suse.de,
       mingo@elte.hu, chrisw@sous-sol.org, jeremy@goop.org, avi@qumranet.com,
       anthony@codemonkey.ws, virtualization@lists.linux-foundation.org,
       lguest@ozlabs.org, Glauber de Oliveira Costa <gcosta@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 1/25] [PATCH] header file move
Date: Wed,  8 Aug 2007 01:18:48 -0300
Message-Id: <11865467592921-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <11865467522495-git-send-email-gcosta@redhat.com>
References: <11865467522495-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Later on, the paravirt_ops patch will deference the vm_area_struct
in asm/pgtable.h. It means this define must be after the struct
definition

Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/mm.h |   14 +++++++++-----
 1 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 655094d..c3f8561 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -35,11 +35,6 @@ extern int sysctl_legacy_va_layout;
 #define sysctl_legacy_va_layout 0
 #endif
 
-#include <asm/page.h>
-#include <asm/pgtable.h>
-#include <asm/processor.h>
-
-#define nth_page(page,n) pfn_to_page(page_to_pfn((page)) + (n))
 
 /*
  * Linux kernel virtual memory manager primitives.
@@ -113,6 +108,15 @@ struct vm_area_struct {
 #endif
 };
 
+#include <asm/page.h>
+/*
+ * pgtable.h must be included after the definition of vm_area_struct.
+ * x86_64 pgtable.h is one of the dereferencers of this struct
+ */
+#include <asm/pgtable.h>
+#include <asm/processor.h>
+
+#define nth_page(page,n) pfn_to_page(page_to_pfn((page)) + (n))
 extern struct kmem_cache *vm_area_cachep;
 
 /*
-- 
1.4.4.2

