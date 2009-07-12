Return-Path: <linux-kernel-owner+w=401wt.eu-S1754391AbZGLUOa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754391AbZGLUOa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jul 2009 16:14:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752170AbZGLUOW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Jul 2009 16:14:22 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:58866 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751241AbZGLUOV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jul 2009 16:14:21 -0400
Date: Sun, 12 Jul 2009 22:05:03 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: isdn@linux-pingi.de, isdn4linux@listserv.isdn4linux.de,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 3/5] drivers/isdn: Drop unnecessary NULL test
Message-ID: <Pine.LNX.4.64.0907122204140.22658@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

The result of container_of should not be NULL.  In particular, in this case
the argument to the enclosing function has passed though INIT_WORK, which
dereferences it, implying that its container cannot be NULL.

A simplified version of the semantic patch that makes this change is as
follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@@
identifier fn,work,x,fld;
type T;
expression E1,E2;
statement S;
@@

static fn(struct work_struct *work) {
  ... when != work = E1
  x = container_of(work,T,fld)
  ... when != x = E2
- if (x == NULL) S
  ...
}
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/isdn/hisax/amd7930_fn.c |    2 --
 drivers/isdn/hisax/hfc_pci.c    |    2 --
 drivers/isdn/hisax/hfc_sx.c     |    2 --
 drivers/isdn/hisax/icc.c        |    2 --
 drivers/isdn/hisax/isac.c       |    2 --
 drivers/isdn/hisax/w6692.c      |    2 --
 6 files changed, 12 deletions(-)

diff --git a/drivers/isdn/hisax/amd7930_fn.c b/drivers/isdn/hisax/amd7930_fn.c
index 341faf5..bf526a7 100644
--- a/drivers/isdn/hisax/amd7930_fn.c
+++ b/drivers/isdn/hisax/amd7930_fn.c
@@ -238,8 +238,6 @@ Amd7930_bh(struct work_struct *work)
 		container_of(work, struct IsdnCardState, tqueue);
         struct PStack *stptr;
 
-	if (!cs)
-		return;
 	if (test_and_clear_bit(D_CLEARBUSY, &cs->event)) {
                 if (cs->debug)
 			debugl1(cs, "Amd7930: bh, D-Channel Busy cleared");
diff --git a/drivers/isdn/hisax/hfc_pci.c b/drivers/isdn/hisax/hfc_pci.c
index 3d337d9..d110a77 100644
--- a/drivers/isdn/hisax/hfc_pci.c
+++ b/drivers/isdn/hisax/hfc_pci.c
@@ -1506,8 +1506,6 @@ hfcpci_bh(struct work_struct *work)
 	u_long	flags;
 //      struct PStack *stptr;
 
-	if (!cs)
-		return;
 	if (test_and_clear_bit(D_L1STATECHANGE, &cs->event)) {
 		if (!cs->hw.hfcpci.nt_mode)
 			switch (cs->dc.hfcpci.ph_state) {
diff --git a/drivers/isdn/hisax/hfc_sx.c b/drivers/isdn/hisax/hfc_sx.c
index d92e8d6..419f87c 100644
--- a/drivers/isdn/hisax/hfc_sx.c
+++ b/drivers/isdn/hisax/hfc_sx.c
@@ -1255,8 +1255,6 @@ hfcsx_bh(struct work_struct *work)
 		container_of(work, struct IsdnCardState, tqueue);
 	u_long flags;
 
-	if (!cs)
-		return;
 	if (test_and_clear_bit(D_L1STATECHANGE, &cs->event)) {
 		if (!cs->hw.hfcsx.nt_mode)
 			switch (cs->dc.hfcsx.ph_state) {
diff --git a/drivers/isdn/hisax/icc.c b/drivers/isdn/hisax/icc.c
index 682cac3..9aba646 100644
--- a/drivers/isdn/hisax/icc.c
+++ b/drivers/isdn/hisax/icc.c
@@ -83,8 +83,6 @@ icc_bh(struct work_struct *work)
 		container_of(work, struct IsdnCardState, tqueue);
 	struct PStack *stptr;
 	
-	if (!cs)
-		return;
 	if (test_and_clear_bit(D_CLEARBUSY, &cs->event)) {
 		if (cs->debug)
 			debugl1(cs, "D-Channel Busy cleared");
diff --git a/drivers/isdn/hisax/isac.c b/drivers/isdn/hisax/isac.c
index 07b1673..a19354d 100644
--- a/drivers/isdn/hisax/isac.c
+++ b/drivers/isdn/hisax/isac.c
@@ -86,8 +86,6 @@ isac_bh(struct work_struct *work)
 		container_of(work, struct IsdnCardState, tqueue);
 	struct PStack *stptr;
 	
-	if (!cs)
-		return;
 	if (test_and_clear_bit(D_CLEARBUSY, &cs->event)) {
 		if (cs->debug)
 			debugl1(cs, "D-Channel Busy cleared");
diff --git a/drivers/isdn/hisax/w6692.c b/drivers/isdn/hisax/w6692.c
index bb1c8dd..c4d862c 100644
--- a/drivers/isdn/hisax/w6692.c
+++ b/drivers/isdn/hisax/w6692.c
@@ -105,8 +105,6 @@ W6692_bh(struct work_struct *work)
 		container_of(work, struct IsdnCardState, tqueue);
 	struct PStack *stptr;
 
-	if (!cs)
-		return;
 	if (test_and_clear_bit(D_CLEARBUSY, &cs->event)) {
 		if (cs->debug)
 			debugl1(cs, "D-Channel Busy cleared");
