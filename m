Return-Path: <linux-kernel-owner+w=401wt.eu-S1753766Ab0AVNur@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753766Ab0AVNur (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 08:50:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752009Ab0AVNuq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 08:50:46 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:57501 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750828Ab0AVNuq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 08:50:46 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Fri, 22 Jan 2010 14:48:56 +0100
From: Michal Nazarewicz <m.nazarewicz@samsung.com>
Subject: [PATCH] USB: g_config: fix CONFIG_USB_G_MULTI_RNDIS usage
In-reply-to: <1259574940-25345-1-git-send-email-m.nazarewicz@samsung.com>
To: Randy Dunlap <randy.dunlap@oracle.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, Greg KH <greg@kroah.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, Greg KH <greg@kroah.com>
Cc: Michal Nazarewicz <m.nazarewicz@samsung.com>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Marek Szyprowski <m.szyprowski@samsung.com>,
       Kyungmin Park <kyungmin.park@samsung.com>
Message-id: <1264168136-8457-1-git-send-email-m.nazarewicz@samsung.com>
X-Mailer: git-send-email 1.6.5
References: <1259574940-25345-1-git-send-email-m.nazarewicz@samsung.com>
 <20091128103429.705670b2.randy.dunlap@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

g_multi used CONFIG_USB_ETH_RNDIS to check if RNDIS option was requested
where it should check for CONFIG_USB_G_MULTI_RNDIS.  As a result, RNDIS
was never present in g_multi regardless of configuration.

This fixes changes made in commit 396cda90d228d0851f3d64c7c85a1ecf6b8ae1e8.

Signed-off-by: Michal Nazarewicz <m.nazarewicz@samsung.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
---
 drivers/usb/gadget/multi.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/gadget/multi.c b/drivers/usb/gadget/multi.c
index 4295601..76496f5 100644
--- a/drivers/usb/gadget/multi.c
+++ b/drivers/usb/gadget/multi.c
@@ -29,7 +29,7 @@
 #if defined USB_ETH_RNDIS
 #  undef USB_ETH_RNDIS
 #endif
-#ifdef CONFIG_USB_ETH_RNDIS
+#ifdef CONFIG_USB_G_MULTI_RNDIS
 #  define USB_ETH_RNDIS y
 #endif
 
-- 
1.6.5

