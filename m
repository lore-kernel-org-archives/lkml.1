Return-Path: <linux-kernel-owner+w=401wt.eu-S1755314AbYCUGU2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755314AbYCUGU2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 02:20:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753560AbYCUGS4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 02:18:56 -0400
Received: from relay2.sgi.com ([192.48.171.30]:53278 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753405AbYCUGSx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 02:18:53 -0400
Message-Id: <20080321061724.795229401@sgi.com>
References: <20080321061703.921169367@sgi.com>
User-Agent: quilt/0.46-1
Date: Thu, 20 Mar 2008 23:17:06 -0700
From: Christoph Lameter <clameter@sgi.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
Subject: [03/14] vmallocinfo: Support display of vcompound for a virtual compound page
Content-Disposition: inline; filename=vcompound_vmalloc_type
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add another flag to the vmalloc subsystem to mark virtual compound pages.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 include/linux/vmalloc.h |    1 +
 mm/vmalloc.c            |    3 +++
 2 files changed, 4 insertions(+)

Index: linux-2.6.25-rc5-mm1/include/linux/vmalloc.h
===================================================================
--- linux-2.6.25-rc5-mm1.orig/include/linux/vmalloc.h	2008-03-19 18:17:42.093443900 -0700
+++ linux-2.6.25-rc5-mm1/include/linux/vmalloc.h	2008-03-19 18:27:20.150422445 -0700
@@ -12,6 +12,7 @@ struct vm_area_struct;
 #define VM_MAP		0x00000004	/* vmap()ed pages */
 #define VM_USERMAP	0x00000008	/* suitable for remap_vmalloc_range */
 #define VM_VPAGES	0x00000010	/* buffer for pages was vmalloc'ed */
+#define VM_VCOMPOUND	0x00000020	/* Page allocator fallback */
 /* bits [20..32] reserved for arch specific ioremap internals */
 
 /*
Index: linux-2.6.25-rc5-mm1/mm/vmalloc.c
===================================================================
--- linux-2.6.25-rc5-mm1.orig/mm/vmalloc.c	2008-03-19 18:18:02.689633934 -0700
+++ linux-2.6.25-rc5-mm1/mm/vmalloc.c	2008-03-19 18:27:20.150422445 -0700
@@ -974,6 +974,9 @@ static int s_show(struct seq_file *m, vo
 	if (v->flags & VM_VPAGES)
 		seq_printf(m, " vpages");
 
+	if (v->flags & VM_VCOMPOUND)
+		seq_printf(m, " vcompound");
+
 	seq_putc(m, '\n');
 	return 0;
 }

-- 
