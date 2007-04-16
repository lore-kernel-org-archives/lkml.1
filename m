Return-Path: <linux-kernel-owner+w=401wt.eu-S1750961AbXDPE7Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750961AbXDPE7Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 00:59:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751059AbXDPE7Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 00:59:25 -0400
Received: from wr-out-0506.google.com ([64.233.184.225]:33075 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750909AbXDPE7Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 00:59:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=O3kc6irmJ6HweNLS+Ng5od4IPfxRL+mAYTm4rV6gPu6OoOIzXOsCpFeWJEn6Tp/OeazuR0Lsa95U3cOikoVy7W5tuDb7CEukXOrHVYFF0QpCtS6I80d/TeoaL50ZT2FqUYo/utle3gJU/rMdlJaukcxAiTlqOsG0B2jdaCpMsww=
Date: Mon, 16 Apr 2007 13:59:18 +0900
From: Tejun Heo <htejun@gmail.com>
To: gregkh@suse.de, Jeff Garzik <jeff@garzik.org>,
       linux-pci@atrey.karlin.mff.cuni.cz, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Cc: torresmat@gmail.com, conke.hu@gmail.com
Subject: [PATCH] pci-quirks: disable MSI on RS400-200 and RS480
Message-ID: <20070416045918.GI10619@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

MSI doesn't work on RS400-200 and RS480 requiring pci=nomsi kernel
boot parameter for ahci to work.  This patch disables MSI on those
chips.

  http://thread.gmane.org/gmane.linux.ide/17820
  http://thread.gmane.org/gmane.linux.ide/17516
  https://bugzilla.novell.com/show_bug.cgi?id=263893

Signed-off-by: Tejun Heo <htejun@gmail.com>

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 65d6f23..3300ff1 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -1761,6 +1761,8 @@ static void __devinit quirk_disable_msi(struct pci_dev *dev)
 	}
 }
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_8131_BRIDGE, quirk_disable_msi);
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ATI, PCI_DEVICE_ID_ATI_RS400_200, quirk_disable_msi);
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ATI, PCI_DEVICE_ID_ATI_RS480, quirk_disable_msi);
 
 /* Go through the list of Hypertransport capabilities and
  * return 1 if a HT MSI capability is found and enabled */
