Return-Path: <linux-kernel-owner+w=401wt.eu-S1754247AbYKGS4w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754247AbYKGS4w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 13:56:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751286AbYKGS4l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 13:56:41 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:44138 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751091AbYKGS4k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 13:56:40 -0500
From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 2/5] i5k_amb: Load automatically on all 5000/5400 chipsets
To: "Darrick J. Wong" <djwong@us.ibm.com>, Jean Delvare <khali@linux-fr.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       lm-sensors <lm-sensors@lm-sensors.org>
Date: Fri, 07 Nov 2008 10:56:31 -0800
Message-ID: <20081107185631.13022.59600.stgit@elm3a70.beaverton.ibm.com>
In-Reply-To: <20081107185621.13022.61885.stgit@elm3a70.beaverton.ibm.com>
References: <20081107185621.13022.61885.stgit@elm3a70.beaverton.ibm.com>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


It turns out that we cannot create a pci_driver in this driver because PCI will
not call this module's probe function if the i5000-edac driver is already
loaded.  That said, we only want one value (AMBASE) from the PCI config space.
Neither driver alters this value, so it's safe to read it.  However, we still
want the module aliases, so provide that.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---

 drivers/hwmon/i5k_amb.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/hwmon/i5k_amb.c b/drivers/hwmon/i5k_amb.c
index 2ede938..a3fa639 100644
--- a/drivers/hwmon/i5k_amb.c
+++ b/drivers/hwmon/i5k_amb.c
@@ -490,6 +490,14 @@ static unsigned long chipset_ids[] = {
 	0
 };
 
+static struct pci_device_id i5k_amb_ids[] __devinitdata = {
+	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_5000_ERR) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_5400_ERR) },
+	{ 0, },
+};
+
+MODULE_DEVICE_TABLE(pci, i5k_amb_ids);
+
 static int __devinit i5k_amb_probe(struct platform_device *pdev)
 {
 	struct i5k_amb_data *data;

