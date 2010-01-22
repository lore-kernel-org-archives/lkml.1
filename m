Return-Path: <linux-kernel-owner+w=401wt.eu-S1752727Ab0AVJDg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752727Ab0AVJDg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 04:03:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752726Ab0AVJD2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 04:03:28 -0500
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:45892 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752596Ab0AVJDK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 04:03:10 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Fri, 22 Jan 2010 01:02:28 -0800
From: Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 9/9] pci: set PCI_PREF_RANGE_TYPE_64 in pci_bridge_check_ranges
In-reply-to: <1264150948-9052-1-git-send-email-yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       Alex Chiang <achiang@hp.com>, Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       Yinghai Lu <yinghai@kernel.org>
Message-id: <1264150948-9052-10-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
References: <1264150948-9052-1-git-send-email-yinghai@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

make pci_bridge_check_ranges() to store the PCI_PREF_RANGE_TYPE_64 in addition
to IORESOURCE_MEM_64. just like pci_read_bridge_bases()

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 drivers/pci/setup-bus.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
index ed545f6..743ed8c 100644
--- a/drivers/pci/setup-bus.c
+++ b/drivers/pci/setup-bus.c
@@ -354,8 +354,11 @@ static void pci_bridge_check_ranges(struct pci_bus *bus)
 	}
 	if (pmem) {
 		b_res[2].flags |= IORESOURCE_MEM | IORESOURCE_PREFETCH;
-		if ((pmem & PCI_PREF_RANGE_TYPE_MASK) == PCI_PREF_RANGE_TYPE_64)
+		if ((pmem & PCI_PREF_RANGE_TYPE_MASK) ==
+		    PCI_PREF_RANGE_TYPE_64) {
 			b_res[2].flags |= IORESOURCE_MEM_64;
+			b_res[2].flags |= PCI_PREF_RANGE_TYPE_64;
+		}
 	}
 
 	/* double check if bridge does support 64 bit pref */
-- 
1.6.4.2

