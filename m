Return-Path: <linux-kernel-owner+w=401wt.eu-S1756359AbYLVTXU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756359AbYLVTXU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 14:23:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755906AbYLVTRo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 14:17:44 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:50184 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755891AbYLVTRm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 14:17:42 -0500
Subject: [PATCH 18/27] drivers/net/tulip: fix sparse warnings: make do-while a
	compound statement
To: netdev@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 22 Dec 2008 20:17:37 +0100
Message-ID: <20081222191737.11807.16256.stgit@vmbox.hanneseder.net>
In-Reply-To: <20081222191259.11807.53190.stgit@vmbox.hanneseder.net>
References: <20081222191259.11807.53190.stgit@vmbox.hanneseder.net>
User-Agent: StGit/0.14.3.292.gb975
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
From: Hannes Eder <hannes@hanneseder.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix this sparse warnings:

  drivers/net/tulip/de2104x.c:1695:4: warning: do-while statement is not a compound statement
  drivers/net/tulip/tulip_core.c:1433:5: warning: do-while statement is not a compound statement

Signed-off-by: Hannes Eder <hannes@hanneseder.net>
---
 drivers/net/tulip/de2104x.c    |    4 ++--
 drivers/net/tulip/tulip_core.c |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/tulip/de2104x.c b/drivers/net/tulip/de2104x.c
index 3aa60fa..5166be9 100644
--- a/drivers/net/tulip/de2104x.c
+++ b/drivers/net/tulip/de2104x.c
@@ -1691,9 +1691,9 @@ static void __devinit de21040_get_mac_address (struct de_private *de)
 
 	for (i = 0; i < 6; i++) {
 		int value, boguscnt = 100000;
-		do
+		do {
 			value = dr32(ROMCmd);
-		while (value < 0 && --boguscnt > 0);
+		} while (value < 0 && --boguscnt > 0);
 		de->dev->dev_addr[i] = value;
 		udelay(1);
 		if (boguscnt <= 0)
diff --git a/drivers/net/tulip/tulip_core.c b/drivers/net/tulip/tulip_core.c
index 1c5ef23..ff84bab 100644
--- a/drivers/net/tulip/tulip_core.c
+++ b/drivers/net/tulip/tulip_core.c
@@ -1429,9 +1429,9 @@ static int __devinit tulip_init_one (struct pci_dev *pdev,
 		for (i = 0; i < 3; i++) {
 			int value, boguscnt = 100000;
 			iowrite32(0x600 | i, ioaddr + 0x98);
-			do
+			do {
 				value = ioread32(ioaddr + CSR9);
-			while (value < 0  && --boguscnt > 0);
+			} while (value < 0  && --boguscnt > 0);
 			put_unaligned_le16(value, ((__le16 *)dev->dev_addr) + i);
 			sum += value & 0xffff;
 		}

