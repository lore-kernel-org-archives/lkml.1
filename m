Return-Path: <linux-kernel-owner+w=401wt.eu-S1758058AbXLLEDg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758058AbXLLEDg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 23:03:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754086AbXLLEB5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 23:01:57 -0500
Received: from wa-out-1112.google.com ([209.85.146.177]:40145 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753835AbXLLEBp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 23:01:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:mime-version:content-type:content-transfer-encoding:x-mailer:x-mimeole:thread-index;
        b=Sc2JeepYPWNhFniYg4PRPBOAerM3N04fpd6Zh7OT/tVi0nc4YlFLBctd0uYry4tfjM41yStBeF29FdmOx2vDhuh+uXGaqanxasRZRvoCiK9oMvXm4Py1VO3M00N6Pz2nf+XCmgTGSLVpNJmzV8maaAPn3xkZ9Bl+njD71xhy4VQ=
From: "Joonwoo Park" <joonwpark81@gmail.com>
To: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Cc: "'Kok, Auke'" <auke-jan.h.kok@intel.com>, <jesse.brandeburg@intel.com>,
       <jgarzik@pobox.com>
Subject: [PATCH 2/7] [NETDEV]: e1000e Fix possible causing oops of net_rx_action
Date: Wed, 12 Dec 2007 13:01:27 +0900
Message-ID: <002d01c83c73$b5807760$9c94fea9@jason>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3198
Thread-Index: Acg8c6SGlU+lPOg7ReCj9emStFF70g==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[NETDEV]: e1000e Fix possible causing oops of net_rx_action

Signed-off-by: Joonwoo Park <joonwpark81@gmail.com>
---
 drivers/net/e1000e/netdev.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/e1000e/netdev.c b/drivers/net/e1000e/netdev.c
index 4fd2e23..8e4861a 100644
--- a/drivers/net/e1000e/netdev.c
+++ b/drivers/net/e1000e/netdev.c
@@ -1412,6 +1412,8 @@ quit_polling:
 			e1000_set_itr(adapter);
 		netif_rx_complete(poll_dev, napi);
 		e1000_irq_enable(adapter);
+		if (unlikely(work_done == napi->weight))
+			return work_done - 1;
 	}
 
 	return work_done;
---

