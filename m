Return-Path: <linux-kernel-owner+w=401wt.eu-S1753817AbXC3DJL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753817AbXC3DJL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2007 23:09:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753816AbXC3DJL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Mar 2007 23:09:11 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:2746 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753817AbXC3DJJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2007 23:09:09 -0400
X-IronPort-AV: i="4.14,350,1170651600"; 
   d="scan'208"; a="25878662:sNHT22942129"
Subject: [PATCH] blackfin arch PNAV and Bluetechnix CM-BF537 use the MAC
	address programmed by u-boot and Warn if no valid MAC address found
From: "Wu, Bryan" <bryan.wu@analog.com>
Reply-To: bryan.wu@analog.com
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Analog Devices, Inc.
Date: Fri, 30 Mar 2007 11:10:07 +0800
Message-Id: <1175224208.15391.53.camel@roc-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Bryan Wu <bryan.wu@analog.com>
---
 arch/blackfin/mach-bf537/boards/eth_mac.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/blackfin/mach-bf537/boards/eth_mac.c b/arch/blackfin/mach-bf537/boards/eth_mac.c
index 81544a1..e129a08 100644
--- a/arch/blackfin/mach-bf537/boards/eth_mac.c
+++ b/arch/blackfin/mach-bf537/boards/eth_mac.c
@@ -21,9 +21,7 @@
 #include <asm/blackfin.h>
 
 #if	defined(CONFIG_GENERIC_BOARD) \
-	|| defined(CONFIG_BFIN537_STAMP) \
-	|| defined(CONFIG_BFIN537_BLUETECHNIX_CM) \
-	|| defined(CONFIG_PNAV10)
+	|| defined(CONFIG_BFIN537_STAMP)
 
 /*
  * Currently the MAC address is saved in Flash by U-Boot
@@ -45,6 +43,7 @@ void get_bf537_ether_addr(char *addr)
  */
 void get_bf537_ether_addr(char *addr)
 {
+	printk(KERN_WARNING "%s: No valid Ethernet MAC address found\n",__FILE__);
 }
 
 #endif
-- 
1.5.0.5

