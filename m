Return-Path: <linux-kernel-owner+w=401wt.eu-S1758035AbZGHFJU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758035AbZGHFJU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 01:09:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752264AbZGHFJK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 01:09:10 -0400
Received: from hera.kernel.org ([140.211.167.34]:56318 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751593AbZGHFJJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 01:09:09 -0400
Message-ID: <4A5429F1.6050503@kernel.org>
Date: Wed, 08 Jul 2009 14:09:05 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Linux Kernel <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>
CC: linux-pci@vger.kernel.org, stable@kernel.org
Subject: [PATCH] pci: apply nv_msi_ht_cap_quirk on resume too
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 08 Jul 2009 05:09:08 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

bko#12542 and lpd#334644 report that with the quirk not applied on
resume, msi stops working after resuming and mcp78s ahci fails due to
IRQ mis-delivery.  Apply it on resume too.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Peer Chen <pchen@nvidia.com>
Cc: Tj <linux@tjworld.net>
Reported-by: Nicolas Derive <kalon33@ubuntu.com>
---
 drivers/pci/quirks.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 06b9656..34a89b7 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -2382,8 +2382,10 @@ static void __devinit nv_msi_ht_cap_quirk_leaf(struct pci_dev *dev)
 }
 
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_NVIDIA, PCI_ANY_ID, nv_msi_ht_cap_quirk_leaf);
+DECLARE_PCI_FIXUP_RESUME_EARLY(PCI_VENDOR_ID_NVIDIA, PCI_ANY_ID, nv_msi_ht_cap_quirk_leaf);
 
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_AL, PCI_ANY_ID, nv_msi_ht_cap_quirk_all);
+DECLARE_PCI_FIXUP_RESUME_EARLY(PCI_VENDOR_ID_AL, PCI_ANY_ID, nv_msi_ht_cap_quirk_all);
 
 static void __devinit quirk_msi_intx_disable_bug(struct pci_dev *dev)
 {
