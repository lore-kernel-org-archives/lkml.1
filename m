Return-Path: <linux-kernel-owner+w=401wt.eu-S965146AbXBYVl7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965146AbXBYVl7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Feb 2007 16:41:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965153AbXBYVl7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Feb 2007 16:41:59 -0500
Received: from ozlabs.org ([203.10.76.45]:50038 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965146AbXBYVl6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Feb 2007 16:41:58 -0500
Subject: Re: [PATCH] module: use krealloc
From: Rusty Russell <rusty@rustcorp.com.au>
To: Pekka J Enberg <penberg@cs.helsinki.fi>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0702230940220.22414@sbz-30.cs.Helsinki.FI>
References: <Pine.LNX.4.64.0702230940220.22414@sbz-30.cs.Helsinki.FI>
Content-Type: text/plain
Date: Mon, 26 Feb 2007 08:41:02 +1100
Message-Id: <1172439662.13541.2.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-02-23 at 09:41 +0200, Pekka J Enberg wrote:
> From: Pekka Enberg <penberg@cs.helsinki.fi>
> 
> This converts an open-coded krealloc() to use the shiny new API.

OK, why not.

Thanks!
Rusty.

From: Pekka Enberg <penberg@cs.helsinki.fi>

This converts an open-coded krealloc() to use the shiny new API.

Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
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
 


