Return-Path: <linux-kernel-owner+w=401wt.eu-S1757503AbYGHQ5u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757503AbYGHQ5u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 12:57:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756936AbYGHQ5T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 12:57:19 -0400
Received: from casper.infradead.org ([85.118.1.10]:55097 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756933AbYGHQ5S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 12:57:18 -0400
Date: Tue, 8 Jul 2008 09:46:35 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, mingo@elte.hu
Subject: [patch 6/17] Use WARN() in mm/vmalloc.c
Message-ID: <20080708094635.2b257e6e@infradead.org>
In-Reply-To: <20080708093800.274504ba@infradead.org>
References: <20080708093800.274504ba@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.10; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arjan van de Ven <arjan@linux.intel.com>
Subject: Use WARN instead of printk+WARN_ON in mm/vmalloc.c

Use WARN() instead of a printk+WARN_ON() pair; this way the message
becomes part of the warning section for better reporting/collection.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
---
 mm/vmalloc.c            |    6 
 2 files changed, 2 insertions(+), 309 deletions(-)

Index: linux.trees.git/mm/vmalloc.c
===================================================================
--- linux.trees.git.orig/mm/vmalloc.c
+++ linux.trees.git/mm/vmalloc.c
@@ -381,16 +381,14 @@ static void __vunmap(const void *addr, i
 		return;
 
 	if ((PAGE_SIZE-1) & (unsigned long)addr) {
-		printk(KERN_ERR "Trying to vfree() bad address (%p)\n", addr);
-		WARN_ON(1);
+		WARN(1, KERN_ERR "Trying to vfree() bad address (%p)\n", addr);
 		return;
 	}
 
 	area = remove_vm_area(addr);
 	if (unlikely(!area)) {
-		printk(KERN_ERR "Trying to vfree() nonexistent vm area (%p)\n",
+		WARN(1, KERN_ERR "Trying to vfree() nonexistent vm area (%p)\n",
 				addr);
-		WARN_ON(1);
 		return;
 	}
 

