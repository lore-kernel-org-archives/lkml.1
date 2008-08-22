Return-Path: <linux-kernel-owner+w=401wt.eu-S1754401AbYHVSZp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754401AbYHVSZp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 14:25:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754538AbYHVSZR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 14:25:17 -0400
Received: from mail.gmx.net ([213.165.64.20]:57378 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752551AbYHVSZP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 14:25:15 -0400
X-Authenticated: #36809985
X-Provags-ID: V01U2FsdGVkX1/7RMQNvPj7SKYvFYuxVDntmlqOW+aZv4DvZ8Kys8
	Hip3qrPbE/IhH9
Subject: [PATCH] pci: Fix printk warnings in setup-bus.c
From: Johann Felix Soden <johfel@gmx.de>
Reply-To: Johann Felix Soden <johfel@users.sourceforge.net>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain
Date: Fri, 22 Aug 2008 20:25:10 +0200
Message-Id: <1219429510.7010.2.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Johann Felix Soden <johfel@users.sourceforge.net>

Fix printk format warnings:
drivers/pci/setup-bus.c: In function 'pci_bus_dump_res':
drivers/pci/setup-bus.c:542: warning: format '%llx' expects type 'long long unsigned int', but argument 5 has type 'resource_size_t'
drivers/pci/setup-bus.c:542: warning: format '%llx' expects type 'long long unsigned int', but argument 6 has type 'resource_size_t'

Signed-off-by: Johann Felix Soden <johfel@users.sourceforge.net>
---
 drivers/pci/setup-bus.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
index 82634a2..c6ea4e9 100644
--- a/drivers/pci/setup-bus.c
+++ b/drivers/pci/setup-bus.c
@@ -539,7 +539,11 @@ static void pci_bus_dump_res(struct pci_bus *bus)
                 if (!res)
                         continue;
 
-		printk(KERN_INFO "bus: %02x index %x %s: [%llx, %llx]\n", bus->number, i, (res->flags & IORESOURCE_IO)? "io port":"mmio", res->start, res->end);
+		printk(KERN_INFO "bus: %02x index %x %s: [%llx, %llx]\n",
+			bus->number, i,
+			(res->flags & IORESOURCE_IO) ? "io port" : "mmio",
+			(unsigned long long) res->start,
+			(unsigned long long) res->end);
         }
 }
 
-- 
1.5.6.3


