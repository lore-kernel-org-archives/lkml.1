Return-Path: <linux-kernel-owner+w=401wt.eu-S1753832AbZBNVPB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753832AbZBNVPB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Feb 2009 16:15:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754258AbZBNVNp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Feb 2009 16:13:45 -0500
Received: from mu-out-0910.google.com ([209.85.134.184]:32871 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752619AbZBNVNo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Feb 2009 16:13:44 -0500
From: Hannes Eder <hannes@hanneseder.net>
Subject: [PATCH 07/43] drivers/net/ni65.c: fix sparse warnings: fix signedness
To: netdev@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Sat, 14 Feb 2009 22:13:39 +0100
Message-ID: <20090214211332.23489.25144.stgit@vmbox.hanneseder.net>
In-Reply-To: <20090214210940.23489.95001.stgit@vmbox.hanneseder.net>
References: <20090214210940.23489.95001.stgit@vmbox.hanneseder.net>
User-Agent: StGit/0.14.3.348.gcb02
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix this sparse warnings:
  drivers/net/ni65.c:488:36: warning: incorrect type in argument 2 (different signedness)

Signed-off-by: Hannes Eder <hannes@hanneseder.net>
---
 drivers/net/ni65.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ni65.c b/drivers/net/ni65.c
index d769a88..df5f869 100644
--- a/drivers/net/ni65.c
+++ b/drivers/net/ni65.c
@@ -481,8 +481,9 @@ static int __init ni65_probe1(struct net_device *dev,int ioaddr)
 	else {
 		if(dev->dma == 0) {
 		/* 'stuck test' from lance.c */
-			long dma_channels = ((inb(DMA1_STAT_REG) >> 4) & 0x0f) |
-					    (inb(DMA2_STAT_REG) & 0xf0);
+			unsigned long dma_channels =
+				((inb(DMA1_STAT_REG) >> 4) & 0x0f)
+				| (inb(DMA2_STAT_REG) & 0xf0);
 			for(i=1;i<5;i++) {
 				int dma = dmatab[i];
 				if(test_bit(dma,&dma_channels) || request_dma(dma,"ni6510"))

