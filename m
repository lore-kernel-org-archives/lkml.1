Return-Path: <linux-kernel-owner+w=401wt.eu-S1753923AbXJVCKp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753923AbXJVCKp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2007 22:10:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751522AbXJVCKi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Oct 2007 22:10:38 -0400
Received: from smtp-out3.tiscali.nl ([195.241.79.178]:33658 "EHLO
	smtp-out3.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751164AbXJVCKi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2007 22:10:38 -0400
Message-ID: <471C0697.1040906@tiscali.nl>
Date: Mon, 22 Oct 2007 04:10:31 +0200
From: Roel Kluin <12o3l@tiscali.nl>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] unlock before bug returns
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I think the unlock should be before bugging?

--
    unlock before bug returns
    
    Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
---
diff --git a/arch/arm/mach-omap2/gpmc.c b/arch/arm/mach-omap2/gpmc.c
index 5a4cc20..c910170 100644
--- a/arch/arm/mach-omap2/gpmc.c
+++ b/arch/arm/mach-omap2/gpmc.c
@@ -357,9 +357,8 @@ void gpmc_cs_free(int cs)
 	spin_lock(&gpmc_mem_lock);
 	if (cs >= GPMC_CS_NUM || !gpmc_cs_reserved(cs)) {
 		printk(KERN_ERR "Trying to free non-reserved GPMC CS%d\n", cs);
-		BUG();
 		spin_unlock(&gpmc_mem_lock);
-		return;
+		BUG();
 	}
 	gpmc_cs_disable_mem(cs);
 	release_resource(&gpmc_cs_mem[cs]);
