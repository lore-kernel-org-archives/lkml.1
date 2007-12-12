Return-Path: <linux-kernel-owner+w=401wt.eu-S1757173AbXLLEDP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757173AbXLLEDP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 23:03:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755154AbXLLEBv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 23:01:51 -0500
Received: from wa-out-1112.google.com ([209.85.146.176]:40756 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754778AbXLLEBs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 23:01:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:mime-version:content-type:content-transfer-encoding:x-mailer:x-mimeole:thread-index;
        b=uFHYNVhrrCMYhgxVeRdfm1Ao2MKNPBFmNSafcChN4qzZXb9e/G9rsYVM+v5tTc0DCIL9orbTdWtdOoWDSnsJAFTwSGXy8oFqHfaDfMgijtK+18tlkW2ClIg9K4cOc+TG7ymvf45XL5tllsV8IVFWykOberIEEvIndifXLdygU+s=
From: "Joonwoo Park" <joonwpark81@gmail.com>
To: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Cc: "'Kok, Auke'" <auke-jan.h.kok@intel.com>, <jesse.brandeburg@intel.com>,
       <jgarzik@pobox.com>
Subject: [PATCH 1/7] [NETDEV]: e1000 Fix possible causing oops of net_rx_action
Date: Wed, 12 Dec 2007 13:01:27 +0900
Message-ID: <002e01c83c73$b6f934b0$9c94fea9@jason>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3198
Thread-Index: Acg8c6LK9pQbqylDSJSBZ+1x9ejIPA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[NETDEV]: e1000 Fix possible causing oops of net_rx_action
returning work_done == weight as true after calling netif_rx_complete will cause oops in net_rx_action.

Thanks
Joonwoo

Signed-off-by: Joonwoo Park <joonwpark81@gmail.com>
---
 drivers/net/e1000/e1000_main.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/e1000/e1000_main.c b/drivers/net/e1000/e1000_main.c
index 4f37506..4dd61e3 100644
--- a/drivers/net/e1000/e1000_main.c
+++ b/drivers/net/e1000/e1000_main.c
@@ -3949,6 +3949,8 @@ quit_polling:
 			e1000_set_itr(adapter);
 		netif_rx_complete(poll_dev, napi);
 		e1000_irq_enable(adapter);
+		if (unlikely(work_done == napi->weight))
+			return work_done - 1;
 	}
 
 	return work_done;
---

