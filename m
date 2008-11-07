Return-Path: <linux-kernel-owner+w=401wt.eu-S1753640AbYKGNfk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753640AbYKGNfk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 08:35:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752226AbYKGNfZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 08:35:25 -0500
Received: from hpsmtp-eml20.KPNXCHANGE.COM ([213.75.38.85]:4181 "EHLO
	hpsmtp-eml20.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752185AbYKGNfX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 08:35:23 -0500
From: Frans Pop <elendil@planet.nl>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] pcmcia: minor logging improvement on card detection
Date: Fri, 7 Nov 2008 14:35:15 +0100
User-Agent: KMail/1.9.9
Cc: linux@dominikbrodowski.net, linux-pcmcia@lists.infradead.org
References: <200811031942.20360.elendil@planet.nl> <200811071419.11050.elendil@planet.nl>
In-Reply-To: <200811071419.11050.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811071435.15934.elendil@planet.nl>
X-OriginalArrivalTime: 07 Nov 2008 13:35:18.0522 (UTC) FILETIME=[ACA515A0:01C940DD]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Frans Pop <elendil@planet.nl>

pcmcia: minor logging improvement on card detection
    
Show for which device a card has been inserted, so instead of:
   pcmcia_socket pcmcia_socket0: pccard: CardBus card inserted into slot 0
print:
   yenta_cardbus 0000:01:0b.0: pccard: CardBus card inserted into slot 0
    
This provides a more logical link between previous and following messages.
    
Signed-off-by: Frans Pop <elendil@planet.nl>
CC: Dominik Brodowski <linux@dominikbrodowski.net>

diff --git a/drivers/pcmcia/cs.c b/drivers/pcmcia/cs.c
index c68c5d3..c249776 100644
--- a/drivers/pcmcia/cs.c
+++ b/drivers/pcmcia/cs.c
@@ -510,7 +510,7 @@ static int socket_insert(struct pcmcia_socket *skt)
 	if (ret == 0) {
 		skt->state |= SOCKET_PRESENT;
 
-		dev_printk(KERN_NOTICE, &skt->dev,
+		dev_printk(KERN_NOTICE, &skt->cb_dev->dev,
 			   "pccard: %s card inserted into slot %d\n",
 			   (skt->state & SOCKET_CARDBUS) ? "CardBus" : "PCMCIA",
 			   skt->sock);
