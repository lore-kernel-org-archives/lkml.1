Return-Path: <linux-kernel-owner+w=401wt.eu-S1753772AbXLLECg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753772AbXLLECg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 23:02:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754816AbXLLEBq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 23:01:46 -0500
Received: from wa-out-1112.google.com ([209.85.146.177]:40145 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751334AbXLLEBk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 23:01:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:mime-version:content-type:content-transfer-encoding:x-mailer:x-mimeole:thread-index;
        b=NcIPV3FV4gaTPXks0ACmApiiLu1LxTp7FGAST4a1v84OsEoyBHxaeK5wZM7kjyTd7LqAF7A1BHHKwESlWk6mUdoIaTeeF3ORuBZKRNo73bAg+EW6zpIGxwKPwsYClNjxTS60B02HP7ygx7EKJxVZwTjgWoEMy03kFaa00faoLjg=
From: "Joonwoo Park" <joonwpark81@gmail.com>
To: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Cc: "'Kok, Auke'" <auke-jan.h.kok@intel.com>, <jesse.brandeburg@intel.com>,
       <jgarzik@pobox.com>
Subject: [PATCH 4/7] [NETDEV]: ixgbe Fix possible causing oops of net_rx_action
Date: Wed, 12 Dec 2007 13:01:27 +0900
Message-ID: <002b01c83c73$b2bebf50$9c94fea9@jason>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3198
Thread-Index: Acg8c6bo+Zz6i9dlTF6cSlgXlAK4fA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[NETDEV]: ixgbe Fix possible causing oops of net_rx_action

Signed-off-by: Joonwoo Park <joonwpark81@gmail.com>
---
 drivers/net/ixgbe/ixgbe_main.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/net/ixgbe/ixgbe_main.c b/drivers/net/ixgbe/ixgbe_main.c
index 00bc525..0b3ae8f 100644
--- a/drivers/net/ixgbe/ixgbe_main.c
+++ b/drivers/net/ixgbe/ixgbe_main.c
@@ -583,6 +583,8 @@ quit_polling:
 		if (!test_bit(__IXGBE_DOWN, &adapter->state))
 			IXGBE_WRITE_REG(&adapter->hw, IXGBE_EIMS,
 					rxr->eims_value);
+		if (unlikely(work_done == napi->weight))
+			return work_done - 1;
 	}
 
 	return work_done;
@@ -1485,6 +1487,8 @@ static int ixgbe_clean(struct napi_struct *napi, int budget)
 quit_polling:
 		netif_rx_complete(netdev, napi);
 		ixgbe_irq_enable(adapter);
+		if (unlikely(work_done == napi->weight))
+			return work_done - 1;
 	}
 
 	return work_done;
---

