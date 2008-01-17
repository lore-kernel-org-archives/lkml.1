Return-Path: <linux-kernel-owner+w=401wt.eu-S1759160AbYAQVpf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759160AbYAQVpf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 16:45:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756512AbYAQVll
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 16:41:41 -0500
Received: from saraswathi.solana.com ([198.99.130.12]:44786 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758160AbYAQVlh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 16:41:37 -0500
Date: Thu, 17 Jan 2008 16:40:40 -0500
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>
Cc: uml-devel <user-mode-linux-devel@lists.sourceforge.net>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 5/20] UML - Remove fakehd
Message-ID: <20080117214040.GA6707@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The fakehd switch lost its implementation at some point.  Since no one is
screaming for it, we might as well remove it.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
---
 arch/um/drivers/ubd_kern.c |   20 ++++----------------
 1 file changed, 4 insertions(+), 16 deletions(-)

Index: linux-2.6.22/arch/um/drivers/ubd_kern.c
===================================================================
--- linux-2.6.22.orig/arch/um/drivers/ubd_kern.c	2007-12-14 11:28:06.000000000 -0500
+++ linux-2.6.22/arch/um/drivers/ubd_kern.c	2007-12-14 12:33:26.000000000 -0500
@@ -460,20 +460,6 @@ __uml_help(udb_setup,
 "    in the boot output.\n\n"
 );
 
-static int fakehd_set = 0;
-static int fakehd(char *str)
-{
-	printk(KERN_INFO "fakehd : Changing ubd name to \"hd\".\n");
-	fakehd_set = 1;
-	return 1;
-}
-
-__setup("fakehd", fakehd);
-__uml_help(fakehd,
-"fakehd\n"
-"    Change the ubd device name to \"hd\".\n\n"
-);
-
 static void do_ubd_request(struct request_queue * q);
 
 /* Only changed by ubd_init, which is an initcall. */
@@ -730,8 +716,10 @@ static int ubd_add(int n, char **error_o
 		ubd_disk_register(fake_major, ubd_dev->size, n,
 				  &fake_gendisk[n]);
 
-	/* perhaps this should also be under the "if (fake_major)" above */
-	/* using the fake_disk->disk_name and also the fakehd_set name */
+	/*
+	 * Perhaps this should also be under the "if (fake_major)" above
+	 * using the fake_disk->disk_name
+	 */
 	if (fake_ide)
 		make_ide_entries(ubd_gendisk[n]->disk_name);
 
