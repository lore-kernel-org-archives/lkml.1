Return-Path: <linux-kernel-owner+w=401wt.eu-S1755569AbYKIQ4b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755569AbYKIQ4b (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2008 11:56:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755981AbYKIQ4Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Nov 2008 11:56:16 -0500
Received: from mgw1.diku.dk ([130.225.96.91]:43608 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756146AbYKIQ4N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2008 11:56:13 -0500
Date: Sun, 9 Nov 2008 17:56:10 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: lrodriguez@atheros.com, jmalinen@atheros.com,
       linux-wireless@vger.kernel.org, ath9k-devel@venema.h4ckr.net,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 6/8] drivers/net/wireless/ath9k/rc.c: use ARRAY_SIZE
Message-ID: <Pine.LNX.4.64.0811091755500.32509@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

ARRAY_SIZE is more concise to use when the size of an array is divided by
the size of its type or the size of its first element.

The semantic patch that makes this change is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@i@
@@

#include <linux/kernel.h>

@depends on i using "paren.iso"@
type T;
T[] E;
@@

- (sizeof(E)/sizeof(E[...]))
+ ARRAY_SIZE(E)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/net/wireless/ath9k/rc.c     |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath9k/rc.c b/drivers/net/wireless/ath9k/rc.c
index cca2fc5..ea37673 100644
--- a/drivers/net/wireless/ath9k/rc.c
+++ b/drivers/net/wireless/ath9k/rc.c
@@ -1272,8 +1272,7 @@ static void ath_rc_update_ht(struct ath_softc *sc,
 				rate_ctrl->state[tx_rate].per = 100;
 		} else {
 			/* xretries == 2 */
-			count = sizeof(nretry_to_per_lookup) /
-				sizeof(nretry_to_per_lookup[0]);
+			count = ARRAY_SIZE(nretry_to_per_lookup);
 			if (retries >= count)
 				retries = count - 1;
 			/* new_PER = 7/8*old_PER + 1/8*(currentPER) */
@@ -1291,8 +1290,7 @@ static void ath_rc_update_ht(struct ath_softc *sc,
 	} else {	/* xretries == 0 */
 		/* Update the PER. */
 		/* Make sure it doesn't index out of array's bounds. */
-		count = sizeof(nretry_to_per_lookup) /
-			sizeof(nretry_to_per_lookup[0]);
+		count = ARRAY_SIZE(nretry_to_per_lookup);
 		if (retries >= count)
 			retries = count - 1;
 		if (info_priv->n_bad_frames) {
