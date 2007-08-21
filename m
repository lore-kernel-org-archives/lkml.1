Return-Path: <linux-kernel-owner+w=401wt.eu-S1756919AbXHUFdT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756919AbXHUFdT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 01:33:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751996AbXHUFdK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 01:33:10 -0400
Received: from rv-out-0910.google.com ([209.85.198.187]:48891 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751821AbXHUFdJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 01:33:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=rsOutNUk2oevee1C0oiQxQz5CxXxzo+tr64eUWCXeaTQacPGHRwSXNZpaKf/8nAyYxVhCt3wVokIY4UL8I7Lp75qHeik9VI+E2qAhk7Pgg+XSjx4Rr9yMhbR3iMMtPHE8j+x8Lzbs/JeinggVc6b7dpqXptVKkcDFJFd8lvLbsw=
Date: Tue, 21 Aug 2007 14:33:01 +0900
From: Tejun Heo <htejun@gmail.com>
To: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz
Subject: [PATCH] PCI: disable MSI on RX790
Message-ID: <20070821053301.GC2909@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

RX790 can't do MSI like its predecessors.  Disable MSI on RX790.

Signed-off-by: Tejun Heo <htejun@gmail.com>
---
Okay, another one from ATI which can't do MSI.  2.6.23 material.

 drivers/pci/quirks.c    |    1 +
 include/linux/pci_ids.h |    1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 67e375d..d8a2e44 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -1651,6 +1651,7 @@ DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_SERVERWORKS, PCI_DEVICE_ID_SERVERWORKS_HT1
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ATI, PCI_DEVICE_ID_ATI_RS400_200, quirk_disable_all_msi);
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ATI, PCI_DEVICE_ID_ATI_RS480, quirk_disable_all_msi);
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ATI, PCI_DEVICE_ID_ATI_RD580, quirk_disable_all_msi);
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ATI, PCI_DEVICE_ID_ATI_RX790, quirk_disable_all_msi);
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ATI, PCI_DEVICE_ID_ATI_RS690, quirk_disable_all_msi);
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_VIA, PCI_DEVICE_ID_VIA_VT3351, quirk_disable_all_msi);
 
diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index dc79fea..5acfeb7 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -361,6 +361,7 @@
 #define PCI_DEVICE_ID_ATI_RS400_200     0x5a33
 #define PCI_DEVICE_ID_ATI_RS480         0x5950
 #define PCI_DEVICE_ID_ATI_RD580		0x5952
+#define PCI_DEVICE_ID_ATI_RX790		0x5957
 #define PCI_DEVICE_ID_ATI_RS690		0x7910
 /* ATI IXP Chipset */
 #define PCI_DEVICE_ID_ATI_IXP200_IDE	0x4349

