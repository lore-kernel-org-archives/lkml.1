Return-Path: <linux-kernel-owner+w=401wt.eu-S1751821AbXDKJiM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751821AbXDKJiM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 05:38:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751795AbXDKJhq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 05:37:46 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:36422 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751793AbXDKJhp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 05:37:45 -0400
X-IronPort-AV: i="4.14,393,1170651600"; 
   d="scan'208"; a="34580498:sNHT28994385"
Subject: [PATCH 4/5] blackfin arch: workaround BF561 anomaly 05000266
From: "Wu, Bryan" <bryan.wu@analog.com>
Reply-To: bryan.wu@analog.com
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Analog Devices, Inc.
Date: Wed, 11 Apr 2007 17:40:11 +0800
Message-Id: <1176284411.29581.29.camel@roc-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH] blackfin arch: workaround BF561 anomaly 05000266

http://blackfin.uclinux.org/gf/project/uclinux-dist/tracker/?action=TrackerItemEdit&tracker_item_id=2958

Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
Signed-off-by: Bryan Wu <bryan.wu@analog.com>
---
 arch/blackfin/kernel/setup.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/arch/blackfin/kernel/setup.c b/arch/blackfin/kernel/setup.c
index 9e0c3fa..76e1f10 100644
--- a/arch/blackfin/kernel/setup.c
+++ b/arch/blackfin/kernel/setup.c
@@ -210,6 +210,11 @@ void __init setup_arch(char **cmdline_p)
 		panic("ANOMALY 05000273, SCLK can not be same as CCLK");
 #endif
 
+#if defined(ANOMALY_05000266)
+	bfin_read_IMDMA_D0_IRQ_STATUS();
+	bfin_read_IMDMA_D1_IRQ_STATUS();
+#endif
+
 #ifdef DEBUG_SERIAL_EARLY_INIT
 	bfin_console_init();	/* early console registration */
 	/* this give a chance to get printk() working before crash. */
-- 
1.5.0.5

