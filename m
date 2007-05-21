Return-Path: <linux-kernel-owner+w=401wt.eu-S935962AbXEUT41@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935962AbXEUT41 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 15:56:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934163AbXEUTaB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 15:30:01 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:52711 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934162AbXEUT37 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 15:29:59 -0400
Message-Id: <20070521191722.373844000@sous-sol.org>
References: <20070521191612.800400000@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Mon, 21 May 2007 12:16:38 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, "Michael Chan" <mchan@broadcom.com>,
       David S Miller <davem@davemloft.net>
Subject: [patch 26/69] BNX2: Save PCI state during suspend.
Content-Disposition: inline; filename=bnx2-save-pci-state-during-suspend.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From:  <mchan@broadcom.com>

This is needed to save the MSI state which will be lost during
suspend.

Signed-off-by: Michael Chan <mchan@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---

---
 drivers/net/bnx2.c |    2 ++
 1 file changed, 2 insertions(+)

--- linux-2.6.21.1.orig/drivers/net/bnx2.c
+++ linux-2.6.21.1/drivers/net/bnx2.c
@@ -6148,6 +6148,7 @@ bnx2_suspend(struct pci_dev *pdev, pm_me
 		reset_code = BNX2_DRV_MSG_CODE_SUSPEND_NO_WOL;
 	bnx2_reset_chip(bp, reset_code);
 	bnx2_free_skbs(bp);
+	pci_save_state(pdev);
 	bnx2_set_power_state(bp, pci_choose_state(pdev, state));
 	return 0;
 }
@@ -6161,6 +6162,7 @@ bnx2_resume(struct pci_dev *pdev)
 	if (!netif_running(dev))
 		return 0;
 
+	pci_restore_state(pdev);
 	bnx2_set_power_state(bp, PCI_D0);
 	netif_device_attach(dev);
 	bnx2_init_nic(bp);

-- 
