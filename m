Return-Path: <linux-kernel-owner+w=401wt.eu-S1757106AbZEDOh5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757106AbZEDOh5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 10:37:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756170AbZEDOhg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 10:37:36 -0400
Received: from mtagate4.de.ibm.com ([195.212.29.153]:64793 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756088AbZEDOhf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 10:37:35 -0400
Date: Mon, 4 May 2009 16:37:31 +0200
From: Ralph Wuerthner <ralphw@linux.vnet.ibm.com>
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [PATCH] alloc_vmap_area: fix memory leak
Message-ID: <20090504163731.3675ea87@rwuerthntp>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH] alloc_vmap_area: fix memory leak

From: Ralph Wuerthner <ralphw@linux.vnet.ibm.com>

If alloc_vmap_area() fails the allocated struct vmap_area has to be
freed.

Signed-off-by: Ralph Wuerthner <ralphw@linux.vnet.ibm.com>

---
 mm/vmalloc.c |    1 +
 1 file changed, 1 insertion(+)

Index: linux-2.6/mm/vmalloc.c
===================================================================
--- linux-2.6.orig/mm/vmalloc.c
+++ linux-2.6/mm/vmalloc.c
@@ -402,6 +402,7 @@ overflow:
 			printk(KERN_WARNING
 				"vmap allocation for size %lu failed: "
 				"use vmalloc=<size> to increase size.\n", size);
+		kfree(va);
 		return ERR_PTR(-EBUSY);
 	}
 


-- 
Ralph Wuerthner
