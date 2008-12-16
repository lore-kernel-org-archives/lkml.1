Return-Path: <linux-kernel-owner+w=401wt.eu-S1758014AbYLPPM4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758014AbYLPPM4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 10:12:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757874AbYLPPMp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 10:12:45 -0500
Received: from mgw1.diku.dk ([130.225.96.91]:59690 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757413AbYLPPMo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 10:12:44 -0500
Date: Tue, 16 Dec 2008 16:12:42 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: kkeil@suse.de, isdn4linux@listserv.isdn4linux.de,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 3/11] drivers/isdn/hardware/mISDN: Move a dereference below
 a NULL test
Message-ID: <Pine.LNX.4.64.0812161612170.20444@pc-004.diku.dk>
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
 drivers/isdn/hardware/mISDN/hfcmulti.c         |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/isdn/hardware/mISDN/hfcmulti.c b/drivers/isdn/hardware/mISDN/hfcmulti.c
index 1eac03f..4dd85a5 100644
--- a/drivers/isdn/hardware/mISDN/hfcmulti.c
+++ b/drivers/isdn/hardware/mISDN/hfcmulti.c
@@ -3607,7 +3607,7 @@ hfcm_bctrl(struct mISDNchannel *ch, u_int cmd, void *arg)
 static void
 ph_state_change(struct dchannel *dch)
 {
-	struct hfc_multi *hc = dch->hw;
+	struct hfc_multi *hc;
 	int ch, i;
 
 	if (!dch) {
@@ -3615,6 +3615,7 @@ ph_state_change(struct dchannel *dch)
 		    __func__);
 		return;
 	}
+	hc = dch->hw;
 	ch = dch->slot;
 
 	if (hc->type == 1) {
