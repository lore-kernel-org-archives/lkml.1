Return-Path: <linux-kernel-owner+w=401wt.eu-S1752090AbZL3Lko@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752090AbZL3Lko (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 06:40:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751734AbZL3Lkn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 06:40:43 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:46882 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751395AbZL3Lkm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 06:40:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=fhJB1uBHb5vNCCE6HQdrCp/NCjkmS0i9IbMlkqwxfgnwNkgobjSjTqS1Xl1nOeEYlc
         1gYZsybh2J/TjPchoH8L+jJ2DOyxmrhaaTBsuyCt60cGDohMCk7sRamINkY1ldE9RzR2
         57Ol5MQv5nxjmoXDXDRupXb1erIQGzYPyO1p0=
Message-ID: <4B3B3CF1.6060107@gmail.com>
Date: Wed, 30 Dec 2009 12:43:45 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: netdev@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "David S. Miller" <davem@davemloft.net>
Subject: [PATCH] net: Test off by one in sh_eth_reset()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If no break occurred, cnt reaches 0 after the loop.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
 drivers/net/sh_eth.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/sh_eth.c b/drivers/net/sh_eth.c
index ca62850..7402b85 100644
--- a/drivers/net/sh_eth.c
+++ b/drivers/net/sh_eth.c
@@ -110,7 +110,7 @@ static void sh_eth_reset(struct net_device *ndev)
 		mdelay(1);
 		cnt--;
 	}
-	if (cnt < 0)
+	if (cnt == 0)
 		printk(KERN_ERR "Device reset fail\n");
 
 	/* Table Init */
