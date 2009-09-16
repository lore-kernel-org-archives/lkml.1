Return-Path: <linux-kernel-owner+w=401wt.eu-S1760382AbZIPWkq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760382AbZIPWkq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 18:40:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933665AbZIPWkk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 18:40:40 -0400
Received: from kroah.org ([198.145.64.141]:49004 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760400AbZIPWkJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 18:40:09 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Sep 16 15:37:17 2009
Message-Id: <20090916223717.514881842@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 16 Sep 2009 15:36:42 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Tejun Heo <tj@kernel.org>, Peer Chen <pchen@nvidia.com>,
       Tj <linux@tjworld.net>, Greg KH <greg@kroah.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [patch 29/45] PCI: apply nv_msi_ht_cap_quirk on resume too
References: <20090916223613.597295240@mini.kroah.org>
Content-Disposition: inline; filename=pci-apply-nv_msi_ht_cap_quirk-on-resume-too.patch
In-Reply-To: <20090916223739.GA4789@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Tejun Heo <tj@kernel.org>

commit 6dab62ee5a3bf4f71b8320c09db2e6022a19f40e upstream.

http://bugzilla.kernel.org/show_bug.cgi?id=12542 reports that with the
quirk not applied on resume, msi stops working after resuming and mcp78s
ahci fails due to IRQ mis-delivery.  Apply it on resume too.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Peer Chen <pchen@nvidia.com>
Cc: Tj <linux@tjworld.net>
Reported-by: Nicolas Derive <kalon33@ubuntu.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -2383,8 +2383,10 @@ static void __devinit nv_msi_ht_cap_quirk_leaf(struct pci_dev *dev)
 }
 
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_NVIDIA, PCI_ANY_ID, nv_msi_ht_cap_quirk_leaf);
+DECLARE_PCI_FIXUP_RESUME_EARLY(PCI_VENDOR_ID_NVIDIA, PCI_ANY_ID, nv_msi_ht_cap_quirk_leaf);
 
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_AL, PCI_ANY_ID, nv_msi_ht_cap_quirk_all);
+DECLARE_PCI_FIXUP_RESUME_EARLY(PCI_VENDOR_ID_AL, PCI_ANY_ID, nv_msi_ht_cap_quirk_all);
 
 static void __devinit quirk_msi_intx_disable_bug(struct pci_dev *dev)
 {


