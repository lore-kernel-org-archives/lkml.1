Return-Path: <linux-kernel-owner+w=401wt.eu-S1765660AbXJQKkz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765660AbXJQKkz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 06:40:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761511AbXJQKkh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 06:40:37 -0400
Received: from mail.atmel.fr ([81.80.104.162]:59090 "EHLO atmel-es2.atmel.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757639AbXJQKkg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 06:40:36 -0400
X-Greylist: delayed 2800 seconds by postgrey-1.27 at vger.kernel.org; Wed, 17 Oct 2007 06:40:29 EDT
Message-ID: <4715DBA4.1020005@atmel.com>
Date: Wed, 17 Oct 2007 11:53:40 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Pierre Ossman <drzeus@drzeus.cx>
CC: Andrew Victor <andrew@sanpeople.com>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Patrice Vilchez <patrice.vilchez@rfo.atmel.com>
Subject: [PATCH] mmc: at91_mci: cleanup: use MCI_ERRORS
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Victor <andrew@sanpeople.com>

A small MMC driver cleanup.

Use the defined AT91_MCI_ERRORS in at91_mci_completed_command() instead
of specifying all the error bits individually.

Signed-off-by: Andrew Victor <andrew@sanpeople.com>
Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
Index: linux-2.6-snapshot/drivers/mmc/host/at91_mci.c
===================================================================
--- a/drivers/mmc/host/at91_mci.c
+++ b/drivers/mmc/host/at91_mci.c
@@ -581,9 +581,7 @@
 	pr_debug("Status = %08X [%08X %08X %08X %08X]\n",
 		 status, cmd->resp[0], cmd->resp[1], cmd->resp[2], cmd->resp[3]);
 
-	if (status & (AT91_MCI_RINDE | AT91_MCI_RDIRE | AT91_MCI_RCRCE |
-			AT91_MCI_RENDE | AT91_MCI_RTOE | AT91_MCI_DCRCE |
-			AT91_MCI_DTOE | AT91_MCI_OVRE | AT91_MCI_UNRE)) {
+	if (status & AT91_MCI_ERRORS) {
 		if ((status & AT91_MCI_RCRCE) && !(mmc_resp_type(cmd) & MMC_RSP_CRC)) {
 			cmd->error = 0;
 		}
