Return-Path: <linux-kernel-owner+w=401wt.eu-S935400AbXGTV3l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935400AbXGTV3l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 17:29:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755214AbXGTV3b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 17:29:31 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:60836 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751533AbXGTV3a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 17:29:30 -0400
Date: Fri, 20 Jul 2007 23:30:44 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: LKML <linux-kernel@vger.kernel.org>, David Miller <davem@davemloft.net>,
       sparc@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6/7] sparc64: fix section mismatch warning in pci_sunv4
Message-ID: <20070720213044.GE25064@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Fix following warning:
WARNING: vmlinux.o(.text+0x3cf50): Section mismatch: reference to .init.text:page_in_phys_avail (between 'pci_sun4v_pbm_init' and 'sun4v_pci_init')

pci_sun4v_pbm_init and sun4v_pci_init was only used under __init
context so declare them _init.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 arch/sparc64/kernel/pci_sun4v.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/sparc64/kernel/pci_sun4v.c b/arch/sparc64/kernel/pci_sun4v.c
index 6b3fe2c..639cf06 100644
--- a/arch/sparc64/kernel/pci_sun4v.c
+++ b/arch/sparc64/kernel/pci_sun4v.c
@@ -1129,7 +1129,7 @@ static void pci_sun4v_msi_init(struct pci_pbm_info *pbm)
 }
 #endif /* !(CONFIG_PCI_MSI) */
 
-static void pci_sun4v_pbm_init(struct pci_controller_info *p, struct device_node *dp, u32 devhandle)
+static void __init pci_sun4v_pbm_init(struct pci_controller_info *p, struct device_node *dp, u32 devhandle)
 {
 	struct pci_pbm_info *pbm;
 
@@ -1163,7 +1163,7 @@ static void pci_sun4v_pbm_init(struct pci_controller_info *p, struct device_node
 	pci_sun4v_msi_init(pbm);
 }
 
-void sun4v_pci_init(struct device_node *dp, char *model_name)
+void __init sun4v_pci_init(struct device_node *dp, char *model_name)
 {
 	static int hvapi_negotiated = 0;
 	struct pci_controller_info *p;
-- 
1.5.1.rc3.g84b7-dirty

