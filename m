Return-Path: <linux-kernel-owner+w=401wt.eu-S1755837AbXJCBCo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755837AbXJCBCo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 21:02:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753166AbXJCBCe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 21:02:34 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46129 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753121AbXJCBCd (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 21:02:33 -0400
Date: Tue, 2 Oct 2007 18:02:09 -0700
From: Stephen Hemminger <shemminger@linux-foundation.org>
To: pomac@vapor.com, Jeff Garzik <jgarzik@pobox.com>
Cc: Linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH] sky2: jumbo frame regression fix
Message-ID: <20071002180209.47c350a3@freepuppy.rosehill>
In-Reply-To: <1191372129.26233.12.camel@localhost>
References: <1191372129.26233.12.camel@localhost>
Organization: Linux Foundation
X-Mailer: Claws Mail 3.0.0 (GTK+ 2.10.14; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Remove unneeded check that caused problems with jumbo frame sizes.
The check was recently added and is wrong.
When using jumbo frames the sky2 driver does fragmentation, so
rx_data_size is less than mtu.

Signed-off-by: Stephen Hemminger <shemminger@linux-foundation.org>

--- a/drivers/net/sky2.c	2007-10-02 17:56:31.000000000 -0700
+++ b/drivers/net/sky2.c	2007-10-02 17:58:56.000000000 -0700
@@ -2163,9 +2163,6 @@ static struct sk_buff *sky2_receive(stru
 	sky2->rx_next = (sky2->rx_next + 1) % sky2->rx_pending;
 	prefetch(sky2->rx_ring + sky2->rx_next);
 
-	if (length < ETH_ZLEN || length > sky2->rx_data_size)
-		goto len_error;
-
 	/* This chip has hardware problems that generates bogus status.
 	 * So do only marginal checking and expect higher level protocols
 	 * to handle crap frames.
