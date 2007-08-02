Return-Path: <linux-kernel-owner+w=401wt.eu-S1760804AbXHBVGW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760804AbXHBVGW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 17:06:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760992AbXHBVFQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 17:05:16 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:43974 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759131AbXHBVFF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 17:05:05 -0400
Date: Thu, 2 Aug 2007 17:04:37 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>,
       "Robert P. J. Day" <rpjday@mindspring.com>
Subject: [PATCH 3/6] UML - Fix nonremovability of watchdog
Message-ID: <20070802210437.GA11189@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The UML watchdog driver was using the wrong config variable to control
whether it can be unloaded once active.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
--
 arch/um/drivers/harddog_kern.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.21-mm/arch/um/drivers/harddog_kern.c
===================================================================
--- linux-2.6.21-mm.orig/arch/um/drivers/harddog_kern.c	2007-08-02 16:43:17.000000000 -0400
+++ linux-2.6.21-mm/arch/um/drivers/harddog_kern.c	2007-08-02 16:43:24.000000000 -0400
@@ -69,7 +69,7 @@ static int harddog_open(struct inode *in
 	spin_lock(&lock);
 	if(timer_alive)
 		goto err;
-#ifdef CONFIG_HARDDOG_NOWAYOUT
+#ifdef CONFIG_WATCHDOG_NOWAYOUT
 	__module_get(THIS_MODULE);
 #endif
 
