Return-Path: <linux-kernel-owner+w=401wt.eu-S932979AbZLRVAN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932979AbZLRVAN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 16:00:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932764AbZLRU7k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 15:59:40 -0500
Received: from hera.kernel.org ([140.211.167.34]:52639 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932758AbZLRU4K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 15:56:10 -0500
Message-ID: <4B2BEC28.9050801@kernel.org>
Date: Fri, 18 Dec 2009 12:55:04 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       Alex Chiang <achiang@hp.com>, Bjorn Helgaas <bjorn.helgaas@hp.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: [PATCH 3/12] pci: don't dump it when bus resource flags is not used
References: <4B2BE9DD.3040504@kernel.org>
In-Reply-To: <4B2BE9DD.3040504@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


mean it is not used, so skip it.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 drivers/pci/setup-bus.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: linux-2.6/drivers/pci/setup-bus.c
===================================================================
--- linux-2.6.orig/drivers/pci/setup-bus.c
+++ linux-2.6/drivers/pci/setup-bus.c
@@ -725,7 +725,8 @@ static void pci_bus_dump_res(struct pci_
 
         for (i = 0; i < PCI_BUS_NUM_RESOURCES; i++) {
                 struct resource *res = bus->resource[i];
-                if (!res || !res->end)
+
+		if (!res || !res->end || !res->flags)
                         continue;
 
 		dev_printk(KERN_DEBUG, &bus->dev, "resource %d %pR\n", i, res);


