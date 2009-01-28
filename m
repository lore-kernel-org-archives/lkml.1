Return-Path: <linux-kernel-owner+w=401wt.eu-S1755226AbZA1L70@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755226AbZA1L70 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 06:59:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751885AbZA1L7Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 06:59:16 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:37228 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751692AbZA1L7P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 06:59:15 -0500
Message-ID: <49804882.2060000@jp.fujitsu.com>
Date: Wed, 28 Jan 2009 20:58:58 +0900
From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: linux-pci@vger.kernel.org, "Barnes, Jesse" <jesse.barnes@intel.com>
CC: James Bottomley <James.Bottomley@HansenPartnership.com>,
       Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>, shaohua.li@intel.com,
       Grant Grundler <grundler@parisc-linux.org>
Subject: [PATCH 7/8] PCI: fix wrong assumption in pci_get_interrupt_pin
References: <1231604250.3642.33.camel@localhost.localdomain>	 <alpine.LFD.2.00.0901121604380.5859@localhost.localdomain>	 <1231807693.27151.21.camel@localhost.localdomain>	 <1232046108.5966.57.camel@localhost.localdomain>	 <alpine.LFD.2.00.0901151421110.4737@localhost.localdomain>	 <1232049269.5966.64.camel@localhost.localdomain>	 <1232050347.5966.66.camel@localhost.localdomain>	 <4970242C.4010404@jp.fujitsu.com>	 <1232115546.3224.5.camel@localhost.localdomain>	 <4973D2EE.3060203@jp.fujitsu.com>	 <1232328216.3247.68.camel@localhost.localdomain>	 <4973EF64.2050404@jp.fujitsu.com> <1232558780.736.24.camel@localhost.localdomain> <497D1BD7.9000609@jp.fujitsu.com> <498045D1.60005@jp.fujitsu.com>
In-Reply-To: <498045D1.60005@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current pci_get_interrupt_pin() seems to have an assumption that
pci_bus->self is NULL on the root pci bus. But it might not be true on
some platforms. Because of this wrong assumption, current
pci_get_interrupt_pin() might cause endless loop. We must check
pci_bus->parent instead.

Signed-off-by: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>

---
 drivers/pci/pci.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.29-rc2/drivers/pci/pci.c
===================================================================
--- linux-2.6.29-rc2.orig/drivers/pci/pci.c
+++ linux-2.6.29-rc2/drivers/pci/pci.c
@@ -1433,7 +1433,7 @@ pci_get_interrupt_pin(struct pci_dev *de
 	if (!pin)
 		return -1;
 
-	while (dev->bus->self) {
+	while (dev->bus->parent) {
 		pin = pci_swizzle_interrupt_pin(dev, pin);
 		dev = dev->bus->self;
 	}


