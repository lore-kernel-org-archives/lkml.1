Return-Path: <linux-kernel-owner+w=401wt.eu-S1758795AbZFPWQY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758795AbZFPWQY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 18:16:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754442AbZFPWQR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 18:16:17 -0400
Received: from Cpsmtpm-eml106.kpnxchange.com ([195.121.3.10]:55373 "EHLO
	CPSMTPM-EML106.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754146AbZFPWQQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 18:16:16 -0400
From: Frans Pop <elendil@planet.nl>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [PATCH] IDE: consistently use type bool for wake enable variable
Date: Wed, 17 Jun 2009 00:16:15 +0200
User-Agent: KMail/1.9.9
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20090616142554.7bce02f6@jbarnes-g45>
In-reply-To: <20090616142554.7bce02f6@jbarnes-g45>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906170016.16716.elendil@planet.nl>
X-OriginalArrivalTime: 16 Jun 2009 22:16:17.0260 (UTC) FILETIME=[1198BAC0:01C9EED0]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

IDE: consistently use type bool for wake enable parameter

Other functions use type bool, so use that for pci_enable_wake as well.

Signed-off-by: Frans Pop <elendil@planet.nl>
---

Hi Jesse,

I've had this trivial patch sitting in my local branch for some time.
Please consider including.

Cheers,
FJP

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 1a91bf9..602052e 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -1203,7 +1203,7 @@ void pci_pme_active(struct pci_dev *dev, bool enable)
  * Error code depending on the platform is returned if both the platform and
  * the native mechanism fail to enable the generation of wake-up events
  */
-int pci_enable_wake(struct pci_dev *dev, pci_power_t state, int enable)
+int pci_enable_wake(struct pci_dev *dev, pci_power_t state, bool enable)
 {
 	int error = 0;
 	bool pme_done = false;
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 37f3430..6f6bc19 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -724,7 +724,7 @@ int pci_set_power_state(struct pci_dev *dev, pci_power_t state);
 pci_power_t pci_choose_state(struct pci_dev *dev, pm_message_t state);
 bool pci_pme_capable(struct pci_dev *dev, pci_power_t state);
 void pci_pme_active(struct pci_dev *dev, bool enable);
-int pci_enable_wake(struct pci_dev *dev, pci_power_t state, int enable);
+int pci_enable_wake(struct pci_dev *dev, pci_power_t state, bool enable);
 int pci_wake_from_d3(struct pci_dev *dev, bool enable);
 pci_power_t pci_target_state(struct pci_dev *dev);
 int pci_prepare_to_sleep(struct pci_dev *dev);
