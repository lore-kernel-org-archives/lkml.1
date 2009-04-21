Return-Path: <linux-kernel-owner+w=401wt.eu-S1757175AbZDUBgW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757175AbZDUBgW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 21:36:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753079AbZDUBgL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 21:36:11 -0400
Received: from hera.kernel.org ([140.211.167.34]:42679 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753024AbZDUBgK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 21:36:10 -0400
Message-ID: <49ED22EC.2040204@kernel.org>
Date: Mon, 20 Apr 2009 18:35:40 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org
Subject: [PATCH] x86/pci: do assign root bus res if _CRS is used
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


it wil be overwriten later if _CRS is used, so don't bother to set it.

[ Impact: cleanup ]

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/pci/amd_bus.c |    4 ++++
 1 file changed, 4 insertions(+)

Index: linux-2.6/arch/x86/pci/amd_bus.c
===================================================================
--- linux-2.6.orig/arch/x86/pci/amd_bus.c
+++ linux-2.6/arch/x86/pci/amd_bus.c
@@ -100,6 +100,10 @@ void x86_pci_root_bus_res_quirks(struct
 	int j;
 	struct pci_root_info *info;
 
+	/* don't go for it if _CRS is used */
+	if (pci_probe & PCI_USE__CRS)
+		return;
+
 	/* if only one root bus, don't need to anything */
 	if (pci_root_num < 2)
 		return;
