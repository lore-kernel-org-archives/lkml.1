Return-Path: <linux-kernel-owner+w=401wt.eu-S1755847AbYCTPoI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755847AbYCTPoI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2008 11:44:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753409AbYCTPny
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Mar 2008 11:43:54 -0400
Received: from smtp-out1.tiscali.nl ([195.241.79.176]:45428 "EHLO
	smtp-out1.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753244AbYCTPny (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2008 11:43:54 -0400
Message-ID: <47E28637.4010700@tiscali.nl>
Date: Thu, 20 Mar 2008 16:43:51 +0100
From: Roel Kluin <12o3l@tiscali.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: khc@pm.waw.pl
CC: lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] drivers/net/wan/wanxl.c: time_before(timeout, jiffies) ->
 jiffies, timeout
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not tested, please confirm it's right
---
fix reversal of timeout and jiffies

Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
---
diff --git a/drivers/net/wan/wanxl.c b/drivers/net/wan/wanxl.c
index d4aab8a..f61413b 100644
--- a/drivers/net/wan/wanxl.c
+++ b/drivers/net/wan/wanxl.c
@@ -650,7 +650,7 @@ static int __devinit wanxl_pci_init_one(struct pci_dev *pdev,
 
 	timeout = jiffies + 20 * HZ;
 	while ((stat = readl(card->plx + PLX_MAILBOX_0)) != 0) {
-		if (time_before(timeout, jiffies)) {
+		if (time_before(jiffies, timeout)) {
 			printk(KERN_WARNING "wanXL %s: timeout waiting for"
 			       " PUTS to complete\n", pci_name(pdev));
 			wanxl_pci_remove_one(pdev);
