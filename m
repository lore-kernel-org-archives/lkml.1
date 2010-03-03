Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758270Ab0CCABQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 19:01:16 -0500
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:42220 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752101Ab0CCABL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 19:01:11 -0500
From: imunsie@au1.ibm.com
To: linux-kernel@vger.kernel.org
Cc: Ian Munsie <imunsie@au1.ibm.com>, Karsten Keil <isdn@linux-pingi.de>,
       "David S. Miller" <davem@davemloft.net>,
       Andreas Eversberg <andreas@eversberg.eu>, Andreas Mohr <andi@lisas.de>
Subject: [PATCH] Explicitly ignore unused return value of _hfcpci_softirq
Date: Wed,  3 Mar 2010 11:00:53 +1100
Message-Id: <1267574453-7228-1-git-send-email-imunsie@au.ibm.com>
X-Mailer: git-send-email 1.6.6.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ian Munsie <imunsie@au.ibm.com>

The compiler throws the following warning during compilation:

drivers/isdn/hardware/mISDN/hfcpci.c:2319: warning: ignoring return value of 'driver_for_each_device', declared with attribute warn_unused_result

driver_for_each_device is being used to call _hfcpci_softirq for each
device, which will only ever return 0.
This patch explicitly ignores the return value to silence the warning.

Signed-off-by: Ian Munsie <imunsie@au.ibm.com>
---
 drivers/isdn/hardware/mISDN/hfcpci.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/isdn/hardware/mISDN/hfcpci.c b/drivers/isdn/hardware/mISDN/hfcpci.c
index 70e6b0e..1333d4a 100644
--- a/drivers/isdn/hardware/mISDN/hfcpci.c
+++ b/drivers/isdn/hardware/mISDN/hfcpci.c
@@ -2316,7 +2316,8 @@ _hfcpci_softirq(struct device *dev, void *arg)
 static void
 hfcpci_softirq(void *arg)
 {
-	(void) driver_for_each_device(&hfc_driver.driver, NULL, arg,
+	int err;
+	err = driver_for_each_device(&hfc_driver.driver, NULL, arg,
 					_hfcpci_softirq);
 
 	/* if next event would be in the past ... */
-- 
1.6.6.1

