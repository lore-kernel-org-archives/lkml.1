Return-Path: <linux-kernel-owner+w=401wt.eu-S1758328AbYCMWdJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758328AbYCMWdJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 18:33:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758522AbYCMWaW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 18:30:22 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:14483 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758514AbYCMWaT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 18:30:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=ojNkpD+ySx3IGPNUqK6ERWAH/T7iSEcCSMHa9kBnTFMbYbyC8qnFmEC1/Ejcv9jj9DPqbIS2ejJcxHWf/9abhg/+relYSKt5Yw6UZOWET2AaFsS4/jgdM0pSxRfibxOQYs3toOvBAo6KX4epC08j3RvhdpwCvg41HYjV9cBGojw=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Thu, 13 Mar 2008 23:45:00 +0100
Message-Id: <20080313224500.7051.53562.sendpatchset@localhost.localdomain>
In-Reply-To: <20080313224352.7051.44005.sendpatchset@localhost.localdomain>
References: <20080313224352.7051.44005.sendpatchset@localhost.localdomain>
Subject: [PATCH 11/12] cmd640: add "cmd_clock=" parameter
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add "cmd_clock=" parameter for specifying VLB or PCI bus clock frequency
(in MHz).

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/pci/cmd640.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

Index: b/drivers/ide/pci/cmd640.c
===================================================================
--- a/drivers/ide/pci/cmd640.c
+++ b/drivers/ide/pci/cmd640.c
@@ -157,6 +157,8 @@ static int cmd640_vlb;
 #define DRWTIM23	0x58
 #define BRST		0x59
 
+static int cmd_clock;
+
 /*
  * Registers and masks for easy access by drive index:
  */
@@ -552,7 +554,7 @@ static void cmd640_set_mode(ide_drive_t 
 {
 	int setup_time, active_time, recovery_time, clock_time;
 	u8 setup_count, active_count, recovery_count, recovery_count2, cycle_count;
-	int bus_speed = system_bus_clock();
+	int bus_speed = cmd_clock ? cmd_clock : system_bus_clock();
 
 	if (pio_mode > 5)
 		pio_mode = 5;
@@ -904,4 +906,7 @@ static int __init cmd640x_init(void)
 module_param_named(probe_vlb, cmd640_vlb, bool, 0);
 MODULE_PARM_DESC(probe_vlb, "probe for VLB version of CMD640 chipset");
 
+module_param(cmd_clock, int, 0);
+MODULE_PARM_DESC(cmd_clock, "VLB or PCI bus clock frequency (in MHz)");
+
 module_init(cmd640x_init);
