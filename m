Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755665Ab0APLJc (ORCPT <rfc822;list-kernel77@spinics.net>);
	Sat, 16 Jan 2010 06:09:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755533Ab0APLJA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jan 2010 06:09:00 -0500
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:63414 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755410Ab0APLI5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jan 2010 06:08:57 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Sat, 16 Jan 2010 03:07:17 -0800
From: Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 11/11] pci: set PCI_PREF_RANGE_TYPE_64 in
 pci_bridge_check_ranges
In-reply-to: <1263640037-24134-1-git-send-email-yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>, Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Alex Chiang <achiang@hp.com>, Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Message-id: <1263640037-24134-12-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
References: <1263640037-24134-1-git-send-email-yinghai@kernel.org>
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
index 61f128b..5b3fe2c 100644
--- a/drivers/pci/setup-bus.c
+++ b/drivers/pci/setup-bus.c
@@ -359,8 +359,11 @@ static void pci_bridge_check_ranges(struct pci_bus *bus)
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

