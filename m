Return-Path: <linux-kernel-owner+w=401wt.eu-S965692AbXENK5z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965692AbXENK5z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 06:57:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758273AbXENK5s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 06:57:48 -0400
Received: from de01egw02.freescale.net ([192.88.165.103]:50471 "EHLO
	de01egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756806AbXENK5r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 06:57:47 -0400
Message-ID: <46484110.5020607@freescale.com>
Date: Mon, 14 May 2007 18:59:28 +0800
From: Li Yang <leoli@freescale.com>
User-Agent: Thunderbird 1.5.0.4 (Windows/20060516)
MIME-Version: 1.0
To: Paul <paulus@samba.org>
CC: linuxppc-dev@ozlabs.org, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2] powerpc: Fix Section mismatch warnings
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 14 May 2007 10:57:42.0509 (UTC) FILETIME=[B21DC1D0:01C79616]
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
index 7104567..5c9f135 100644
--- a/arch/powerpc/platforms/chrp/pegasos_eth.c
+++ b/arch/powerpc/platforms/chrp/pegasos_eth.c
@@ -169,7 +169,7 @@ static int Enable_SRAM(void)
 
 /***********/
 /***********/
-int mv643xx_eth_add_pds(void)
+int __init mv643xx_eth_add_pds(void)
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


