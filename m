Return-Path: <linux-kernel-owner+w=401wt.eu-S1757667AbXEXKJg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757667AbXEXKJg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 06:09:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755242AbXEXKJ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 06:09:27 -0400
Received: from jurassic.park.msu.ru ([195.208.223.243]:2160 "EHLO
	jurassic.park.msu.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754478AbXEXKJ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 06:09:27 -0400
Date: Thu, 24 May 2007 14:09:41 +0400
From: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Wayne Sherman <wsherman@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: PCI device problem - MMCONFIG, cannot allocate resource region, resource collisions
Message-ID: <20070524140941.A21491@jurassic.park.msu.ru>
References: <46524A6D.5050601@gmail.com> <4654DA5E.2050003@gmail.com> <200705232008.23540.jbarnes@virtuousgeek.org> <200705232010.54184.jbarnes@virtuousgeek.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.2.5i
In-Reply-To: <200705232010.54184.jbarnes@virtuousgeek.org>; from jbarnes@virtuousgeek.org on Wed, May 23, 2007 at 08:10:54PM -0700
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 23, 2007 at 08:10:54PM -0700, Jesse Barnes wrote:
> > +/* Give unknown D-Link network adapters a proper class */
> > +static void __devinit quirk_dlink_unknown(struct pci_dev *dev)
> > +{
> > +	if (dev->class = PCI_CLASS_UNKNOWN)
> 
> Err, == of course.  Obviously I didn't test this. :)

Actually, it should be something like this (also untested).

Ivan.

--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -1690,6 +1690,14 @@ static void __devinit quirk_p64h2_1k_io(struct pci_dev 
*dev)
 }
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL,	0x1460,		quirk_p64h2_1k_io);
 
+/* Give unknown D-Link network adapters a proper class */
+static void __devinit quirk_dlink_unknown(struct pci_dev *dev)
+{
+	if ((dev->class >> 8) == PCI_CLASS_NOT_DEFINED)
+		dev->class = PCI_CLASS_NETWORK_ETHERNET << 8;
+}
+DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_DLINK, 0x4901, quirk_dlink_unknown);
+
 /* Fix the IOBL_ADR for 1k I/O space granularity on the Intel P64H2
  * The IOBL_ADR gets re-written to 4k boundaries in pci_setup_bridge()
  * in drivers/pci/setup-bus.c
