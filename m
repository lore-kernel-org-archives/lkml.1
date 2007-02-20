Return-Path: <linux-kernel-owner+w=401wt.eu-S1030524AbXBTWhq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030524AbXBTWhq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 17:37:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030531AbXBTWhq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 17:37:46 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:47826 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030521AbXBTWho (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 17:37:44 -0500
Date: Tue, 20 Feb 2007 16:37:42 -0600
To: Jeff Garzik <jeff@garzik.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       kou.ishizaki@toshiba.co.jp, arnd@arndb.de,
       Jens Osterkamp <jens@de.ibm.com>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 6/12] spidernet: remove txram full logging
Message-ID: <20070220223742.GF28895@austin.ibm.com>
References: <20070220221314.GU923@austin.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070220221314.GU923@austin.ibm.com>
User-Agent: Mutt/1.5.11
From: linas@austin.ibm.com (Linas Vepstas)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Ishizaki Kou <kou.ishizaki@toshiba.co.jp>

This patches removes logging for SPIDER_NET_GTMFLLINT interrupts.
Since the interrupts are not irregular, and they happen frequently
when using 100Mbps network switches.

Signed-off-by: Kou Ishizaki <kou.ishizaki@toshiba.co.jp>
Signed-off-by: Linas Vepstas <linas@austin.ibm.com>

----
 drivers/net/spider_net.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6.20-git16/drivers/net/spider_net.c
===================================================================
--- linux-2.6.20-git16.orig/drivers/net/spider_net.c	2007-02-20 15:02:38.000000000 -0600
+++ linux-2.6.20-git16/drivers/net/spider_net.c	2007-02-20 15:02:40.000000000 -0600
@@ -1422,8 +1422,8 @@ spider_net_handle_error_irq(struct spide
 				switch (i)
 	{
 	case SPIDER_NET_GTMFLLINT:
-		if (netif_msg_intr(card) && net_ratelimit())
-			pr_err("Spider TX RAM full\n");
+		/* TX RAM full may happen on a usual case.
+		 * Logging is not needed. */
 		show_error = 0;
 		break;
 	case SPIDER_NET_GRFDFLLINT: /* fallthrough */
