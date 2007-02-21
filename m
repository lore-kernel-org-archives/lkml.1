Return-Path: <linux-kernel-owner+w=401wt.eu-S1161114AbXBUIGx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161114AbXBUIGx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 03:06:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161122AbXBUIGx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 03:06:53 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:33849 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161114AbXBUIGx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 03:06:53 -0500
Date: Wed, 21 Feb 2007 10:06:52 +0200 (EET)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: akpm@linux-foundation.org
cc: clameter@sgi.com, linux-kernel@vger.kernel.org, jsipek@fsl.cs.sunysb.edu,
       unionfs@filesystems.org, bunk@stusta.de, hooanon05@yahoo.co.jp
Subject: [PATCH 2/3] slab: export ksize to modules
Message-ID: <Pine.LNX.4.64.0702211006210.8172@sbz-30.cs.Helsinki.FI>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pekka Enberg <penberg@cs.helsinki.fi>

This exports ksize in slab and slob allocators to modules.

Cc: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 mm/slab.c |    1 +
 mm/slob.c |    2 ++
 2 files changed, 3 insertions(+)

Index: 2.6/mm/slab.c
===================================================================
--- 2.6.orig/mm/slab.c	2007-02-21 09:46:16.000000000 +0200
+++ 2.6/mm/slab.c	2007-02-21 09:46:25.000000000 +0200
@@ -4485,3 +4485,4 @@
 
 	return obj_size(virt_to_cache(objp));
 }
+EXPORT_SYMBOL(ksize);
Index: 2.6/mm/slob.c
===================================================================
--- 2.6.orig/mm/slob.c	2007-02-21 09:46:28.000000000 +0200
+++ 2.6/mm/slob.c	2007-02-21 09:46:42.000000000 +0200
@@ -240,6 +240,8 @@
 	return ((slob_t *)block - 1)->units * SLOB_UNIT;
 }
 
+EXPORT_SYMBOL(ksize);
+
 struct kmem_cache {
 	unsigned int size, align;
 	const char *name;
