Return-Path: <linux-kernel-owner+w=401wt.eu-S1753607AbXJ2W01@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753607AbXJ2W01 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 18:26:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752349AbXJ2W0U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 18:26:20 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:51016 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751607AbXJ2W0T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 18:26:19 -0400
Date: Mon, 29 Oct 2007 11:19:40 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: wim@iguana.be, akpm <akpm@linux-foundation.org>
Subject: [PATCH] watchdog: fix iTCO section warning
Message-Id: <20071029111940.280cf4dc.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.6 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Make iTCO_wdt_probe() be __devinit.
Fixes these section warnings:

WARNING: vmlinux.o(.text+0x17d8a8): Section mismatch: reference to .init.data: (between 'iTCO_wdt_probe' and 'supermicro_new_unlock_watchdog')
WARNING: vmlinux.o(.text+0x17d97e): Section mismatch: reference to .init.data: (between 'iTCO_wdt_probe' and 'supermicro_new_unlock_watchdog')
WARNING: vmlinux.o(.text+0x17d989): Section mismatch: reference to .init.data:iTCO_chipset_info (between 'iTCO_wdt_probe' and 'supermicro_new_unlock_watchdog')

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/watchdog/iTCO_wdt.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.24-rc1-git4.orig/drivers/watchdog/iTCO_wdt.c
+++ linux-2.6.24-rc1-git4/drivers/watchdog/iTCO_wdt.c
@@ -709,7 +709,7 @@ static void iTCO_wdt_cleanup(void)
 	iTCO_wdt_private.ACPIBASE = 0;
 }
 
-static int iTCO_wdt_probe(struct platform_device *dev)
+static int __devinit iTCO_wdt_probe(struct platform_device *dev)
 {
 	int found = 0;
 	struct pci_dev *pdev = NULL;
