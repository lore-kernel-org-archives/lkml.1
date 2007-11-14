Return-Path: <linux-kernel-owner+w=401wt.eu-S1754103AbXKNIPe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754103AbXKNIPe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 03:15:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751787AbXKNIPV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 03:15:21 -0500
Received: from mgw1.diku.dk ([130.225.96.91]:53912 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751555AbXKNIPU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 03:15:20 -0500
Date: Wed, 14 Nov 2007 09:15:16 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: gregkh@suse.de, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 3/4] drivers/usb: Drop unnecessary continue
Message-ID: <Pine.LNX.4.64.0711140914360.26019@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Continue is not needed at the bottom of a loop.

The semantic patch implementing this change is as follows:

@@
@@

for (...;...;...) {
   ...
   if (...) {
     ...
-   continue;
   }
}

Signed-off-by: Julia Lawall <julia@diku.dk>
---

diff -u -p -b -B a/drivers/usb/host/isp116x-hcd.c b/drivers/usb/host/isp116x-hcd.c
--- a/drivers/usb/host/isp116x-hcd.c 2007-10-22 11:25:24.000000000 +0200
+++ b/drivers/usb/host/isp116x-hcd.c 2007-11-13 23:14:10.000000000 +0100
@@ -918,7 +918,6 @@ static int isp116x_hub_status_data(struc
  			      | RH_PS_OCIC | RH_PS_PRSC)) {
  			changed = 1;
  			buf[0] |= 1 << (i + 1);
-			continue;
  		}
  	}
  	spin_unlock_irqrestore(&isp116x->lock, flags);
diff -u -p -b -B a/drivers/usb/image/mdc800.c b/drivers/usb/image/mdc800.c
--- a/drivers/usb/image/mdc800.c 2007-07-23 11:27:17.000000000 +0200
+++ b/drivers/usb/image/mdc800.c 2007-11-13 23:14:33.000000000 +0100
@@ -479,7 +479,6 @@ static int mdc800_usb_probe (struct usb_
  					irq_interval=intf_desc->endpoint [j].desc.bInterval;
  				}

-				continue;
  			}
  		}
  		if (mdc800->endpoint[i] == -1)
