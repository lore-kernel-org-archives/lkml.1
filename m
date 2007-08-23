Return-Path: <linux-kernel-owner+w=401wt.eu-S934381AbXHWWjj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934381AbXHWWjj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 18:39:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933189AbXHWW3e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 18:29:34 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:33251 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933171AbXHWW3d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 18:29:33 -0400
Date: Thu, 23 Aug 2007 15:27:44 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Tejun Heo <htejun@gmail.com>
Subject: [patch 24/28] PCI: disable MSI on RX790
Message-ID: <20070823222744.GX18559@kroah.com>
References: <20070823220656.101239233@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="pci-disable-msi-on-rx790.patch"
In-Reply-To: <20070823221811.GA18559@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Tejun Heo <htejun@gmail.com>

RX790 can't do MSI like its predecessors.  Disable MSI on RX790.

Signed-off-by: Tejun Heo <htejun@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/pci/quirks.c    |    1 +
 include/linux/pci_ids.h |    1 +
 2 files changed, 2 insertions(+)

--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -1641,6 +1641,7 @@ DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_SE
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ATI, PCI_DEVICE_ID_ATI_RS400_200, quirk_disable_all_msi);
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ATI, PCI_DEVICE_ID_ATI_RS480, quirk_disable_all_msi);
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ATI, PCI_DEVICE_ID_ATI_RD580, quirk_disable_all_msi);
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ATI, PCI_DEVICE_ID_ATI_RX790, quirk_disable_all_msi);
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ATI, PCI_DEVICE_ID_ATI_RS690, quirk_disable_all_msi);
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_VIA, PCI_DEVICE_ID_VIA_VT3351, quirk_disable_all_msi);
 
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -358,6 +358,7 @@
 #define PCI_DEVICE_ID_ATI_RS400_200     0x5a33
 #define PCI_DEVICE_ID_ATI_RS480         0x5950
 #define PCI_DEVICE_ID_ATI_RD580		0x5952
+#define PCI_DEVICE_ID_ATI_RX790		0x5957
 #define PCI_DEVICE_ID_ATI_RS690		0x7910
 /* ATI IXP Chipset */
 #define PCI_DEVICE_ID_ATI_IXP200_IDE	0x4349

-- 
