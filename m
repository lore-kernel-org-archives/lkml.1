Return-Path: <linux-kernel-owner+w=401wt.eu-S1762521AbXJLQp5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762521AbXJLQp5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 12:45:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760779AbXJLQpJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 12:45:09 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:60889 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761502AbXJLQpH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 12:45:07 -0400
Date: Fri, 12 Oct 2007 12:44:18 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>
Cc: uml-devel <user-mode-linux-devel@lists.sourceforge.net>,
       LKML <linux-kernel@vger.kernel.org>,
       Alexander Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH] UML - header_ops conversion needed for non-ethernet drivers
Message-ID: <20071012164357.GA7704@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

UML's two non-ethernet drivers need some header_ops conversion.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
---
 arch/um/drivers/slip_kern.c  |    4 +---
 arch/um/drivers/slirp_kern.c |    4 +---
 2 files changed, 2 insertions(+), 6 deletions(-)

Index: linux-2.6.22/arch/um/drivers/slip_kern.c
===================================================================
--- linux-2.6.22.orig/arch/um/drivers/slip_kern.c	2007-10-12 12:09:00.000000000 -0400
+++ linux-2.6.22/arch/um/drivers/slip_kern.c	2007-10-12 12:24:37.000000000 -0400
@@ -31,10 +31,8 @@ void slip_init(struct net_device *dev, v
 	slip_proto_init(&spri->slip);
 
 	dev->init = NULL;
-	dev->header_cache_update = NULL;
-	dev->hard_header_cache = NULL;
-	dev->hard_header = NULL;
 	dev->hard_header_len = 0;
+	dev->header_ops = NULL;
 	dev->addr_len = 0;
 	dev->type = ARPHRD_SLIP;
 	dev->tx_queue_len = 256;
Index: linux-2.6.22/arch/um/drivers/slirp_kern.c
===================================================================
--- linux-2.6.22.orig/arch/um/drivers/slirp_kern.c	2007-10-12 12:09:00.000000000 -0400
+++ linux-2.6.22/arch/um/drivers/slirp_kern.c	2007-10-12 12:24:42.000000000 -0400
@@ -34,9 +34,7 @@ void slirp_init(struct net_device *dev, 
 
 	dev->init = NULL;
 	dev->hard_header_len = 0;
-	dev->header_cache_update = NULL;
-	dev->hard_header_cache = NULL;
-	dev->hard_header = NULL;
+	dev->header_ops = NULL;
 	dev->addr_len = 0;
 	dev->type = ARPHRD_SLIP;
 	dev->tx_queue_len = 256;
