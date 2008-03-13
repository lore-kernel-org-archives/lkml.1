Return-Path: <linux-kernel-owner+w=401wt.eu-S1757980AbYCMW3Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757980AbYCMW3Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 18:29:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753462AbYCMW3O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 18:29:14 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:14483 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753415AbYCMW3O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 18:29:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:subject;
        b=bHDWnQodSWRmKzReVWtJrYaECAet7OrGyt7DxVe119078L72dCWgveNbCpPDizniV9Qn41nOqmgPaO17zBdhUfBD27eO7vcd2xow6gPYFfIJ2DWP11VV9cZg8xgDuNzTZbNj8sGJD/iuFpjAyVX4kygpaT6Ejj/1rqIbAiz2WAw=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Thu, 13 Mar 2008 23:43:52 +0100
Message-Id: <20080313224352.7051.44005.sendpatchset@localhost.localdomain>
Subject: [PATCH 1/12] ali14xx: add "vlb_clock=" parameter
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add "vlb_clock=" parameter for specifying VLB clock frequency (in MHz).

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/legacy/ali14xx.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

Index: b/drivers/ide/legacy/ali14xx.c
===================================================================
--- a/drivers/ide/legacy/ali14xx.c
+++ b/drivers/ide/legacy/ali14xx.c
@@ -51,6 +51,8 @@
 
 #define DRV_NAME "ali14xx"
 
+static int vlb_clock;
+
 /* port addresses for auto-detection */
 #define ALI_NUM_PORTS 4
 static const int ports[ALI_NUM_PORTS] __initdata =
@@ -116,7 +118,7 @@ static void ali14xx_set_pio_mode(ide_dri
 	int time1, time2;
 	u8 param1, param2, param3, param4;
 	unsigned long flags;
-	int bus_speed = system_bus_clock();
+	int bus_speed = vlb_clock ? vlb_clock : system_bus_clock();
 
 	/* calculate timing, according to PIO mode */
 	time1 = ide_pio_cycle_time(drive, pio);
@@ -225,6 +227,9 @@ static int probe_ali14xx;
 module_param_named(probe, probe_ali14xx, bool, 0);
 MODULE_PARM_DESC(probe, "probe for ALI M14xx chipsets");
 
+module_param(vlb_clock, int, 0);
+MODULE_PARM_DESC(vlb_clock, "VLB clock frequency (in MHz)");
+
 static int __init ali14xx_init(void)
 {
 	if (probe_ali14xx == 0)
