Return-Path: <linux-kernel-owner+w=401wt.eu-S1753103AbXEAT4B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753103AbXEAT4B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 15:56:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752999AbXEAT4B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 15:56:01 -0400
Received: from mx1.redhat.com ([66.187.233.31]:39710 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752834AbXEAT4A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 15:56:00 -0400
Subject: [PATCH] uml: fixup allocation in the ubd driver
From: Peter Zijlstra <pzijlstr@redhat.com>
To: akpm <akpm@linux-foundation.org>, Jeff Dike <jdike@addtoit.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=utf-8
Date: Tue, 01 May 2007 21:56:07 +0200
Message-Id: <1178049367.5182.4.camel@taijtu>
Mime-Version: 1.0
X-Mailer: Evolution 2.9.4 (2.9.4-1.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I needed this for 2.6.21-rc7-mm2, ubd was complaining about sleeping in
an atomic context.
---

Sanitise gfp flags; it actually is an atomic context, so drop the
GFP_KERNEL part.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Acked-by: Jeff Dike <jdike@addtoit.com>
---
 arch/um/drivers/ubd_kern.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/arch/um/drivers/ubd_kern.c
===================================================================
--- linux-2.6.orig/arch/um/drivers/ubd_kern.c	2007-05-01 21:41:13.000000000 +0200
+++ linux-2.6/arch/um/drivers/ubd_kern.c	2007-05-01 21:49:23.000000000 +0200
@@ -1102,7 +1102,7 @@ static void do_ubd_request(request_queue
 			struct scatterlist *sg = &dev->sg[dev->start_sg];
 
 			io_req = kmalloc(sizeof(struct io_thread_req),
-					 GFP_KERNEL | GFP_ATOMIC);
+					 GFP_ATOMIC);
 			if(io_req == NULL){
 				if(list_empty(&dev->restart))
 					list_add(&dev->restart, &restart);


