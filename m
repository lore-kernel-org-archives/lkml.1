Return-Path: <linux-kernel-owner+w=401wt.eu-S1755413AbZLVXDw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755413AbZLVXDw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 18:03:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755146AbZLVXDt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 18:03:49 -0500
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:56867 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754919AbZLVXDq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 18:03:46 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Tue, 22 Dec 2009 15:02:24 -0800
From: Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 04/14] pci: don't dump it when bus resource flags is not used
In-reply-to: <1261522954-12591-1-git-send-email-yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       Alex Chiang <achiang@hp.com>, Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       Yinghai Lu <yinghai@kernel.org>
Message-id: <1261522954-12591-5-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.0.2
References: <1261522954-12591-1-git-send-email-yinghai@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mean it is not used, so skip it.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 drivers/pci/setup-bus.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
index 7d6d393..e538fa1 100644
--- a/drivers/pci/setup-bus.c
+++ b/drivers/pci/setup-bus.c
@@ -703,7 +703,8 @@ static void pci_bus_dump_res(struct pci_bus *bus)
 
         for (i = 0; i < PCI_BUS_NUM_RESOURCES; i++) {
                 struct resource *res = bus->resource[i];
-                if (!res || !res->end)
+
+		if (!res || !res->end || !res->flags)
                         continue;
 
 		dev_printk(KERN_DEBUG, &bus->dev, "resource %d %pR\n", i, res);
-- 
1.6.0.2

