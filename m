Return-Path: <linux-kernel-owner+w=401wt.eu-S1757275AbZCWKnr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757275AbZCWKnr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 06:43:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757127AbZCWKnL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 06:43:11 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:34829 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757044AbZCWKnK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 06:43:10 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 2/2] arm: fix leak in iop13xx/pci
To: linux-kernel@vger.kernel.org, rmk@arm.linux.org.uk
Date: Mon, 23 Mar 2009 10:44:07 +0000
Message-ID: <20090323104359.32524.58254.stgit@localhost.localdomain>
In-Reply-To: <20090323103834.32524.65397.stgit@localhost.localdomain>
References: <20090323103834.32524.65397.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Another leak found by Daniel Marjamäki

Signed-off-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
---

 arch/arm/mach-iop13xx/pci.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)


diff --git a/arch/arm/mach-iop13xx/pci.c b/arch/arm/mach-iop13xx/pci.c
index 673b0db..4873f26 100644
--- a/arch/arm/mach-iop13xx/pci.c
+++ b/arch/arm/mach-iop13xx/pci.c
@@ -1026,8 +1026,10 @@ int iop13xx_pci_setup(int nr, struct pci_sys_data *sys)
 		which_atu = 0;
 	}
 
-	if (!which_atu)
+	if (!which_atu) {
+		kfree(res);
 		return 0;
+	}
 
 	switch(which_atu) {
 	case IOP13XX_INIT_ATU_ATUX:
@@ -1074,6 +1076,7 @@ int iop13xx_pci_setup(int nr, struct pci_sys_data *sys)
 		sys->map_irq = iop13xx_pcie_map_irq;
 		break;
 	default:
+		kfree(res);
 		return 0;
 	}
 

