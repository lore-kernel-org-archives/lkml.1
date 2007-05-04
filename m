Return-Path: <linux-kernel-owner+w=401wt.eu-S1767813AbXEDKkG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767813AbXEDKkG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 06:40:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423699AbXEDKkB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 06:40:01 -0400
Received: from amsfep17-int.chello.nl ([213.46.243.15]:3563 "EHLO
	amsfep14-int.chello.nl" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1767837AbXEDKjG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 06:39:06 -0400
Message-Id: <20070504103200.331926063@chello.nl>
References: <20070504102651.923946304@chello.nl>
User-Agent: quilt/0.45-1
Date: Fri, 04 May 2007 12:27:12 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org, netdev@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       Thomas Graf <tgraf@suug.ch>, David Miller <davem@davemloft.net>,
       James Bottomley <James.Bottomley@SteelEye.com>,
       Mike Christie <michaelc@cs.wisc.edu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Daniel Phillips <phillips@google.com>, Jeff Dike <jdike@addtoit.com>
Subject: [PATCH 21/40] uml: rename arch/um remove_mapping()
Content-Disposition: inline; filename=uml_remove_mapping.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

When 'include/linux/mm.h' includes 'include/linux/swap.h', the global
remove_mapping() definition clashes with the arch/um one.

Rename the arch/um one.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Acked-by: Jeff Dike <jdike@addtoit.com>
---
 arch/um/kernel/physmem.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

Index: linux-2.6-git/arch/um/kernel/physmem.c
===================================================================
--- linux-2.6-git.orig/arch/um/kernel/physmem.c	2007-02-12 09:40:47.000000000 +0100
+++ linux-2.6-git/arch/um/kernel/physmem.c	2007-02-12 11:17:47.000000000 +0100
@@ -160,7 +160,7 @@ int physmem_subst_mapping(void *virt, in
 
 static int physmem_fd = -1;
 
-static void remove_mapping(struct phys_desc *desc)
+static void um_remove_mapping(struct phys_desc *desc)
 {
 	void *virt = desc->virt;
 	int err;
@@ -184,7 +184,7 @@ int physmem_remove_mapping(void *virt)
 	if(desc == NULL)
 		return 0;
 
-	remove_mapping(desc);
+	um_remove_mapping(desc);
 	return 1;
 }
 
@@ -205,7 +205,7 @@ void physmem_forget_descriptor(int fd)
 		page = list_entry(ele, struct phys_desc, list);
 		offset = page->offset;
 		addr = page->virt;
-		remove_mapping(page);
+		um_remove_mapping(page);
 		err = os_seek_file(fd, offset);
 		if(err)
 			panic("physmem_forget_descriptor - failed to seek "

--

