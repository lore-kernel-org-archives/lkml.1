Return-Path: <linux-kernel-owner+w=401wt.eu-S1756329AbZBCRwd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756329AbZBCRwd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 12:52:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754975AbZBCRwW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 12:52:22 -0500
Received: from ns1.suse.de ([195.135.220.2]:53513 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753145AbZBCRwV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 12:52:21 -0500
Date: Tue, 3 Feb 2009 18:52:17 +0100
From: Karsten Keil <kkeil@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: [PATCH] e1000: Fix PCI enable to honor the need_ioport flag
Message-ID: <20090203175217.GA13712@pingi.kke.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: SuSE Linux AG
X-Operating-System: Linux 2.6.16.60-0.34-smp x86_64
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On machine were no IO ports are assigned the call
to pci_enable_device() will fail, even if need_ioport
is false, we need to use pci_enable_device_mem() here.

Signed-off-by: Karsten Keil <kkeil@suse.de>
---
 drivers/net/e1000/e1000_main.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/e1000/e1000_main.c b/drivers/net/e1000/e1000_main.c
index c986978..6bd63cc 100644
--- a/drivers/net/e1000/e1000_main.c
+++ b/drivers/net/e1000/e1000_main.c
@@ -940,7 +940,7 @@ static int __devinit e1000_probe(struct pci_dev *pdev,
 		err = pci_enable_device(pdev);
 	} else {
 		bars = pci_select_bars(pdev, IORESOURCE_MEM);
-		err = pci_enable_device(pdev);
+		err = pci_enable_device_mem(pdev);
 	}
 	if (err)
 		return err;
-- 
1.5.6.4


-- 
Karsten Keil
SuSE Labs
