Return-Path: <linux-kernel-owner+w=401wt.eu-S1756164AbXE3RXy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756164AbXE3RXy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 13:23:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752663AbXE3RXq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 13:23:46 -0400
Received: from smtp2.it.da.ut.ee ([193.40.5.67]:55469 "EHLO smtp2.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751646AbXE3RXq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 13:23:46 -0400
Date: Wed, 30 May 2007 20:23:44 +0300 (EEST)
From: Meelis Roos <mroos@linux.ee>
To: Sam Ravnborg <sam@ravnborg.org>
cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
       Satyam Sharma <satyam.sharma@gmail.com>
Subject: Re: [PATCH] [ppc] fix mot_info section
In-Reply-To: <20070530170814.GD15335@uranus.ravnborg.org>
Message-ID: <Pine.SOC.4.64.0705302022060.23431@math>
References: <Pine.SOC.4.64.0705141717110.23895@math> <20070515204540.GC22966@uranus.ravnborg.org>
 <Pine.SOC.4.64.0705301652250.23769@math> <a781481a0705300758t5f16235al1f420f09472af780@mail.gmail.com>
 <Pine.SOC.4.64.0705301805390.23769@math> <20070530170814.GD15335@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for the suggestions, here is updated patch:

The following patch makes mot_info __initdata since it is used only in
__init functions. prep_pci.c change has been tested in real life on
Motorola Powerstack II (compiles without modpost warnings and boots
fine), pplus.c has not been tested but seems similar.

Signed-off-by: Meelis Roos <mroos@linux.ee>

diff --git a/arch/ppc/platforms/pplus.c b/arch/ppc/platforms/pplus.c
index 8a1788c..c569962 100644
--- a/arch/ppc/platforms/pplus.c
+++ b/arch/ppc/platforms/pplus.c
@@ -256,7 +256,7 @@ struct brd_info {
 	const char *name;
 	int (*map_irq) (struct pci_dev *, unsigned char, unsigned char);
 };
-struct brd_info mot_info[] = {
+struct brd_info mot_info[] __initdata = {
 	{0x300, 0x00, 0x00, "MVME 2400", Genesis2_map_irq},
 	{0x1E0, 0xE0, 0x00, "Mesquite cPCI (MCP750)", mesquite_map_irq},
 	{0x1E0, 0xE1, 0x00, "Sitka cPCI (MCPN750)", sitka_map_irq},
diff --git a/arch/ppc/platforms/prep_pci.c b/arch/ppc/platforms/prep_pci.c
index 1df3150..d8c4e28 100644
--- a/arch/ppc/platforms/prep_pci.c
+++ b/arch/ppc/platforms/prep_pci.c
@@ -803,7 +803,7 @@ struct mot_info {
 	void            (*map_non0_bus)(struct pci_dev *);      /* For boards with more than bus 0 devices. */
 	struct powerplus_irq_list *pci_irq_list; /* List of PCI MPIC inputs */
 	unsigned char   secondary_bridge_devfn; /* devfn of secondary bus transparent bridge */
-} mot_info[] = {
+} mot_info[] __initdata = {
 	{0x300, 0x00, 0x00, "MVME 2400",			Genesis2_pci_IRQ_map,	Raven_pci_IRQ_routes, Powerplus_Map_Non0, &Powerplus_pci_IRQ_list, 0xFF},
 	{0x010, 0x00, 0x00, "Genesis",				Genesis_pci_IRQ_map,	Genesis_pci_IRQ_routes, Powerplus_Map_Non0, &Powerplus_pci_IRQ_list, 0x00},
 	{0x020, 0x00, 0x00, "Powerstack (Series E)",		Comet_pci_IRQ_map,	Comet_pci_IRQ_routes, NULL, NULL, 0x00},

-- 
Meelis Roos (mroos@linux.ee)
