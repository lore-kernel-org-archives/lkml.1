Return-Path: <linux-kernel-owner+w=401wt.eu-S1752142AbXBWHlP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752142AbXBWHlP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 02:41:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752143AbXBWHlP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 02:41:15 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:53290 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752142AbXBWHlO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 02:41:14 -0500
Date: Fri, 23 Feb 2007 09:41:12 +0200 (EET)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: akpm@linux-foundation.org
cc: rusty@rustcorp.com.au, linux-kernel@vger.kernel.org
Subject: [PATCH] module: use krealloc
Message-ID: <Pine.LNX.4.64.0702230940220.22414@sbz-30.cs.Helsinki.FI>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pekka Enberg <penberg@cs.helsinki.fi>

This converts an open-coded krealloc() to use the shiny new API.

Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 kernel/module.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

Index: uml-2.6/kernel/module.c
===================================================================
--- uml-2.6.orig/kernel/module.c	2007-02-23 09:24:14.000000000 +0200
+++ uml-2.6/kernel/module.c	2007-02-23 09:34:43.000000000 +0200
@@ -308,14 +308,14 @@
 {
 	/* Reallocation required? */
 	if (pcpu_num_used + 1 > pcpu_num_allocated) {
-		int *new = kmalloc(sizeof(new[0]) * pcpu_num_allocated*2,
-				   GFP_KERNEL);
+		int *new;
+
+		new = krealloc(pcpu_size, sizeof(new[0])*pcpu_num_allocated*2,
+			       GFP_KERNEL);
 		if (!new)
 			return 0;
 
-		memcpy(new, pcpu_size, sizeof(new[0])*pcpu_num_allocated);
 		pcpu_num_allocated *= 2;
-		kfree(pcpu_size);
 		pcpu_size = new;
 	}
 
