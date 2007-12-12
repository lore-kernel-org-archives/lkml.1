Return-Path: <linux-kernel-owner+w=401wt.eu-S1758198AbXLLEDx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758198AbXLLEDx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 23:03:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755945AbXLLECD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 23:02:03 -0500
Received: from wa-out-1112.google.com ([209.85.146.178]:40455 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752303AbXLLEBh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 23:01:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:mime-version:content-type:content-transfer-encoding:x-mailer:x-mimeole:thread-index;
        b=FrIgJN1P5OySRNnEVyxCWdPr9shSNJkUZ802o3hm1+9xUKznnfSnUE4VTgPB9S1P9h+U709ux5lP8bwxakEwkzNqVfkFBdLMl5Ho2yQuvQ38heokKzh/3eBiFhpJ3GmYvaCSKzwXPNYjDM7RO54mie8TxD7mrvSAzTT5VjSEkcE=
From: "Joonwoo Park" <joonwpark81@gmail.com>
To: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Cc: <jgarzik@pobox.com>, <baum@tehutinetworks.net>, <andy@greyhouse.net>
Subject: [PATCH 6/7] [NETDEV]: tehuti Fix possible causing oops of net_rx_action
Date: Wed, 12 Dec 2007 13:01:27 +0900
Message-ID: <002901c83c73$b089b6e0$9c94fea9@jason>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3198
Thread-Index: Acg8c6lPXjEfU997SU6rRsk2iU3d3w==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[NETDEV]: tehuti Fix possible causing oops of net_rx_action

Signed-off-by: Joonwoo Park <joonwpark81@gmail.com>
---
 drivers/net/tehuti.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/tehuti.c b/drivers/net/tehuti.c
index 21230c9..955e749 100644
--- a/drivers/net/tehuti.c
+++ b/drivers/net/tehuti.c
@@ -305,6 +305,8 @@ static int bdx_poll(struct napi_struct *napi, int budget)
 
 		netif_rx_complete(dev, napi);
 		bdx_enable_interrupts(priv);
+		if (unlikely(work_done == napi->weight))
+			return work_done - 1;
 	}
 	return work_done;
 }
---

