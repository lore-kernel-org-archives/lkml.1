Return-Path: <linux-kernel-owner+w=401wt.eu-S1754274AbYFXFgT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754274AbYFXFgT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 01:36:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751549AbYFXFgK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 01:36:10 -0400
Received: from hera.kernel.org ([140.211.167.34]:53553 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751328AbYFXFgI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 01:36:08 -0400
Message-ID: <48608792.7090909@kernel.org>
Date: Tue, 24 Jun 2008 14:35:14 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       Greg KH <greg@kroah.com>, Andrew Morton <akpm@linux-foundation.org>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
       linux-pci@atrey.karlin.mff.cuni.cz
Subject: [PATCH] pci: VT3336 can't do MSI either
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0rc1 (hera.kernel.org [127.0.0.1]); Tue, 24 Jun 2008 05:35:23 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It seems VT3336 can't do msi either as with its bro 3351.  Disable it.
Reported in the following SUSE bug.

  https://bugzilla.novell.com/show_bug.cgi?id=300001

Signed-off-by: Tejun Heo <tj@kernel.org>
---
Anyone interested in queuing this for -rc8?  Thanks.

 drivers/pci/quirks.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index dabb563..9d95f0b 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -1685,6 +1685,7 @@ static void __init quirk_disable_all_msi(struct pci_dev *dev)
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_SERVERWORKS, PCI_DEVICE_ID_SERVERWORKS_GCNB_LE, quirk_disable_all_msi);
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ATI, PCI_DEVICE_ID_ATI_RS400_200, quirk_disable_all_msi);
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ATI, PCI_DEVICE_ID_ATI_RS480, quirk_disable_all_msi);
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_VIA, PCI_DEVICE_ID_VIA_VT3336, quirk_disable_all_msi);
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_VIA, PCI_DEVICE_ID_VIA_VT3351, quirk_disable_all_msi);
 
 /* Disable MSI on chipsets that are known to not support it */
