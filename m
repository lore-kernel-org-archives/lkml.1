Return-Path: <linux-kernel-owner+w=401wt.eu-S1753355AbXLLECx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753355AbXLLECx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 23:02:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754931AbXLLEBt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 23:01:49 -0500
Received: from wa-out-1112.google.com ([209.85.146.178]:40455 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753651AbXLLEBn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 23:01:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:mime-version:content-type:content-transfer-encoding:x-mailer:x-mimeole:thread-index;
        b=Q8OOXzZc8X7Jkxv1Dgdj7VEnjULPDApQl96kktz7BFIGZIbdFJ2C7fPYP90G7w0tgiLEZXJsJzuNRJcY1JYlwnDwof6sm1X7GW4PKUq55FUPzM2ARNEjNFELeYnEAF2mMo4HPGwwsohNpdojRZgfJDV8ve8h0wx6jkH+PssSt6I=
From: "Joonwoo Park" <joonwpark81@gmail.com>
To: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Cc: "'Kok, Auke'" <auke-jan.h.kok@intel.com>, <jesse.brandeburg@intel.com>,
       <jgarzik@pobox.com>
Subject: [PATCH 3/7] [NETDEV]: ixgb Fix possible causing oops of net_rx_action
Date: Wed, 12 Dec 2007 13:01:27 +0900
Message-ID: <002c01c83c73$b4115700$9c94fea9@jason>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3198
Thread-Index: Acg8c6XR08pOJ1jEQYyttnTX66Bing==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[NETDEV]: ixgb Fix possible causing oops of net_rx_action

Signed-off-by: Joonwoo Park <joonwpark81@gmail.com>
---
 drivers/net/ixgb/ixgb_main.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/ixgb/ixgb_main.c b/drivers/net/ixgb/ixgb_main.c
index 3021234..afe95d1 100644
--- a/drivers/net/ixgb/ixgb_main.c
+++ b/drivers/net/ixgb/ixgb_main.c
@@ -1785,6 +1785,8 @@ ixgb_clean(struct napi_struct *napi, int budget)
 	if((!tx_cleaned && (work_done == 0)) || !netif_running(netdev)) {
 		netif_rx_complete(netdev, napi);
 		ixgb_irq_enable(adapter);
+		if (unlikely(work_done == napi->weight))
+			return work_done - 1;
 	}
 
 	return work_done;
---

