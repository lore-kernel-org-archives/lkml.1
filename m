Return-Path: <linux-kernel-owner+w=401wt.eu-S1752032AbXBVWxj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752032AbXBVWxj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 17:53:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752033AbXBVWxj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 17:53:39 -0500
Received: from [198.99.130.12] ([198.99.130.12]:35933 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1752032AbXBVWxi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 17:53:38 -0500
Date: Thu, 22 Feb 2007 17:45:27 -0500
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>, Blaisorblade <blaisorblade@yahoo.it>
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: [PATCH 2/2] UML - add back accidentally removed error
Message-ID: <20070222224527.GA7984@ccure.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In the 2.6.20 hang patch, I accidentally threw out an error message.
This puts it back.

Signed-off-by: Jeff Dike <jdike@addtoit.com>
--
 arch/um/os-Linux/sigio.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

Index: linux-2.6.18-mm/arch/um/os-Linux/sigio.c
===================================================================
--- linux-2.6.18-mm.orig/arch/um/os-Linux/sigio.c	2007-02-20 16:12:28.000000000 -0500
+++ linux-2.6.18-mm/arch/um/os-Linux/sigio.c	2007-02-22 13:05:04.000000000 -0500
@@ -334,8 +334,11 @@ void maybe_sigio_broken(int fd, int read
 
 	sigio_lock();
 	err = need_poll(&all_sigio_fds, all_sigio_fds.used + 1);
-	if(err)
+	if(err){
+		printk("maybe_sigio_broken - failed to add pollfd for "
+		       "descriptor %d\n", fd);
 		goto out;
+	}
 
 	all_sigio_fds.poll[all_sigio_fds.used++] =
 		((struct pollfd) { .fd  	= fd,
