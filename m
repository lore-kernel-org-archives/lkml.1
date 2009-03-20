Return-Path: <linux-kernel-owner+w=401wt.eu-S1760254AbZCTU5h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760254AbZCTU5h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 16:57:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758196AbZCTU4T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 16:56:19 -0400
Received: from g4t0016.houston.hp.com ([15.201.24.19]:30094 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758123AbZCTU4R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 16:56:17 -0400
From: Alex Chiang <achiang@hp.com>
Subject: [PATCH v5 05/13] PCI: do not initialize bridges more than once
To: jbarnes@virtuousgeek.org
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
       Alex Chiang <achiang@hp.com>
Date: Fri, 20 Mar 2009 14:56:15 -0600
Message-ID: <20090320205615.12275.97971.stgit@bob.kio>
In-Reply-To: <20090320204327.12275.43010.stgit@bob.kio>
References: <20090320204327.12275.43010.stgit@bob.kio>
User-Agent: StGIT/0.14.3.215.gff3d
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In preparation for PCI core hotplug, we need to ensure that we do
not attempt to re-initialize bridges that have already been initialized.

We only need to worry about non-root buses, since we will not allow
root bus removal.

Reported-by: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Signed-off-by: Alex Chiang <achiang@hp.com>
---

 drivers/pci/setup-bus.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
index 170a3ed..334285a 100644
--- a/drivers/pci/setup-bus.c
+++ b/drivers/pci/setup-bus.c
@@ -144,6 +144,9 @@ static void pci_setup_bridge(struct pci_bus *bus)
 	struct pci_bus_region region;
 	u32 l, bu, lu, io_upper16;
 
+	if (!pci_is_root_bus(bus) && bus->is_added)
+		return;
+
 	dev_info(&bridge->dev, "PCI bridge, secondary bus %04x:%02x\n",
 		 pci_domain_nr(bus), bus->number);
 

