Return-Path: <linux-kernel-owner+w=401wt.eu-S1758206AbYCMW3l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758206AbYCMW3l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 18:29:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756830AbYCMW3T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 18:29:19 -0400
Received: from fk-out-0910.google.com ([209.85.128.190]:64877 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756858AbYCMW3R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 18:29:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=cd05XAeqjz6NuPsac2Vnk39koZJT8TPhzlRkTODZPGw+oa3AId1m3bSVaM4eurO6a5humj5SscYUr++7BhpHUL4CouVcU8kY/OopdaXDZSPVA4iWKEeW1SecytJwqvjPNC6CoB3JuzDyfHtDvTmpgDaEY8Pg4D/hr4BfNPcqxMI=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Thu, 13 Mar 2008 23:43:59 +0100
Message-Id: <20080313224359.7051.8198.sendpatchset@localhost.localdomain>
In-Reply-To: <20080313224352.7051.44005.sendpatchset@localhost.localdomain>
References: <20080313224352.7051.44005.sendpatchset@localhost.localdomain>
Subject: [PATCH 2/12] ht6560b: add "vlb_clock=" parameter
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add "vlb_clock=" parameter for specifying VLB clock frequency (in MHz).

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/legacy/ht6560b.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

Index: b/drivers/ide/legacy/ht6560b.c
===================================================================
--- a/drivers/ide/legacy/ht6560b.c
+++ b/drivers/ide/legacy/ht6560b.c
@@ -116,6 +116,8 @@
 #define HT_TIMING(drivea) (u8)((drivea)->drive_data & 0x00ff)
 #define HT_TIMING_DEFAULT 0xff
 
+static int vlb_clock;
+
 /*
  * This routine handles interface switching for the peculiar hardware design
  * on the F.G.I./Holtek HT-6560B VLB IDE interface.
@@ -212,8 +214,8 @@ static u8 ht_pio2timings(ide_drive_t *dr
 {
 	int active_time, recovery_time;
 	int active_cycles, recovery_cycles;
-	int bus_speed = system_bus_clock();
-	
+	int bus_speed = vlb_clock ? vlb_clock : system_bus_clock();
+
         if (pio) {
 		unsigned int cycle_time;
 
@@ -328,6 +330,9 @@ static int probe_ht6560b;
 module_param_named(probe, probe_ht6560b, bool, 0);
 MODULE_PARM_DESC(probe, "probe for HT6560B chipset");
 
+module_param(vlb_clock, int, 0);
+MODULE_PARM_DESC(vlb_clock, "VLB clock frequency (in MHz)");
+
 static const struct ide_port_ops ht6560b_port_ops = {
 	.port_init_devs		= ht6560b_port_init_devs,
 	.set_pio_mode		= ht6560b_set_pio_mode,
