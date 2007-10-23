Return-Path: <linux-kernel-owner+w=401wt.eu-S1753469AbXJWBK0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753469AbXJWBK0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 21:10:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751573AbXJWBKS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 21:10:18 -0400
Received: from smtp-out1.tiscali.nl ([195.241.79.176]:35811 "EHLO
	smtp-out1.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751028AbXJWBKR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 21:10:17 -0400
Message-ID: <471D49F6.5090804@tiscali.nl>
Date: Tue, 23 Oct 2007 03:10:14 +0200
From: Roel Kluin <12o3l@tiscali.nl>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] Unlock in iTCO_wdt_start when reboot is disabled
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

commit 61c31efe4e9c34531666a6c5857ecd19c22228db
Author: Roel Kluin <12o3l@tiscali.nl>
Date:   Tue Oct 23 03:08:27 2007 +0200

    Unlock in iTCO_wdt_start when reboot is disabled
    
    Signed-off-by: Roel Kluin <12o3l@tiscali.nl>

diff --git a/drivers/watchdog/iTCO_wdt.c b/drivers/watchdog/iTCO_wdt.c
index cd5a565..185c093 100644
--- a/drivers/watchdog/iTCO_wdt.c
+++ b/drivers/watchdog/iTCO_wdt.c
@@ -300,6 +300,7 @@ static int iTCO_wdt_start(void)
 
 	/* disable chipset's NO_REBOOT bit */
 	if (iTCO_wdt_unset_NO_REBOOT_bit()) {
+		spin_unlock(&iTCO_wdt_private.io_lock);
 		printk(KERN_ERR PFX "failed to reset NO_REBOOT flag, reboot disabled by hardware\n");
 		return -EIO;
 	}
