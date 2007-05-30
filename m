Return-Path: <linux-kernel-owner+w=401wt.eu-S1759498AbXE3Vgq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759498AbXE3Vgq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 17:36:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756986AbXE3Vg0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 17:36:26 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:28183 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756694AbXE3VgZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 17:36:25 -0400
Date: Wed, 30 May 2007 14:35:15 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Hugh Dickins <hugh@veritas.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Jayson Santos <jaysonsantos2003@yahoo.com.br>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 3/3 -mm] prio_tree: use lib/hexdump
Message-Id: <20070530143515.9642b45c.randy.dunlap@oracle.com>
In-Reply-To: <Pine.LNX.4.64.0705151953050.30826@blonde.wat.veritas.com>
References: <Pine.LNX.4.64.0705151953050.30826@blonde.wat.veritas.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 May 2007 19:56:31 +0100 (BST) Hugh Dickins wrote:

> So dump vma and the one it's supposed to resemble: I had expected to use
> print_hex_dump(), but that's designed for u8 dumps, whereas almost every
> field of vm_area_struct is either a pointer or an unsigned long - which
> look nonsense dumped as u8s.

From: Randy Dunlap <randy.dunlap@oracle.com>

Use modified lib/hexdump in mm/prio_tree dump_vma().

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 mm/prio_tree.c |   13 +++----------
 1 file changed, 3 insertions(+), 10 deletions(-)

--- linux-2622-rc2mm1-slub.orig/mm/prio_tree.c
+++ linux-2622-rc2mm1-slub/mm/prio_tree.c
@@ -69,16 +69,9 @@
 
 static void dump_vma(struct vm_area_struct *vma)
 {
-	void **ptr = (void **) vma;
-	int i;
-
-	printk("vm_area_struct at %p:", ptr);
-	for (i = 0; i < sizeof(*vma)/sizeof(*ptr); i++, ptr++) {
-		if (!(i & 3))
-			printk("\n");
-		printk(" %p", *ptr);
-	}
-	printk("\n");
+	printk("vm_area_struct at %p:\n", vma);
+	print_hex_dump("", " ", DUMP_PREFIX_NONE, 32, sizeof(void *),
+		vma, sizeof(*vma), 0);
 }
 
 /*
