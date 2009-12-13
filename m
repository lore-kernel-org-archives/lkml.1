Return-Path: <linux-kernel-owner+w=401wt.eu-S1752744AbZLMLmP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752744AbZLMLmP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 06:42:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752594AbZLMLmM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 06:42:12 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:39108 "HELO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752587AbZLMLmK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 06:42:10 -0500
Date: Sun, 13 Dec 2009 12:42:07 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: Ivo van Doorn <IvDoorn@gmail.com>,
       Gertjan van Wingerde <gwingerde@gmail.com>,
       "John W. Linville" <linville@tuxdriver.com>,
       linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 5/9] drivers/net/wireless: Correct code taking the size of
 a pointer
Message-ID: <Pine.LNX.4.64.0912131241470.24267@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

sizeof(iv16) and sizeof(iv32) are the sizes of pointers.  Change them to
the size of the copied data.

A simplified version of the semantic patch that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@@
expression *x;
expression f;
type T;
@@

*f(...,(T)x,...)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/net/wireless/rt2x00/rt2800lib.c        |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index eb1e1d0..1e74732 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -2140,8 +2140,8 @@ static void rt2800_get_tkip_seq(struct ieee80211_hw *hw, u8 hw_key_idx,
 	rt2800_register_multiread(rt2x00dev, offset,
 				      &iveiv_entry, sizeof(iveiv_entry));
 
-	memcpy(&iveiv_entry.iv[0], iv16, sizeof(iv16));
-	memcpy(&iveiv_entry.iv[4], iv32, sizeof(iv32));
+	memcpy(&iveiv_entry.iv[0], iv16, sizeof(*iv16));
+	memcpy(&iveiv_entry.iv[4], iv32, sizeof(*iv32));
 }
 
 static int rt2800_set_rts_threshold(struct ieee80211_hw *hw, u32 value)
