Return-Path: <linux-kernel-owner+w=401wt.eu-S1752430AbXKNIOt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752430AbXKNIOt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 03:14:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751856AbXKNIOj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 03:14:39 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:47222 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751823AbXKNIOi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 03:14:38 -0500
Date: Wed, 14 Nov 2007 09:14:35 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: davem@davemloft.net, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 2/4] drivers/net: Drop unnecessary continue
Message-ID: <Pine.LNX.4.64.0711140914000.26019@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Continue is not needed at the bottom of a loop.

The semantic patch implementing this change is as follows:

@@
statement S;
@@

for (...;...;...) {
   ...
   if (...)
- {
     S
-   continue;
- }
}

Signed-off-by: Julia Lawall <julia@diku.dk>
---

diff -u -p -b -B a/drivers/net/ni65.c b/drivers/net/ni65.c
--- a/drivers/net/ni65.c 2007-10-22 11:25:14.000000000 +0200
+++ b/drivers/net/ni65.c 2007-11-13 22:49:02.000000000 +0100
@@ -427,10 +427,8 @@ static int __init ni65_probe1(struct net
  		}
  		if(cards[i].vendor_id) {
  			for(j=0;j<3;j++)
-				if(inb(ioaddr+cards[i].addr_offset+j) != cards[i].vendor_id[j]) {
+				if(inb(ioaddr+cards[i].addr_offset+j) != cards[i].vendor_id[j])
  					release_region(ioaddr, cards[i].total_size);
-					continue;
-			  }
  		}
  		break;
  	}
diff -u -p -b -B a/drivers/net/s2io.c b/drivers/net/s2io.c
--- a/drivers/net/s2io.c 2007-10-22 11:25:15.000000000 +0200
+++ b/drivers/net/s2io.c 2007-11-13 22:49:53.000000000 +0100
@@ -3599,10 +3599,8 @@ static void restore_xmsi_data(struct s2i
  		writeq(nic->msix_info[i].data, &bar0->xmsi_data);
  		val64 = (s2BIT(7) | s2BIT(15) | vBIT(i, 26, 6));
  		writeq(val64, &bar0->xmsi_access);
-		if (wait_for_msix_trans(nic, i)) {
+		if (wait_for_msix_trans(nic, i))
  			DBG_PRINT(ERR_DBG, "failed in %s\n", __FUNCTION__);
-			continue;
-		}
  	}
  }

