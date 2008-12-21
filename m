Return-Path: <linux-kernel-owner+w=401wt.eu-S1755486AbYLUPjw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755486AbYLUPjw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2008 10:39:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752285AbYLUPjl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Dec 2008 10:39:41 -0500
Received: from mgw1.diku.dk ([130.225.96.91]:51532 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754297AbYLUPjj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2008 10:39:39 -0500
Date: Sun, 21 Dec 2008 16:39:37 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: jbarnes@virtuousgeek.org, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 8/13] drivers/pci/hotplug: Remove redundant test
Message-ID: <Pine.LNX.4.64.0812211639170.9555@pc-004.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

func is checked not to be NULL a few lines before.

A simplified version of the semantic patch that makes this change is as
follows: (http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@r exists@
local idexpression x;
expression E;
position p1,p2;
@@

if (x@p1 == NULL || ...) { ... when forall
   return ...; }
... when != \(x=E\|x--\|x++\|--x\|++x\|x-=E\|x+=E\|x|=E\|x&=E\|&x\)
(
x@p2 == NULL
|
x@p2 != NULL
)

// another path to the test that is not through p1?
@s exists@
local idexpression r.x;
position r.p1,r.p2;
@@

... when != x@p1
(
x@p2 == NULL
|
x@p2 != NULL
)

@fix depends on !s@
position r.p1,r.p2;
expression x,E;
statement S1,S2;
@@

(
- if ((x@p2 != NULL) || ...)
  S1
|
- if ((x@p2 == NULL) && ...) S1
|
- BUG_ON(x@p2 == NULL);
)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/pci/hotplug/cpqphp_ctrl.c   |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/pci/hotplug/cpqphp_ctrl.c b/drivers/pci/hotplug/cpqphp_ctrl.c
index d947221..cc227a8 100644
--- a/drivers/pci/hotplug/cpqphp_ctrl.c
+++ b/drivers/pci/hotplug/cpqphp_ctrl.c
@@ -1954,7 +1954,7 @@ void cpqhp_pushbutton_thread(unsigned long slot)
 			return ;
 		}
 
-		if (func != NULL && ctrl != NULL) {
+		if (ctrl != NULL) {
 			if (cpqhp_process_SI(ctrl, func) != 0) {
 				amber_LED_on(ctrl, hp_slot);
 				green_LED_off(ctrl, hp_slot);
