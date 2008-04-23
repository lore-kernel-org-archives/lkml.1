Return-Path: <linux-kernel-owner+w=401wt.eu-S1758556AbYDWJ5o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758556AbYDWJ5o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 05:57:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755304AbYDWJwS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 05:52:18 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:36915 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754626AbYDWJwR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 05:52:17 -0400
Date: Wed, 23 Apr 2008 12:51:38 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Stephen Neuendorffer <stephen.neuendorffer@xilinx.com>,
       Grant Likely <grant.likely@secretlab.ca>, paulus@samba.org
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] char/xilinx_hwicap/ section fix
Message-ID: <20080423095138.GA28933@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following build error:

<--  snip  -->

...
  CC [M]  drivers/char/xilinx_hwicap/xilinx_hwicap.o
...
/home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/char/xilinx_hwicap/xilinx_hwicap.c:806: error: hwicap_of_match causes a section type conflict
/home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/char/xilinx_hwicap/xilinx_hwicap.c:806: error: hwicap_of_match causes a section type conflict
make[4]: *** [drivers/char/xilinx_hwicap/xilinx_hwicap.o] Error 1

<--  snip  -->

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
2f0f31d8aa696ca6cc45ab865ec8c68b90cd0e46 diff --git a/drivers/char/xilinx_hwicap/xilinx_hwicap.c b/drivers/char/xilinx_hwicap/xilinx_hwicap.c
index 016f905..dfe6907 100644
--- a/drivers/char/xilinx_hwicap/xilinx_hwicap.c
+++ b/drivers/char/xilinx_hwicap/xilinx_hwicap.c
@@ -803,7 +803,7 @@ static int __devexit hwicap_of_remove(struct of_device *op)
 }
 
 /* Match table for of_platform binding */
-static const struct of_device_id __devinit hwicap_of_match[] = {
+static const struct of_device_id __devinitconst hwicap_of_match[] = {
 	{ .compatible = "xlnx,opb-hwicap-1.00.b", .data = &buffer_icap_config},
 	{ .compatible = "xlnx,xps-hwicap-1.00.a", .data = &fifo_icap_config},
 	{},

