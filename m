Return-Path: <linux-kernel-owner+w=401wt.eu-S1755479AbYGBU1H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755479AbYGBU1H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 16:27:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754864AbYGBU0l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 16:26:41 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:33176 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754414AbYGBU0j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 16:26:39 -0400
Date: Wed, 2 Jul 2008 13:24:49 -0700
From: Greg Kroah-Hartman <gregkh@suse.de>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Kay Sievers <kay.sievers@vrfy.org>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, linux-pci@vger.kernel.org,
       davem@davemloft.net
Subject: [patch 02/04] PCI: handle pci_name() being const
Message-ID: <20080702202449.GB14024@kroah.com>
References: <20080702200902.909349505@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="pci-handle-pci_name-being-const.patch"
In-Reply-To: <20080702202200.GA14021@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This changes pci_setup_device to handle pci_name() now returning a
constant string.

Cc: Jesse Barns <jbarnes@virtuousgeek.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/pci/probe.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -711,8 +711,9 @@ static int pci_setup_device(struct pci_d
 {
 	u32 class;
 
-	sprintf(pci_name(dev), "%04x:%02x:%02x.%d", pci_domain_nr(dev->bus),
-		dev->bus->number, PCI_SLOT(dev->devfn), PCI_FUNC(dev->devfn));
+	dev_set_name(&dev->dev, "%04x:%02x:%02x.%d", pci_domain_nr(dev->bus),
+		     dev->bus->number, PCI_SLOT(dev->devfn),
+		     PCI_FUNC(dev->devfn));
 
 	pci_read_config_dword(dev, PCI_CLASS_REVISION, &class);
 	dev->revision = class & 0xff;

-- 
