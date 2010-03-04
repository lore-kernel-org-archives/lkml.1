Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755775Ab0CDEQb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 23:16:31 -0500
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:36988 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755283Ab0CDEQa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 23:16:30 -0500
From: "Ian Munsie" <imunsie@au1.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Dan Carpenter <error27@gmail.com>, Ian Munsie <imunsie@au1.ibm.com>
Subject: [PATCH v2] mISDN: Explicitly ignore unused return value of _hfcpci_softirq
Date: Thu,  4 Mar 2010 15:16:08 +1100
Message-Id: <1267676168-1358-1-git-send-email-imunsie@au.ibm.com>
X-Mailer: git-send-email 1.7.0
In-Reply-To: <20100303083128.GA17283@bicker>
References: <20100303083128.GA17283@bicker>
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

Changes since v1: Changed name of dummy variable to hold unused return value from 'err' to 'dummy' as per Dan Carpenter's feedback.

 drivers/isdn/hardware/mISDN/hfcpci.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/isdn/hardware/mISDN/hfcpci.c b/drivers/isdn/hardware/mISDN/hfcpci.c
index 70e6b0e..ae50e5a 100644
--- a/drivers/isdn/hardware/mISDN/hfcpci.c
+++ b/drivers/isdn/hardware/mISDN/hfcpci.c
@@ -2316,7 +2316,8 @@ _hfcpci_softirq(struct device *dev, void *arg)
 static void
 hfcpci_softirq(void *arg)
 {
-	(void) driver_for_each_device(&hfc_driver.driver, NULL, arg,
+	int dummy;
+	dummy = driver_for_each_device(&hfc_driver.driver, NULL, arg,
 					_hfcpci_softirq);
 
 	/* if next event would be in the past ... */
-- 
1.7.0

