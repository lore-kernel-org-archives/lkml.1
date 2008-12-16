Return-Path: <linux-kernel-owner+w=401wt.eu-S1758502AbYLPPOp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758502AbYLPPOp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 10:14:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757946AbYLPPOc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 10:14:32 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:59560 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756742AbYLPPOa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 10:14:30 -0500
Date: Tue, 16 Dec 2008 16:14:28 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: lrodriguez@atheros.com, jmalinen@atheros.com,
       linux-wireless@vger.kernel.org, ath9k-devel@venema.h4ckr.net,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 7/11] drivers/net/wireless/ath9k: Move a dereference below
 a NULL test
Message-ID: <Pine.LNX.4.64.0812161613510.20444@pc-004.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

In each case, if the NULL test is necessary, then the dereference should be
moved below the NULL test.

The semantic patch that makes this change is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@@
type T;
expression E;
identifier i,fld;
statement S;
@@

- T i = E->fld;
+ T i;
  ... when != E
      when != i
  if (E == NULL) S
+ i = E->fld;
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/net/wireless/ath9k/hw.c     |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath9k/hw.c b/drivers/net/wireless/ath9k/hw.c
index 98bc25c..7d1dac6 100644
--- a/drivers/net/wireless/ath9k/hw.c
+++ b/drivers/net/wireless/ath9k/hw.c
@@ -5581,11 +5581,12 @@ static inline bool ath9k_hw_run_init_cals(struct ath_hal *ah,
 	struct ath9k_channel ichan;
 	bool isCalDone;
 	struct hal_cal_list *currCal = ahp->ah_cal_list_curr;
-	const struct hal_percal_data *calData = currCal->calData;
+	const struct hal_percal_data *calData;
 	int i;
 
 	if (currCal == NULL)
 		return false;
+	calData = currCal->calData;
 
 	ichan.CalValid = 0;
 
