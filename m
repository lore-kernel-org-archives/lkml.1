Return-Path: <linux-kernel-owner+w=401wt.eu-S965770AbZLHSvm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965770AbZLHSvm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 13:51:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756141AbZLHSvc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 13:51:32 -0500
Received: from mgw1.diku.dk ([130.225.96.91]:34990 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756166AbZLHSv3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 13:51:29 -0500
Date: Tue, 8 Dec 2009 19:51:34 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: isdn@linux-pingi.de, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH] drivers/isdn: eliminate duplicated test
Message-ID: <Pine.LNX.4.64.0912081951140.28834@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

The code checked slot_rx twice.  Check slot_tx by analogy with the bank
case.

The semantic match that finds this problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
expression E;
@@

(
*E && E
|
*E || E
)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/isdn/hardware/mISDN/hfcmulti.c         |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/isdn/hardware/mISDN/hfcmulti.c b/drivers/isdn/hardware/mISDN/hfcmulti.c
index a6624ad..1a1420d 100644
--- a/drivers/isdn/hardware/mISDN/hfcmulti.c
+++ b/drivers/isdn/hardware/mISDN/hfcmulti.c
@@ -3152,7 +3152,7 @@ static void
 hfcmulti_pcm(struct hfc_multi *hc, int ch, int slot_tx, int bank_tx,
     int slot_rx, int bank_rx)
 {
-	if (slot_rx < 0 || slot_rx < 0 || bank_tx < 0 || bank_rx < 0) {
+	if (slot_tx < 0 || slot_rx < 0 || bank_tx < 0 || bank_rx < 0) {
 		/* disable PCM */
 		mode_hfcmulti(hc, ch, hc->chan[ch].protocol, -1, 0, -1, 0);
 		return;
