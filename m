Return-Path: <linux-kernel-owner+w=401wt.eu-S1761506AbZEFUlt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761506AbZEFUlt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 16:41:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761126AbZEFUjI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 16:39:08 -0400
Received: from kroah.org ([198.145.64.141]:33919 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761115AbZEFUjG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 16:39:06 -0400
X-Mailbox-Line: From greg@blue.kroah.org Wed May  6 13:31:29 2009
Message-Id: <20090506203129.652108754@blue.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 06 May 2009 13:30:19 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Thomas Renninger <trenn@suse.de>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 09/18] PCI quirk: disable MSI on VIA VT3364 chipsets
References: <20090506203010.615363711@blue.kroah.org>
Content-Disposition: inline; filename=pci-quirk-disable-msi-on-via-vt3364-chipsets.patch
In-Reply-To: <20090506203353.GA14624@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Thomas Renninger <trenn@suse.de>

commit 162dedd39dcc6eca3fc0d29cf19658c6c13b840e upstream.

Without this patch, Broadcom BCM5906 Ethernet controllers set up via MSI
cause the machine to hang.  Tejun agreed that the best is to blacklist
the whole chipset and after adding it, seeing the other VIA quirks
disabling MSI, this very much looks like the right way.

Cc: <stable@kernel.org>
Signed-off-by: Thomas Renninger <trenn@suse.de>
Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/pci/quirks.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -1832,6 +1832,7 @@ DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_AT
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ATI, PCI_DEVICE_ID_ATI_RS480, quirk_disable_all_msi);
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_VIA, PCI_DEVICE_ID_VIA_VT3336, quirk_disable_all_msi);
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_VIA, PCI_DEVICE_ID_VIA_VT3351, quirk_disable_all_msi);
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_VIA, PCI_DEVICE_ID_VIA_VT3364, quirk_disable_all_msi);
 
 /* Disable MSI on chipsets that are known to not support it */
 static void __devinit quirk_disable_msi(struct pci_dev *dev)


