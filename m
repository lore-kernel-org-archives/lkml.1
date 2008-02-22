Return-Path: <linux-kernel-owner+w=401wt.eu-S1759971AbYBVOxA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759971AbYBVOxA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 09:53:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753374AbYBVOrp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 09:47:45 -0500
Received: from general-networks3.cust.sloane.cz ([88.146.176.14]:42326 "EHLO
	server.generalnetworks.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755239AbYBVOrm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 09:47:42 -0500
From: Jiri Slaby <jirislaby@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>, <alan@lxorguk.ukuu.org.uk>,
       Oyvind Aabling <Oyvind.Aabling@uni-c.dk>,
       Jiri Slaby <jirislaby@gmail.com>
Subject: [PATCH 19/19] Char: moxa, notify about board readiness
Date: Fri, 22 Feb 2008 15:46:46 +0100
Message-Id: <1203691606-9310-19-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.5.4.1
In-Reply-To: <1203691606-9310-1-git-send-email-jirislaby@gmail.com>
References: <1203691606-9310-1-git-send-email-jirislaby@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Drop a message to dmesg about card being ready.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Tested-by: Oyvind Aabling <Oyvind.Aabling@uni-c.dk>
---
 drivers/char/moxa.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/char/moxa.c b/drivers/char/moxa.c
index ee8b821..4d595db 100644
--- a/drivers/char/moxa.c
+++ b/drivers/char/moxa.c
@@ -961,6 +961,9 @@ static int __devinit moxa_pci_probe(struct pci_dev *pdev,
 
 	pci_set_drvdata(pdev, board);
 
+	dev_info(&pdev->dev, "board '%s' ready (%u ports, firmware loaded)\n",
+			moxa_brdname[board_type - 1], board->numPorts);
+
 	return 0;
 err_base:
 	iounmap(board->basemem);
@@ -1046,6 +1049,10 @@ static int __init moxa_init(void)
 				continue;
 			}
 
+			printk(KERN_INFO "MOXA isa board found at 0x%.8lu and "
+					"ready (%u ports, firmware loaded)\n",
+					baseaddr[i], brd->numPorts);
+
 			brd++;
 			isabrds++;
 		}
-- 
1.5.4.1

