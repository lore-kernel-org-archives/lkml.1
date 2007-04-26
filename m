Return-Path: <linux-kernel-owner+w=401wt.eu-S1031484AbXDZUAb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031484AbXDZUAb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 16:00:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031487AbXDZUAb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 16:00:31 -0400
Received: from [198.99.130.12] ([198.99.130.12]:49649 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1031484AbXDZUA3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 16:00:29 -0400
Date: Thu, 26 Apr 2007 15:56:25 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: [PATCH 4/5] UML - Out of tmpfs space error clarification
Message-ID: <20070426195625.GA9573@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

It turns out that the message complaining about a lack of tmpfs space
on the host can be misunderstood as referring to the UML.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
--
 arch/um/kernel/trap.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6.21-mm/arch/um/kernel/trap.c
===================================================================
--- linux-2.6.21-mm.orig/arch/um/kernel/trap.c	2007-04-16 12:25:01.000000000 -0400
+++ linux-2.6.21-mm/arch/um/kernel/trap.c	2007-04-16 20:37:33.000000000 -0400
@@ -229,8 +229,8 @@ void relay_signal(int sig, union uml_pt_
 
 	if(!UPT_IS_USER(regs)){
 		if(sig == SIGBUS)
-			printk("Bus error - the /dev/shm or /tmp mount likely "
-			       "just ran out of space\n");
+			printk("Bus error - the host /dev/shm or /tmp mount "
+			       "likely just ran out of space\n");
 		panic("Kernel mode signal %d", sig);
 	}
 
