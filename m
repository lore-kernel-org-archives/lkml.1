Return-Path: <linux-kernel-owner+w=401wt.eu-S1764730AbXHNVby@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764730AbXHNVby (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 17:31:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753827AbXHNVXL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 17:23:11 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:38410 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755081AbXHNVXF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 17:23:05 -0400
Date: Tue, 14 Aug 2007 23:22:46 +0200
From: Adrian Bunk <bunk@kernel.org>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz
Subject: [2.6 patch] cpqhp_pushbutton_thread(): remove a pointless if()
	check
Message-ID: <20070814212246.GC18945@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The Coverity checker spotted that we'd have already oops'ed if "ctrl"
was NULL.

Additionally, "func" had just been checked for not being NULL.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
--- linux-2.6.23-rc1-mm2/drivers/pci/hotplug/cpqphp_ctrl.c.old	2007-08-08 14:00:24.000000000 +0200
+++ linux-2.6.23-rc1-mm2/drivers/pci/hotplug/cpqphp_ctrl.c	2007-08-08 14:01:16.000000000 +0200
@@ -1951,30 +1951,28 @@ void cpqhp_pushbutton_thread(unsigned lo
 	if (is_slot_enabled(ctrl, hp_slot)) {
 		p_slot->state = POWEROFF_STATE;
 		/* power Down board */
 		func = cpqhp_slot_find(p_slot->bus, p_slot->device, 0);
 		dbg("In power_down_board, func = %p, ctrl = %p\n", func, ctrl);
 		if (!func) {
 			dbg("Error! func NULL in %s\n", __FUNCTION__);
 			return ;
 		}
 
-		if (func != NULL && ctrl != NULL) {
-			if (cpqhp_process_SS(ctrl, func) != 0) {
-				amber_LED_on (ctrl, hp_slot);
-				green_LED_on (ctrl, hp_slot);
-				
-				set_SOGO(ctrl);
+		if (cpqhp_process_SS(ctrl, func) != 0) {
+			amber_LED_on (ctrl, hp_slot);
+			green_LED_on (ctrl, hp_slot);
+			
+			set_SOGO(ctrl);
 
-				/* Wait for SOBS to be unset */
-				wait_for_ctrl_irq (ctrl);
-			}
+			/* Wait for SOBS to be unset */
+			wait_for_ctrl_irq (ctrl);
 		}
 
 		p_slot->state = STATIC_STATE;
 	} else {
 		p_slot->state = POWERON_STATE;
 		/* slot is off */
 
 		func = cpqhp_slot_find(p_slot->bus, p_slot->device, 0);
 		dbg("In add_board, func = %p, ctrl = %p\n", func, ctrl);
 		if (!func) {

