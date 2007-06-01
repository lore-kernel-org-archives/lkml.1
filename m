Return-Path: <linux-kernel-owner+w=401wt.eu-S1761279AbXFALPV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761279AbXFALPV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 07:15:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760929AbXFALO4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 07:14:56 -0400
Received: from rex.snapgear.com ([203.143.235.140]:41542 "EHLO snapgear.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760018AbXFALOz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 07:14:55 -0400
Date: Fri, 1 Jun 2007 21:13:59 +1000
From: Greg Ungerer <gerg@snapgear.com>
Message-Id: <200706011113.l51BDxD6023592@goober>
To: torvalds@linux-foundation.org
Subject: [PATCH] nommu: report correct errno in message
Cc: gerg@uclinux.org, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Report the correct errno for out of memory debug output in binfmt_flat.c

Signed-off-by: Philippe De Muyter <phdm@macqel.be>
Signed-off-by: Greg Ungerer <gerg@uclinux.org>
---


diff -Naur linux-2.6.21/fs/binfmt_flat.c linux-2.6.21-uc0/fs/binfmt_flat.c
--- linux-2.6.21/fs/binfmt_flat.c	2007-05-01 17:13:04.000000000 +1000
+++ linux-2.6.21-uc0/fs/binfmt_flat.c	2007-05-01 17:16:23.000000000 +1000
@@ -558,7 +558,7 @@
 			if (!realdatastart)
 				realdatastart = (unsigned long) -ENOMEM;
 			printk("Unable to allocate RAM for process data, errno %d\n",
-					(int)-datapos);
+					(int)-realdatastart);
 			do_munmap(current->mm, textpos, text_len);
 			ret = realdatastart;
 			goto err;
