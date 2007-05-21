Return-Path: <linux-kernel-owner+w=401wt.eu-S1757109AbXEUNJ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757109AbXEUNJ0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 09:09:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755334AbXEUNJS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 09:09:18 -0400
Received: from pollux.ds.pg.gda.pl ([153.19.208.7]:2302 "EHLO
	pollux.ds.pg.gda.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755115AbXEUNJS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 09:09:18 -0400
Date: Mon, 21 May 2007 14:09:13 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Trond Myklebust <trond.myklebust@fys.uio.no>
cc: linux-kernel@vger.kernel.org
Subject: [PATCH] 2.6.21: nfs_readpages: Add missing braces
Message-ID: <Pine.LNX.4.64N.0705211402170.8263@blysk.ds.pg.gda.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 A change a while ago added a call to gather statistics to a conditional 
statement, but braces were missed on that occasion resulting in a change 
of semanticts.  This a change to rectify.

Signed-off-by: Maciej W. Rozycki <macro@linux-mips.org>
---
 It should be obvious -- please apply.

  Maciej

patch-mips-2.6.18-20060920-nfs_readpages-0
diff -up --recursive --new-file linux-mips-2.6.18-20060920.macro/fs/nfs/read.c linux-mips-2.6.18-20060920/fs/nfs/read.c
--- linux-mips-2.6.18-20060920.macro/fs/nfs/read.c	2006-09-20 14:20:24.000000000 +0000
+++ linux-mips-2.6.18-20060920/fs/nfs/read.c	2007-05-20 15:01:31.000000000 +0000
@@ -696,9 +696,10 @@ int nfs_readpages(struct file *filp, str
 	ret = read_cache_pages(mapping, pages, readpage_async_filler, &desc);
 	if (!list_empty(&head)) {
 		int err = nfs_pagein_list(&head, server->rpages);
-		if (!ret)
+		if (!ret) {
 			nfs_add_stats(inode, NFSIOS_READPAGES, err);
 			ret = err;
+		}
 	}
 	put_nfs_open_context(desc.ctx);
 	return ret;
