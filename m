Return-Path: <linux-kernel-owner+w=401wt.eu-S1753170AbZG1C57@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753170AbZG1C57 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 22:57:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752544AbZG1C57
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 22:57:59 -0400
Received: from hera.kernel.org ([140.211.167.34]:37183 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752138AbZG1C56 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 22:57:58 -0400
Message-ID: <4A6E69B9.5010101@kernel.org>
Date: Tue, 28 Jul 2009 12:00:09 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Linux Kernel <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>
CC: linux-pci@vger.kernel.org, stable@kernel.org
Subject: [PATCH] pci: apply nv_msi_ht_cap_quirk on resume too
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 28 Jul 2009 02:57:58 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

bko#12542[1] and lpd#334644[2] report that with the quirk not applied
on resume, msi stops working after resuming and mcp78s ahci fails due
to IRQ mis-delivery.  Apply it on resume too.

[1] http://bugzilla.kernel.org/show_bug.cgi?id=12542
[2] https://bugs.launchpad.net/ubuntu/+source/linux/+bug/334644

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Peer Chen <pchen@nvidia.com>
Cc: Tj <linux@tjworld.net>
Reported-by: Nicolas Derive <kalon33@ubuntu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
Full URLs added as pre Andrew's suggestion.

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

