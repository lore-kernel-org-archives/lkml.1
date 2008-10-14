Return-Path: <linux-kernel-owner+w=401wt.eu-S1753352AbYJNQAG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753352AbYJNQAG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 12:00:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751703AbYJNP7z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 11:59:55 -0400
Received: from mgw1.diku.dk ([130.225.96.91]:54507 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751664AbYJNP7y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 11:59:54 -0400
Date: Tue, 14 Oct 2008 17:59:50 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: kristen.c.accardi@intel.com, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 1/2] drivers/pci/hotplug/cpqphp_ctrl.c: Convert && to ||
Message-ID: <Pine.LNX.4.64.0810141759300.20451@pc-004.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

The pattern !E && !E->fld is nonsensical.  The patch below updates this
according to the assumption that && should be ||.  But perhaps another
solution was intended.

The semantic patch that makes this change is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@disable and_comm@
expression E;
identifier fld;
@@

- !E && !E->fld
+ !E || !E->fld
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/pci/hotplug/cpqphp_ctrl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -u -p a/drivers/pci/hotplug/cpqphp_ctrl.c b/drivers/pci/hotplug/cpqphp_ctrl.c
--- a/drivers/pci/hotplug/cpqphp_ctrl.c
+++ b/drivers/pci/hotplug/cpqphp_ctrl.c
@@ -1139,7 +1139,7 @@ static u8 set_controller_speed(struct co
 	for(slot = ctrl->slot; slot; slot = slot->next) {
 		if (slot->device == (hp_slot + ctrl->slot_device_offset)) 
 			continue;
-		if (!slot->hotplug_slot && !slot->hotplug_slot->info) 
+		if (!slot->hotplug_slot || !slot->hotplug_slot->info) 
 			continue;
 		if (slot->hotplug_slot->info->adapter_status == 0) 
 			continue;
