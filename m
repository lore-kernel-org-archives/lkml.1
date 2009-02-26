Return-Path: <linux-kernel-owner+w=401wt.eu-S1754516AbZBZSs5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754516AbZBZSs5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 13:48:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752123AbZBZSss
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 13:48:48 -0500
Received: from kroah.org ([198.145.64.141]:37767 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752095AbZBZSsr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 13:48:47 -0500
Date: Thu, 26 Feb 2009 10:46:48 -0800
From: Greg KH <greg@kroah.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Stefan Assmann <sassmann@novell.com>,
       Jamie Wellnitz <Jamie.Wellnitz@emulex.com>, stable@kernel.org,
       linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] PCI: AMD 813x B2 devices do not need quirk
Message-ID: <20090226184648.GA5564@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefan Assmann <sassmann@novell.com>

Turns out that the new AMD 813x devices do not need the
quirk_disable_amd_813x_boot_interrupt quirk to be run on them, if it is,
no interrupts are seen on the PCI-X adapter.

From: Stefan Assmann <sassmann@novell.com>
Reported-by: Jamie Wellnitz <Jamie.Wellnitz@emulex.com>
Tested-by: Jamie Wellnitz <Jamie.Wellnitz@emulex.com>
Cc: stable <stable@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/pci/quirks.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -1554,6 +1554,7 @@ DECLARE_PCI_FIXUP_RESUME(PCI_VENDOR_ID_S
  */
 #define AMD_813X_MISC			0x40
 #define AMD_813X_NOIOAMODE		(1<<0)
+#define AMD_813X_REV_B2			0x13
 
 static void quirk_disable_amd_813x_boot_interrupt(struct pci_dev *dev)
 {
@@ -1561,6 +1562,8 @@ static void quirk_disable_amd_813x_boot_
 
 	if (noioapicquirk)
 		return;
+	if (dev->revision == AMD_813X_REV_B2)
+		return;
 
 	pci_read_config_dword(dev, AMD_813X_MISC, &pci_config_dword);
 	pci_config_dword &= ~AMD_813X_NOIOAMODE;
