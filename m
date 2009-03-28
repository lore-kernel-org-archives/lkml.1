Return-Path: <linux-kernel-owner+w=401wt.eu-S1753548AbZC2IwV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753548AbZC2IwV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 04:52:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755260AbZC2Ivw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 04:51:52 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:40089 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754807AbZC2Ivv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 04:51:51 -0400
References: <git-1238272225-ecbf61e7357d5c7047c813edd6983902d158688c@dyn-67.arm.linux.org.uk>
Message-ID: <git-1238272225-b23c7a427e4b3764ad686a46de89ab652811c50a@dyn-67.arm.linux.org.uk>
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: stable@kernel.org,
       Linux Kernel Mailing list <linux-kernel@vger.kernel.org>
Date: Sat, 28 Mar 2009 20:30:26 +0000
Content-type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Subject: Re: [PATCH] [ARM] fix leak in iop13xx/pci
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Another leak found by Daniel Marjamäki

Signed-off-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
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
 
