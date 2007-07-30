Return-Path: <linux-kernel-owner+w=401wt.eu-S966508AbXG3RK2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966508AbXG3RK2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 13:10:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967048AbXG3RJo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 13:09:44 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:37199 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966996AbXG3RJm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 13:09:42 -0400
Date: Mon, 30 Jul 2007 13:09:13 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: [PATCH 3/4] UML - Fix error cleanup ordering
Message-ID: <20070730170913.GA7697@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I messed up the error cleanup ordering in the console port driver.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
--
 arch/um/drivers/port_kern.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6.21-mm/arch/um/drivers/port_kern.c
===================================================================
--- linux-2.6.21-mm.orig/arch/um/drivers/port_kern.c	2007-07-27 11:56:14.000000000 -0400
+++ linux-2.6.21-mm/arch/um/drivers/port_kern.c	2007-07-27 11:57:07.000000000 -0400
@@ -216,10 +216,10 @@ void *port_data(int port_num)
 				    .telnetd_pid  	= -1 });
 	goto out;
 
- out_free:
-	kfree(port);
  out_close:
 	os_close_file(fd);
+ out_free:
+	kfree(port);
  out:
 	up(&ports_sem);
 	return dev;
