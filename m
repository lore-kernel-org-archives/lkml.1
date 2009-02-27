Return-Path: <linux-kernel-owner+w=401wt.eu-S1755939AbZB0EWx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755939AbZB0EWx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 23:22:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754138AbZB0EWl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 23:22:41 -0500
Received: from rcsinet12.oracle.com ([148.87.113.124]:23207 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753618AbZB0EWk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 23:22:40 -0500
Message-ID: <49A76A6B.7020709@oracle.com>
Date: Thu, 26 Feb 2009 20:22:03 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081112)
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       netdev@vger.kernel.org, David Miller <davem@davemloft.net>,
       Stephen Hemminger <shemminger@vyatta.com>,
       akpm <akpm@linux-foundation.org>
Subject: [PATCH] net: fix hp-plus build error
References: <20090224212949.0dacb59f.sfr@canb.auug.org.au> <49A4248F.6090202@oracle.com>
In-Reply-To: <49A4248F.6090202@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt700.oracle.com [141.146.40.70]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.49A76A7B.001A:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

hp-plus needs to call __alloc_eip_netdev() instead of
__alloc_ei_netdev() since it is linked with 8390p.o.

Fixes this build error:
ERROR: "__alloc_ei_netdev" [drivers/net/hp-plus.ko] undefined!

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/net/hp-plus.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- mmotm-2009-0226-1658.orig/drivers/net/hp-plus.c
+++ mmotm-2009-0226-1658/drivers/net/hp-plus.c
@@ -467,7 +467,7 @@ init_module(void)
 			if (this_dev != 0) break; /* only autoprobe 1st one */
 			printk(KERN_NOTICE "hp-plus.c: Presently autoprobing (not recommended) for a single card.\n");
 		}
-		dev = alloc_ei_netdev();
+		dev = alloc_eip_netdev();
 		if (!dev)
 			break;
 		dev->irq = irq[this_dev];
