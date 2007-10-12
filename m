Return-Path: <linux-kernel-owner+w=401wt.eu-S1761882AbXJLSHR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761882AbXJLSHR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 14:07:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759111AbXJLSG5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 14:06:57 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46075 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759004AbXJLSG4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 14:06:56 -0400
Date: Fri, 12 Oct 2007 11:06:45 -0700
From: Stephen Hemminger <shemminger@linux-foundation.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       "David S. Miller" <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-2.6] uml: hard_header fix
Message-ID: <20071012110645.4e7622af@freepuppy.rosehill>
In-Reply-To: <20071012001325.ba02a6f0.akpm@linux-foundation.org>
References: <20071011213126.cf92efb7.akpm@linux-foundation.org>
	<20071012140328.f82af8e8.kamezawa.hiroyu@jp.fujitsu.com>
	<20071011234202.2f15bb76.akpm@linux-foundation.org>
	<20071012064658.GA8181@ftp.linux.org.uk>
	<20071012001325.ba02a6f0.akpm@linux-foundation.org>
Organization: Linux Foundation
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.10.14; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Fix hard_header for net-2.6 (2.6.23-mm1).

Please test this patch, unfortunately the tree it came from won't
build UML, so it isn't possible to give it a proper check.

Signed-off-by: Stephen Hemminger <shemminger@linux-foundation.org>

--- a/arch/um/drivers/slip_kern.c	2007-10-11 13:16:07.000000000 -0700
+++ b/arch/um/drivers/slip_kern.c	2007-10-12 11:06:00.000000000 -0700
@@ -30,9 +30,7 @@ void slip_init(struct net_device *dev, v
 	slip_proto_init(&spri->slip);
 
 	dev->init = NULL;
-	dev->header_cache_update = NULL;
-	dev->hard_header_cache = NULL;
-	dev->hard_header = NULL;
+	dev->hard_header_ops = NULL;
 	dev->hard_header_len = 0;
 	dev->addr_len = 0;
 	dev->type = ARPHRD_SLIP;
--- a/arch/um/drivers/slirp_kern.c	2007-10-11 13:16:07.000000000 -0700
+++ b/arch/um/drivers/slirp_kern.c	2007-10-12 11:05:52.000000000 -0700
@@ -31,9 +31,7 @@ void slirp_init(struct net_device *dev, 
 
 	dev->init = NULL;
 	dev->hard_header_len = 0;
-	dev->header_cache_update = NULL;
-	dev->hard_header_cache = NULL;
-	dev->hard_header = NULL;
+	dev->hard_header_ops = NULL;
 	dev->addr_len = 0;
 	dev->type = ARPHRD_SLIP;
 	dev->tx_queue_len = 256;
