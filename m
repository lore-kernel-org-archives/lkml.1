Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758052Ab0BRS65 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 13:58:57 -0500
Received: from smtp.nokia.com ([192.100.122.233]:51748 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755324Ab0BRS5V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 13:57:21 -0500
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>
Subject: [PATCH 10/12] drivers: net: use new hex_to_bin() method
Date: Thu, 18 Feb 2010 20:55:49 +0200
Message-Id: <1266519351-3218-11-git-send-email-andy.shevchenko@gmail.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1266519351-3218-10-git-send-email-andy.shevchenko@gmail.com>
References: <1266519351-3218-1-git-send-email-andy.shevchenko@gmail.com>
 <1266519351-3218-2-git-send-email-andy.shevchenko@gmail.com>
 <1266519351-3218-3-git-send-email-andy.shevchenko@gmail.com>
 <1266519351-3218-4-git-send-email-andy.shevchenko@gmail.com>
 <1266519351-3218-5-git-send-email-andy.shevchenko@gmail.com>
 <1266519351-3218-6-git-send-email-andy.shevchenko@gmail.com>
 <1266519351-3218-7-git-send-email-andy.shevchenko@gmail.com>
 <1266519351-3218-8-git-send-email-andy.shevchenko@gmail.com>
 <1266519351-3218-9-git-send-email-andy.shevchenko@gmail.com>
 <1266519351-3218-10-git-send-email-andy.shevchenko@gmail.com>
X-OriginalArrivalTime: 18 Feb 2010 18:57:14.0983 (UTC) FILETIME=[2F7A1F70:01CAB0CC]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>

Get rid of own implementation of hex_to_bin(). It requires to have hex_to_bin()
introduced by one of previous path in series.

Signed-off-by: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>
---
 drivers/net/cxgb3/t3_hw.c |   16 ++++------------
 1 files changed, 4 insertions(+), 12 deletions(-)

diff --git a/drivers/net/cxgb3/t3_hw.c b/drivers/net/cxgb3/t3_hw.c
index 032cfe0..80b3cd7 100644
--- a/drivers/net/cxgb3/t3_hw.c
+++ b/drivers/net/cxgb3/t3_hw.c
@@ -679,14 +679,6 @@ int t3_seeprom_wp(struct adapter *adapter, int enable)
 	return t3_seeprom_write(adapter, EEPROM_STAT_ADDR, enable ? 0xc : 0);
 }
 
-/*
- * Convert a character holding a hex digit to a number.
- */
-static unsigned int hex2int(unsigned char c)
-{
-	return isdigit(c) ? c - '0' : toupper(c) - 'A' + 10;
-}
-
 /**
  *	get_vpd_params - read VPD parameters from VPD EEPROM
  *	@adapter: adapter to read
@@ -727,15 +719,15 @@ static int get_vpd_params(struct adapter *adapter, struct vpd_params *p)
 		p->port_type[0] = uses_xaui(adapter) ? 1 : 2;
 		p->port_type[1] = uses_xaui(adapter) ? 6 : 2;
 	} else {
-		p->port_type[0] = hex2int(vpd.port0_data[0]);
-		p->port_type[1] = hex2int(vpd.port1_data[0]);
+		p->port_type[0] = hex_to_bin(vpd.port0_data[0]);
+		p->port_type[1] = hex_to_bin(vpd.port1_data[0]);
 		p->xauicfg[0] = simple_strtoul(vpd.xaui0cfg_data, NULL, 16);
 		p->xauicfg[1] = simple_strtoul(vpd.xaui1cfg_data, NULL, 16);
 	}
 
 	for (i = 0; i < 6; i++)
-		p->eth_base[i] = hex2int(vpd.na_data[2 * i]) * 16 +
-				 hex2int(vpd.na_data[2 * i + 1]);
+		p->eth_base[i] = hex_to_bin(vpd.na_data[2*i]) * 16 +
+				 hex_to_bin(vpd.na_data[2*i + 1]);
 	return 0;
 }
 
-- 
1.5.6.5

