Return-Path: <linux-kernel-owner+w=401wt.eu-S1754484AbZGASF1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754484AbZGASF1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 14:05:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753309AbZGASFU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 14:05:20 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:64945 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751791AbZGASFU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 14:05:20 -0400
X-IronPort-AV: E=Sophos;i="4.42,326,1243814400"; 
   d="scan'208";a="335641919"
From: Roland Dreier <rdreier@cisco.com>
To: dan.j.williams@intel.com, maciej.sosnowski@intel.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] Add MODULE_DEVICE_TABLE() so ioatdma module is autoloaded
X-Message-Flag: Warning: May contain useful information
Date: Wed, 01 Jul 2009 11:05:19 -0700
Message-ID: <adar5x0ffds.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 01 Jul 2009 18:05:19.0897 (UTC) FILETIME=[7EE7B890:01C9FA76]
Authentication-Results: sj-dkim-2; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim2002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ioatdma module is missing aliases for the PCI devices it supports,
so it is not autoloaded on boot.  Add a MODULE_DEVICE_TABLE() to get
these aliases.

Signed-off-by: Roland Dreier <rolandd@cisco.com>
---
Not sure if not autoloading was intentional or if it's just an
oversight, but this patch seems useful to me, so please apply if it
makes sense to you.

 drivers/dma/ioat.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/dma/ioat.c b/drivers/dma/ioat.c
index 2225bb6..a1d8b8d 100644
--- a/drivers/dma/ioat.c
+++ b/drivers/dma/ioat.c
@@ -60,6 +60,8 @@ static struct pci_device_id ioat_pci_tbl[] = {
 	{ 0, }
 };
 
+MODULE_DEVICE_TABLE(pci, ioat_pci_tbl);
+
 struct ioat_device {
 	struct pci_dev		*pdev;
 	void __iomem		*iobase;
