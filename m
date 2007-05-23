Return-Path: <linux-kernel-owner+w=401wt.eu-S935761AbXEWQkk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935761AbXEWQkk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 12:40:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935354AbXEWQj7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 12:39:59 -0400
Received: from [198.99.130.12] ([198.99.130.12]:34973 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S935100AbXEWQj6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 12:39:58 -0400
Date: Wed, 23 May 2007 12:33:01 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: [PATCH 2/2] UML - Fix ubd_add error reporting
Message-ID: <20070523163301.GA5563@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

ubd_add returns 0 when there could actually be an error to report.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
--
 arch/um/drivers/ubd_kern.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.21-mm/arch/um/drivers/ubd_kern.c
===================================================================
--- linux-2.6.21-mm.orig/arch/um/drivers/ubd_kern.c	2007-05-22 11:55:48.000000000 -0400
+++ linux-2.6.21-mm/arch/um/drivers/ubd_kern.c	2007-05-22 12:03:48.000000000 -0400
@@ -766,7 +766,7 @@ static int ubd_add(int n, char **error_o
 		make_ide_entries(ubd_gendisk[n]->disk_name);
 
 out:
-	return 0;
+	return err;
 
 out_cleanup:
 	blk_cleanup_queue(ubd_dev->queue);
