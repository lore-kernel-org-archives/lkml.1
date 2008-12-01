Return-Path: <linux-kernel-owner+w=401wt.eu-S1751746AbYLAHbZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751746AbYLAHbZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 02:31:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750755AbYLAHbR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 02:31:17 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:35320 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750740AbYLAHbQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 02:31:16 -0500
Message-ID: <493392BA.50906@jp.fujitsu.com>
Date: Mon, 01 Dec 2008 16:31:06 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.18 (Windows/20081105)
MIME-Version: 1.0
To: linux-pci@vger.kernel.org, tom.l.nguyen@intel.com, yanmin.zhang@intel.com
CC: linux-kernel@vger.kernel.org
Subject: [PATCH] aerdrv: fix sanity check in report_resume
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

What we have to check here before calling it is err_handler->resume.
It seems that this block have been copy&pasted from report_slot_reset.

Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
---
 drivers/pci/pcie/aer/aerdrv_core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/pci/pcie/aer/aerdrv_core.c b/drivers/pci/pcie/aer/aerdrv_core.c
index dfc63d0..aac7006 100644
--- a/drivers/pci/pcie/aer/aerdrv_core.c
+++ b/drivers/pci/pcie/aer/aerdrv_core.c
@@ -252,7 +252,7 @@ static void report_resume(struct pci_dev *dev, void *data)
 
 	if (!dev->driver ||
 		!dev->driver->err_handler ||
-		!dev->driver->err_handler->slot_reset)
+		!dev->driver->err_handler->resume)
 		return;
 
 	err_handler = dev->driver->err_handler;
-- 
1.6.0


