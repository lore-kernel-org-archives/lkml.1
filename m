Return-Path: <linux-kernel-owner+w=401wt.eu-S1762305AbXK2ByZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762305AbXK2ByZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 20:54:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757899AbXK2ByR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 20:54:17 -0500
Received: from smtp-out0.tiscali.nl ([195.241.79.175]:42147 "EHLO
	smtp-out0.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757460AbXK2ByQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 20:54:16 -0500
Message-ID: <474E1BC3.807@tiscali.nl>
Date: Thu, 29 Nov 2007 02:54:11 +0100
From: Roel Kluin <12o3l@tiscali.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: "Kok, Auke" <auke-jan.h.kok@intel.com>,
       lkml <linux-kernel@vger.kernel.org>
CC: e1000-devel@lists.sourceforge.net
Subject: [PATCH] net/e1000: fix memcpy  in e1000_get_strings
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/net/e1000/e1000_ethtool.c:113:
#define E1000_TEST_LEN sizeof(e1000_gstrings_test) / ETH_GSTRING_LEN

drivers/net/e1000e/ethtool.c:106:
#define E1000_TEST_LEN sizeof(e1000_gstrings_test) / ETH_GSTRING_LEN

E1000_TEST_LEN*ETH_GSTRING_LEN will expand to 
sizeof(e1000_gstrings_test) / (ETH_GSTRING_LEN * ETH_GSTRING_LEN)

Please confirm that the change is as wanted.
--
A lack of parentheses around defines causes unexpected results due to operator
precedences.

Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
---
diff --git a/drivers/net/e1000/e1000_ethtool.c b/drivers/net/e1000/e1000_ethtool.c
index 667f18b..b83ccce 100644
--- a/drivers/net/e1000/e1000_ethtool.c
+++ b/drivers/net/e1000/e1000_ethtool.c
@@ -1923,7 +1923,7 @@ e1000_get_strings(struct net_device *netdev, uint32_t stringset, uint8_t *data)
 	switch (stringset) {
 	case ETH_SS_TEST:
 		memcpy(data, *e1000_gstrings_test,
-			E1000_TEST_LEN*ETH_GSTRING_LEN);
+			sizeof(e1000_gstrings_test));
 		break;
 	case ETH_SS_STATS:
 		for (i = 0; i < E1000_GLOBAL_STATS_LEN; i++) {
diff --git a/drivers/net/e1000e/ethtool.c b/drivers/net/e1000e/ethtool.c
index 6a39784..338c49d 100644
--- a/drivers/net/e1000e/ethtool.c
+++ b/drivers/net/e1000e/ethtool.c
@@ -1739,7 +1739,7 @@ static void e1000_get_strings(struct net_device *netdev, u32 stringset,
 	switch (stringset) {
 	case ETH_SS_TEST:
 		memcpy(data, *e1000_gstrings_test,
-			E1000_TEST_LEN*ETH_GSTRING_LEN);
+				sizeof(e1000_gstrings_test));
 		break;
 	case ETH_SS_STATS:
 		for (i = 0; i < E1000_GLOBAL_STATS_LEN; i++) {
