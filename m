Return-Path: <linux-kernel-owner+w=401wt.eu-S1765497AbYBZUoq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765497AbYBZUoq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 15:44:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765418AbYBZUo3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 15:44:29 -0500
Received: from mgw1.diku.dk ([130.225.96.91]:59205 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765399AbYBZUo0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 15:44:26 -0500
Date: Tue, 26 Feb 2008 21:44:23 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: yi.zhu@intel.com, linux-wireless@vger.kernel.org,
       ipw3945-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 6/9] drivers/net/wireless/iwlwifi/iwl-4965.c: Correct use of
 ! and &
Message-ID: <Pine.LNX.4.64.0802262143570.18200@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

In commit e6bafba5b4765a5a252f1b8d31cbf6d2459da337, a bug was fixed that
involved converting !x & y to !(x & y).  The code below shows the same
pattern, and thus should perhaps be fixed in the same way.

This is not tested and clearly changes the semantics, so it is only
something to consider.

The semantic patch that makes this change is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@@ expression E1,E2; @@
(
  !E1 & !E2
|
- !E1 & E2
+ !(E1 & E2)
)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---

diff -u -p a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c 2008-02-05 20:56:01.000000000 +0100
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c 2008-02-26 08:09:12.000000000 +0100
@@ -4589,7 +4589,7 @@ static u8 iwl4965_is_fat_tx_allowed(stru
 
 	if (sta_ht_inf) {
 		if ((!sta_ht_inf->ht_supported) ||
-		   (!sta_ht_inf->cap & IEEE80211_HT_CAP_SUP_WIDTH))
+		   (!(sta_ht_inf->cap & IEEE80211_HT_CAP_SUP_WIDTH)))
 			return 0;
 	}
 
