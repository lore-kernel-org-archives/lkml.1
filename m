Return-Path: <linux-kernel-owner+w=401wt.eu-S1757433AbXE3QO6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757433AbXE3QO6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 12:14:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752767AbXE3QOv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 12:14:51 -0400
Received: from smtp2.it.da.ut.ee ([193.40.5.67]:56735 "EHLO smtp2.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752736AbXE3QOv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 12:14:51 -0400
Date: Wed, 30 May 2007 19:14:49 +0300 (EEST)
From: Meelis Roos <mroos@linux.ee>
cc: Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: [PATCH] [ppc] fix mot_info section
In-Reply-To: <a781481a0705300758t5f16235al1f420f09472af780@mail.gmail.com>
Message-ID: <Pine.SOC.4.64.0705301805390.23769@math>
References: <Pine.SOC.4.64.0705141717110.23895@math> 
 <20070515204540.GC22966@uranus.ravnborg.org>  <Pine.SOC.4.64.0705301652250.23769@math>
 <a781481a0705300758t5f16235al1f420f09472af780@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The following patch makes mot_info __initdata since it is used only in 
__init functions. prep_pci.c change has been tested in real life on 
Motorola Powerstack II (compiles without modpost warnings and boots 
fine), pplus.c has not been tested but seems similar.

Signed-off-by: Meelis Roos <mroos@linux.ee>

diff --git a/arch/ppc/platforms/pplus.c b/arch/ppc/platforms/pplus.c
index 8a1788c..9744108 100644
--- a/arch/ppc/platforms/pplus.c
+++ b/arch/ppc/platforms/pplus.c
@@ -256,7 +256,7 @@ struct brd_info {
 	const char *name;
 	int (*map_irq) (struct pci_dev *, unsigned char, unsigned char);
 };
-struct brd_info mot_info[] = {
+__initdata struct brd_info mot_info[] = {
 	{0x300, 0x00, 0x00, "MVME 2400", Genesis2_map_irq},
 	{0x1E0, 0xE0, 0x00, "Mesquite cPCI (MCP750)", mesquite_map_irq},
 	{0x1E0, 0xE1, 0x00, "Sitka cPCI (MCPN750)", sitka_map_irq},
diff --git a/arch/ppc/platforms/prep_pci.c b/arch/ppc/platforms/prep_pci.c
index 1df3150..bdec1f1 100644
--- a/arch/ppc/platforms/prep_pci.c
+++ b/arch/ppc/platforms/prep_pci.c
@@ -792,7 +792,7 @@ raven_init(void)
 	return 1;
 }
 
-struct mot_info {
+__initdata struct mot_info {
 	int		cpu_type;	/* 0x100 mask assumes for Raven and Hawk boards that the level/edge are set */
 					/* 0x200 if this board has a Hawk chip. */
 	int		base_type;

-- 
Meelis Roos (mroos@linux.ee)
