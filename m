Return-Path: <linux-kernel-owner+w=401wt.eu-S1755628AbZDQHYu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755628AbZDQHYu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 03:24:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751942AbZDQHYh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 03:24:37 -0400
Received: from outbound.icp-qv1-irony-out3.iinet.net.au ([203.59.1.148]:9620
	"EHLO outbound.icp-qv1-irony-out3.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751771AbZDQHYg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 03:24:36 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AuABAD/L50l8qMtz/2dsb2JhbAAIz2ODfQY
X-IronPort-AV: E=Sophos;i="4.40,203,1238947200"; 
   d="scan'208";a="420505137"
Subject: [PATCH] macb: Kconfig net device compat fixup
From: Ben Nizette <bn@niasdigital.com>
To: Haavard Skinnemoen <hskinnemoen@atmel.com>
Cc: jgarzik@pobox.com, netdev@vger.kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 17 Apr 2009 17:24:05 +1000
Message-Id: <1239953045.2837.58.camel@linux-51e8.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The macb driver hasn't been updated to use net_device_ops and as such
should select COMPAT_NET_DEV_OPS to avoid build breakage.

Of course really macb should be updated but in the mean time, this at
least avoid randconfig problems.

Signed-off-by: Ben Nizette <bn@niasdigital.com>
---
diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
index 9e7baec..dfe1254 100644
--- a/drivers/net/Kconfig
+++ b/drivers/net/Kconfig
@@ -221,6 +221,7 @@ config MACB
 	tristate "Atmel MACB support"
 	depends on AVR32 || ARCH_AT91SAM9260 || ARCH_AT91SAM9263 || ARCH_AT91SAM9G20 || ARCH_AT91CAP9
 	select PHYLIB
+	select COMPAT_NET_DEV_OPS
 	help
 	  The Atmel MACB ethernet interface is found on many AT32 and AT91
 	  parts. Say Y to include support for the MACB chip.


