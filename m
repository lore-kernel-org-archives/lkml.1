Return-Path: <linux-kernel-owner+w=401wt.eu-S1759482AbXJ2Qj2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759482AbXJ2Qj2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 12:39:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756216AbXJ2Qi7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 12:38:59 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:36607 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754505AbXJ2Qi5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 12:38:57 -0400
Date: Mon, 29 Oct 2007 12:38:40 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>,
       WANG Cong <xiyou.wangcong@gmail.com>
Subject: [PATCH] UML - Fix incompatible types warning in previous SG fix
Message-ID: <20071029163840.GA7656@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: WANG Cong <xiyou.wangcong@gmail.com>

Fix an incompatible-pointer warning.

Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>
Signed-off-by: Jeff Dike <jdike@linux.intel.com>
---
 arch/um/drivers/ubd_kern.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/arch/um/drivers/ubd_kern.c
===================================================================
--- linux-2.6.orig/arch/um/drivers/ubd_kern.c	2007-10-29 11:30:02.000000000 -0400
+++ linux-2.6/arch/um/drivers/ubd_kern.c	2007-10-29 12:06:46.000000000 -0400
@@ -705,7 +705,7 @@ static int ubd_add(int n, char **error_o
 	ubd_dev->size = ROUND_BLOCK(ubd_dev->size);
 
 	INIT_LIST_HEAD(&ubd_dev->restart);
-	sg_init_table(&ubd_dev->sg, MAX_SG);
+	sg_init_table(ubd_dev->sg, MAX_SG);
 
 	err = -ENOMEM;
 	ubd_dev->queue = blk_init_queue(do_ubd_request, &ubd_dev->lock);
