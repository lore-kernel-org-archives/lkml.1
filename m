Return-Path: <linux-kernel-owner+w=401wt.eu-S1754334AbZBNVfu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754334AbZBNVfu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Feb 2009 16:35:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752262AbZBNVfm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Feb 2009 16:35:42 -0500
Received: from mu-out-0910.google.com ([209.85.134.184]:34707 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752148AbZBNVfl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Feb 2009 16:35:41 -0500
From: Hannes Eder <hannes@hanneseder.net>
Subject: [PATCH 21/43] drivers/net/hamradio: fix sparse warning: symbol
	shadows an earlier one
To: netdev@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Sat, 14 Feb 2009 22:35:35 +0100
Message-ID: <20090214213505.24377.11448.stgit@vmbox.hanneseder.net>
In-Reply-To: <20090214210940.23489.95001.stgit@vmbox.hanneseder.net>
References: <20090214210940.23489.95001.stgit@vmbox.hanneseder.net>
User-Agent: StGit/0.14.3.348.gcb02
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: Rename inner scrope variable.

Fix this sparse warning:
  drivers/net/hamradio/yam.c:856:35: warning: symbol 'dev' shadows an earlier one

Signed-off-by: Hannes Eder <hannes@hanneseder.net>
---
 drivers/net/hamradio/yam.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/hamradio/yam.c b/drivers/net/hamradio/yam.c
index a54b865..500a40b 100644
--- a/drivers/net/hamradio/yam.c
+++ b/drivers/net/hamradio/yam.c
@@ -854,10 +854,10 @@ static int yam_open(struct net_device *dev)
 
 	/* Reset overruns for all ports - FPGA programming makes overruns */
 	for (i = 0; i < NR_PORTS; i++) {
-		struct net_device *dev = yam_devs[i];
+		struct net_device *yam_dev = yam_devs[i];
 
-		inb(LSR(dev->base_addr));
-		dev->stats.rx_fifo_errors = 0;
+		inb(LSR(yam_dev->base_addr));
+		yam_dev->stats.rx_fifo_errors = 0;
 	}
 
 	printk(KERN_INFO "%s at iobase 0x%lx irq %u uart %s\n", dev->name, dev->base_addr, dev->irq,

