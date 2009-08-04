Return-Path: <linux-kernel-owner+w=401wt.eu-S932921AbZHDP6E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932921AbZHDP6E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 11:58:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755271AbZHDP6D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 11:58:03 -0400
Received: from hera.kernel.org ([140.211.167.34]:51577 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751966AbZHDP6C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 11:58:02 -0400
Message-ID: <4A785A57.8050505@kernel.org>
Date: Tue, 04 Aug 2009 08:57:11 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Suresh Siddha <suresh.b.siddha@intel.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org, Yu Zhao <yu.zhao@intel.com>
Subject: [PATCH] pci: dmar/intr_remapping/iov use physfn to search drhd
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


when virtfn is used, we should use physfn to find correct drhd

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 drivers/pci/dmar.c           |    5 +++++
 2 files changed, 12 insertions(+), 1 deletion(-)

Index: linux-2.6/drivers/pci/dmar.c
===================================================================
--- linux-2.6.orig/drivers/pci/dmar.c
+++ linux-2.6/drivers/pci/dmar.c
@@ -493,6 +493,11 @@ dmar_find_matched_drhd_unit(struct pci_d
 	struct dmar_drhd_unit *dmaru = NULL;
 	struct acpi_dmar_hardware_unit *drhd;
 
+#ifdef CONFIG_PCI_IOV
+	if (dev->is_virtfn)
+		dev = dev->physfn;
+#endif
+
 	list_for_each_entry(dmaru, &dmar_drhd_units, list) {
 		drhd = container_of(dmaru->hdr,
 				    struct acpi_dmar_hardware_unit,
