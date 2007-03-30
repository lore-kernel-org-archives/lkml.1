Return-Path: <linux-kernel-owner+w=401wt.eu-S1753507AbXC3O4m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753507AbXC3O4m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 10:56:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753501AbXC3O4m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 10:56:42 -0400
Received: from [198.99.130.12] ([198.99.130.12]:57895 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1753507AbXC3O4k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 10:56:40 -0400
Date: Fri, 30 Mar 2007 10:52:55 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>
Cc: Davide Brini <davide.brini@unibo.it>, LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: [PATCH 1/2] UML - Fix umid in xterm titles
Message-ID: <20070330145255.GA5466@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Davide Brini <davide.brini@unibo.it>

Calls lines_init() *after* xterm_title is modified to include umid.

Signed-off-by: Davide Brini <davide.brini@unibo.it>
Signed-off-by: Jeff Dike <jdike@linux.intel.com>
--
 arch/um/drivers/ssl.c           |    4 ++--
 arch/um/drivers/stdio_console.c |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

Index: linux-2.6.21-mm/arch/um/drivers/ssl.c
===================================================================
--- linux-2.6.21-mm.orig/arch/um/drivers/ssl.c	2007-03-30 10:11:01.000000000 -0400
+++ linux-2.6.21-mm/arch/um/drivers/ssl.c	2007-03-30 10:28:51.000000000 -0400
@@ -191,12 +191,12 @@ static int ssl_init(void)
 	ssl_driver = register_lines(&driver, &ssl_ops, serial_lines,
 				    ARRAY_SIZE(serial_lines));
 
-	lines_init(serial_lines, ARRAY_SIZE(serial_lines), &opts);
-
 	new_title = add_xterm_umid(opts.xterm_title);
 	if (new_title != NULL)
 		opts.xterm_title = new_title;
 
+	lines_init(serial_lines, ARRAY_SIZE(serial_lines), &opts);
+
 	ssl_init_done = 1;
 	register_console(&ssl_cons);
 	return 0;
Index: linux-2.6.21-mm/arch/um/drivers/stdio_console.c
===================================================================
--- linux-2.6.21-mm.orig/arch/um/drivers/stdio_console.c	2007-03-30 10:11:01.000000000 -0400
+++ linux-2.6.21-mm/arch/um/drivers/stdio_console.c	2007-03-30 10:28:51.000000000 -0400
@@ -166,12 +166,12 @@ int stdio_init(void)
 		return -1;
 	printk(KERN_INFO "Initialized stdio console driver\n");
 
-	lines_init(vts, ARRAY_SIZE(vts), &opts);
-
 	new_title = add_xterm_umid(opts.xterm_title);
 	if(new_title != NULL)
 		opts.xterm_title = new_title;
 
+	lines_init(vts, ARRAY_SIZE(vts), &opts);
+
 	con_init_done = 1;
 	register_console(&stdiocons);
 	return 0;
