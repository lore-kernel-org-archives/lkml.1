Return-Path: <linux-kernel-owner+w=401wt.eu-S1755940AbXIKOw6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755940AbXIKOw6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 10:52:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751962AbXIKOwi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 10:52:38 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:49164 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751398AbXIKOwg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 10:52:36 -0400
Date: Tue, 11 Sep 2007 10:52:20 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>,
       Jesper Juhl <jesper.juhl@gmail.com>
Subject: [ PATCH 1/3 ] UML - Remove unneeded void * cast
Message-ID: <20070911145220.GA6313@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

vmalloc() returns a void pointer, so casting to (void *) is pretty pointless.   

Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
Signed-off-by: Jeff Dike <jdike@linux.intel.com>
--
 arch/um/drivers/ubd_kern.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.22/arch/um/drivers/ubd_kern.c
===================================================================
--- linux-2.6.22.orig/arch/um/drivers/ubd_kern.c	2007-08-23 20:22:40.000000000 -0400
+++ linux-2.6.22/arch/um/drivers/ubd_kern.c	2007-08-30 16:27:33.000000000 -0400
@@ -615,7 +615,7 @@ static int ubd_open_dev(struct ubd *ubd_
 		blk_queue_max_sectors(ubd_dev->queue, 8 * sizeof(long));
 
 		err = -ENOMEM;
-		ubd_dev->cow.bitmap = (void *) vmalloc(ubd_dev->cow.bitmap_len);
+		ubd_dev->cow.bitmap = vmalloc(ubd_dev->cow.bitmap_len);
 		if(ubd_dev->cow.bitmap == NULL){
 			printk(KERN_ERR "Failed to vmalloc COW bitmap\n");
 			goto error;
