Return-Path: <linux-kernel-owner+w=401wt.eu-S1754131AbZBREkw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754131AbZBREkw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 23:40:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752797AbZBREkm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 23:40:42 -0500
Received: from hera.kernel.org ([140.211.167.34]:34692 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751394AbZBREkl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 23:40:41 -0500
Message-ID: <499B9129.50104@kernel.org>
Date: Tue, 17 Feb 2009 20:40:09 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Andrew Morton <akpm@linux-foundation.org>
CC: david@lang.hm, Matthew Wilcox <matthew@wil.cx>,
       linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org,
       DL-MPTFusionLinux@lsi.com, linux-pci@vger.kernel.org
Subject: [PATCH] pci: enable MSI on 8132
References: <alpine.DEB.1.10.0902171419000.26625@asgard.lang.hm>  <alpine.DEB.1.10.0902171343280.26625@asgard.lang.hm>  <20090217230050.GG16841@parisc-linux.org>  <alpine.DEB.1.10.0902171506500.26625@asgard.lang.hm> <86802c440902171511s1abcc0eao560df4b8fcea0e7c@mail.gmail.com> <alpine.DEB.1.10.0902171514120.26625@asgard.lang.hm> <499B46B2.5040601@kernel.org> <alpine.DEB.1.10.0902171537260.26625@asgard.lang.hm> <499B6BF7.9090300@kernel.org> <alpine.DEB.1.10.0902171803040.26625@asgard.lang.hm> <499B724A.2040408@kernel.org> <alpine.DEB.1.10.0902171832560.26625@asgard.lang.hm> <alpine.DEB.1.10.0902171839420.26625@asgard.lang.hm> <499B774C.5010705@kernel.org> <alpine.DEB.1.10.0902171917420.26625@asgard.lang.hm>
In-Reply-To: <alpine.DEB.1.10.0902171917420.26625@asgard.lang.hm>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Impact: workaround BIOS that doesn't enable that bit

David reported that LSI sas doesn't work with MSI.
it turns out that BIOS doesn't enable HT MSI
8132 does support HT MSI.
add quirk to enable it

Reported-by: David Lang <david@lang.hm>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 drivers/pci/quirks.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

Index: linux-2.6/drivers/pci/quirks.c
===================================================================
--- linux-2.6.orig/drivers/pci/quirks.c
+++ linux-2.6/drivers/pci/quirks.c
@@ -1981,7 +1981,6 @@ static void __devinit quirk_msi_ht_cap(s
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_SERVERWORKS, PCI_DEVICE_ID_SERVERWORKS_HT2000_PCIE,
 			quirk_msi_ht_cap);
 
-
 /* The nVidia CK804 chipset may have 2 HT MSI mappings.
  * MSI are supported if the MSI capability set in any of these mappings.
  */
@@ -2032,6 +2031,9 @@ DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_S
 			 PCI_DEVICE_ID_SERVERWORKS_HT1000_PXB,
 			 ht_enable_msi_mapping);
 
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_8132_BRIDGE,
+			 ht_enable_msi_mapping);
+
 /* The P5N32-SLI Premium motherboard from Asus has a problem with msi
  * for the MCP55 NIC. It is not yet determined whether the msi problem
  * also affects other devices. As for now, turn off msi for this device.

