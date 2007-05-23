Return-Path: <linux-kernel-owner+w=401wt.eu-S1758260AbXEWD03@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758260AbXEWD03 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 23:26:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755711AbXEWD0V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 23:26:21 -0400
Received: from de01egw02.freescale.net ([192.88.165.103]:58336 "EHLO
	de01egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755127AbXEWD0V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 23:26:21 -0400
Message-ID: <4653B4C3.8090107@freescale.com>
Date: Wed, 23 May 2007 11:28:03 +0800
From: Li Yang <leoli@freescale.com>
User-Agent: Thunderbird 1.5.0.4 (Windows/20060516)
MIME-Version: 1.0
To: Paul <paulus@samba.org>
CC: sl@bplan-gmbh.de, benh@kernel.crashing.org, linuxppc-dev@ozlabs.org,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] powerpc: Fix Section mismatch warnings
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 23 May 2007 03:26:15.0440 (UTC) FILETIME=[1EAEC900:01C79CEA]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fix the following Section mismatch warnings
in powerpc code.

WARNING: arch/powerpc/platforms/built-in.o - Section mismatch: reference to .init.data:mv643xx_eth_pd_devs from .text between 'mv643xx_eth_add_pds' (at offset 0x9ed2) and 'gg2_read_config'
WARNING: arch/powerpc/platforms/built-in.o - Section mismatch: reference to .init.data:mv643xx_eth_pd_devs from .text between 'mv643xx_eth_add_pds' (at offset 0x9ed6) and 'gg2_read_config'
WARNING: arch/powerpc/platforms/built-in.o - Section mismatch: reference to .init.text:note_scsi_host from __ksymtab between '__ksymtab_note_scsi_host' (at offset 0x8) and '__ksymtab_sys_ctrler'

Signed-off-by: Li Yang <leoli@freescale.com>
---
 arch/powerpc/platforms/chrp/pegasos_eth.c |    2 +-
 arch/powerpc/platforms/powermac/setup.c   |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/platforms/chrp/pegasos_eth.c b/arch/powerpc/platforms/chrp/pegasos_eth.c
index 7104567..5bcc58d 100644
--- a/arch/powerpc/platforms/chrp/pegasos_eth.c
+++ b/arch/powerpc/platforms/chrp/pegasos_eth.c
@@ -169,7 +169,7 @@ static int Enable_SRAM(void)
 
 /***********/
 /***********/
-int mv643xx_eth_add_pds(void)
+static int __init mv643xx_eth_add_pds(void)
 {
 	int ret = 0;
 	static struct pci_device_id pci_marvell_mv64360[] = {
diff --git a/arch/powerpc/platforms/powermac/setup.c b/arch/powerpc/platforms/powermac/setup.c
index a410bc7..07b1c4e 100644
--- a/arch/powerpc/platforms/powermac/setup.c
+++ b/arch/powerpc/platforms/powermac/setup.c
@@ -384,7 +384,7 @@ int boot_part;
 static dev_t boot_dev;
 
 #ifdef CONFIG_SCSI
-void __init note_scsi_host(struct device_node *node, void *host)
+void note_scsi_host(struct device_node *node, void *host)
 {
 	int l;
 	char *p;


