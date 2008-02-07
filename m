Return-Path: <linux-kernel-owner+w=401wt.eu-S933548AbYBGTR1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933548AbYBGTR1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 14:17:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933376AbYBGTQL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 14:16:11 -0500
Received: from general-networks3.cust.sloane.cz ([88.146.176.14]:39232 "EHLO
	server.generalnetworks.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933369AbYBGTQK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 14:16:10 -0500
From: Jiri Slaby <jirislaby@gmail.com>
To: "Oyvind Aabling" <Oyvind.Aabling@uni-c.dk>
Cc: <linux-kernel@vger.kernel.org>, Jiri Slaby <jirislaby@gmail.com>
Subject: [RFT 8/9] Char: moxa, notify about board readiness
Date: Thu,  7 Feb 2008 20:11:24 +0100
Message-Id: <1202411485-16022-8-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <1202411485-16022-1-git-send-email-jirislaby@gmail.com>
References: <1202411485-16022-1-git-send-email-jirislaby@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Drop a message to dmesg about card is being ready.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
---
 drivers/char/moxa.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/char/moxa.c b/drivers/char/moxa.c
index 3b1760f..fd9c946 100644
--- a/drivers/char/moxa.c
+++ b/drivers/char/moxa.c
@@ -943,6 +943,8 @@ static int __devinit moxa_pci_probe(struct pci_dev *pdev,
 
 	pci_set_drvdata(pdev, board);
 
+	dev_info(&pdev->dev, "board ready (firmware loaded)\n");
+
 	return 0;
 err_base:
 	iounmap(board->basemem);
@@ -1028,6 +1030,10 @@ static int __init moxa_init(void)
 				continue;
 			}
 
+			printk(KERN_INFO "moxa isa board found at 0x%.8lu and "
+					"ready (firmware loaded)\n",
+					baseaddr[i]);
+
 			brd++;
 			isabrds++;
 		}
-- 
1.5.3.8

