Return-Path: <linux-kernel-owner+w=401wt.eu-S1761386AbXJMITz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761386AbXJMITz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2007 04:19:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752286AbXJMITl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Oct 2007 04:19:41 -0400
Received: from mail.suse.de ([195.135.220.2]:53729 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751326AbXJMITj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2007 04:19:39 -0400
Date: Sat, 13 Oct 2007 10:19:37 +0200
From: Marcus Meissner <meissner@suse.de>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH] tokenring/3c359.c: fixed array index problem
Message-ID: <20071013081937.GA22759@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: SUSE LINUX Products GmbH, GF: Markus Rex, HRB 16746 (AG
	Nuernberg)
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I tried to send this to netdev and various maintainers, but
they seem not to have seen it.

Please add to -mm and have it merged somewhere.


The xl_laa array is just 6 bytes long, so we should substract
10 from the index, like is also done some lines above already.

Signed-Off-By: Marcus Meissner <meissner@suse.de>
---
 drivers/net/tokenring/3c359.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/tokenring/3c359.c b/drivers/net/tokenring/3c359.c
index 7224d36..5d31519 100644
--- a/drivers/net/tokenring/3c359.c
+++ b/drivers/net/tokenring/3c359.c
@@ -760,7 +760,7 @@ static int xl_open_hw(struct net_device *dev)
 	if (xl_priv->xl_laa[0]) {  /* If using a LAA address */
 		for (i=10;i<16;i++) { 
 			writel( (MEM_BYTE_WRITE | 0xD0000 | xl_priv->srb) + i, xl_mmio + MMIO_MAC_ACCESS_CMD) ; 
-			writeb(xl_priv->xl_laa[i],xl_mmio + MMIO_MACDATA) ; 
+			writeb(xl_priv->xl_laa[i-10],xl_mmio + MMIO_MACDATA) ;
 		}
 		memcpy(dev->dev_addr,xl_priv->xl_laa,dev->addr_len) ; 
 	} else { /* Regular hardware address */ 
-- 
1.5.2.4

-- 
Working, but not speaking, for the following german company:
SUSE LINUX Products GmbH, GF: Markus Rex, HRB 16746 (AG Nuernberg)
