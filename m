Return-Path: <linux-kernel-owner+w=401wt.eu-S1754811AbZCAI1T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754811AbZCAI1T (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Mar 2009 03:27:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752817AbZCAI1J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Mar 2009 03:27:09 -0500
Received: from mail-in-17.arcor-online.net ([151.189.21.57]:50455 "EHLO
	mail-in-17.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751045AbZCAI1G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Mar 2009 03:27:06 -0500
X-DKIM: Sendmail DKIM Filter v2.6.0 mail-in-16.arcor-online.net CFFBE257245
From: Prakash Punnoor <prakash@punnoor.de>
To: Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH] pci: don't enable too many HT MSI mapping
Date: Sun, 1 Mar 2009 09:29:17 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc6; KDE/4.2.0; x86_64; ; )
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Robert Hancock <hancockrwd@gmail.com>, david@lang.hm,
       Matthew Wilcox <matthew@wil.cx>,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org
References: <alpine.DEB.1.10.0902171419000.26625@asgard.lang.hm> <200903010858.05758.prakash@punnoor.de> <49AA4389.8010605@kernel.org>
In-Reply-To: <49AA4389.8010605@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903010929.17904.prakash@punnoor.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH] Enable HT MSI mapping on all known needed NVidia host bridges, V2

v3 of Yinghai Lu's work only enables HT MSI mapping for one specific host bridge.
Do this also for all C51 ones as specified by NVidia's original patch.

Signed-off-by: Prakash Punnoor <prakash@punnoor.de>

--- drivers/pci/quirks.c.current	2009-03-01 08:42:31.321660493 +0100
+++ drivers/pci/quirks.c	2009-03-01 09:27:13.061407474 +0100
@@ -2189,8 +2189,17 @@
 	return __nv_msi_ht_cap_quirk(dev, 0);
 }
 
-/* werid?, c51/mcp51 need c51 ht msi to be enable to make mcp51 ht msi working */
+/* Enable HT MSI mapping on C51 host brigdes */
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_NVIDIA, 0x02f0, nv_msi_ht_cap_quirk_all);
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_NVIDIA, 0x02f1, nv_msi_ht_cap_quirk_all);
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_NVIDIA, 0x02f2, nv_msi_ht_cap_quirk_all);
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_NVIDIA, 0x02f3, nv_msi_ht_cap_quirk_all);
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_NVIDIA, 0x02f4, nv_msi_ht_cap_quirk_all);
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_NVIDIA, 0x02f5, nv_msi_ht_cap_quirk_all);
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_NVIDIA, 0x02f6, nv_msi_ht_cap_quirk_all);
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_NVIDIA, 0x02f7, nv_msi_ht_cap_quirk_all);
+
+/* Enable HT MSI mapping on all regular devices */
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_NVIDIA, PCI_ANY_ID, nv_msi_ht_cap_quirk_leaf);
 
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_AL, PCI_ANY_ID, nv_msi_ht_cap_quirk_all);

