Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757964Ab0BMTol (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Feb 2010 14:44:41 -0500
Received: from stargate.chelsio.com ([67.207.112.58]:1687 "EHLO
	stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757945Ab0BMToi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Feb 2010 14:44:38 -0500
From: Divy Le Ray <divy@chelsio.com>
Subject: [PATCH net-next-2.6 2/2] cxgb3: fix link flap
To: davem@davemloft.net
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       swise@opengridcomputing.com
Date: Sat, 13 Feb 2010 11:44:35 -0800
Message-ID: <20100213194435.27297.79287.stgit@speedy5.asicdesigners.com>
In-Reply-To: <20100213194429.27297.99280.stgit@speedy5.asicdesigners.com>
References: <20100213194429.27297.99280.stgit@speedy5.asicdesigners.com>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Divy Le Ray <divy@chelsio.com>

The driver is expected to report that the link is up
when the phy Rx signal is established and the mac
has not detected a link fault.
The code is however broken, the driver does not check the link fault
status when the phy link status changes.
The link fault status being checked within a short period of time,
it leads to link up/link down events.

Signed-off-by: Divy Le Ray <divy@chelsio.com>
---

 drivers/net/cxgb3/t3_hw.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)


diff --git a/drivers/net/cxgb3/t3_hw.c b/drivers/net/cxgb3/t3_hw.c
index 032cfe0..3ab9f51 100644
--- a/drivers/net/cxgb3/t3_hw.c
+++ b/drivers/net/cxgb3/t3_hw.c
@@ -1262,7 +1262,8 @@ void t3_link_changed(struct adapter *adapter, int port_id)
 		lc->fc = fc;
 	}
 
-	t3_os_link_changed(adapter, port_id, link_ok, speed, duplex, fc);
+	t3_os_link_changed(adapter, port_id, link_ok && !pi->link_fault,
+			   speed, duplex, fc);
 }
 
 void t3_link_fault(struct adapter *adapter, int port_id)

