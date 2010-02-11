Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756802Ab0BKSPV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 13:15:21 -0500
Received: from mx1.redhat.com ([209.132.183.28]:39708 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756359Ab0BKSPS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 13:15:18 -0500
From: Matthew Garrett <mjg@redhat.com>
To: e1000-devel@lists.sourceforge.net
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       Matthew Garrett <mjg@redhat.com>
Subject: [PATCH v3 1/2] e1000e: Only disable ASPM on 82573L devices
Date: Thu, 11 Feb 2010 13:14:53 -0500
Message-Id: <1265912094-4705-1-git-send-email-mjg@redhat.com>
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 66.187.234.200
X-SA-Exim-Mail-From: mjg@redhat.com
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 82537 errata and comment in e1000e_disable_l1aspm both agree that
only 82537L devices are affected. Limit the L1 disable to them.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
---
 drivers/net/e1000e/netdev.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/net/e1000e/netdev.c b/drivers/net/e1000e/netdev.c
index 57f149b..27eed81 100644
--- a/drivers/net/e1000e/netdev.c
+++ b/drivers/net/e1000e/netdev.c
@@ -4642,6 +4642,10 @@ static void e1000e_disable_l1aspm(struct pci_dev *pdev)
 	 * Unfortunately this feature saves about 1W power consumption when
 	 * active.
 	 */
+
+	if (pdev->device != E1000_DEV_ID_82573L)
+		return;
+
 	pos = pci_find_capability(pdev, PCI_CAP_ID_EXP);
 	pci_read_config_word(pdev, pos + PCI_EXP_LNKCTL, &val);
 	if (val & 0x2) {
-- 
1.6.6.1

