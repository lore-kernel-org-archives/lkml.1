Return-Path: <linux-kernel-owner+w=401wt.eu-S1752651AbZLMLlF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752651AbZLMLlF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 06:41:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752613AbZLMLlA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 06:41:00 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:39071 "HELO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752565AbZLMLk6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 06:40:58 -0500
Date: Sun, 13 Dec 2009 12:40:55 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: chas@cmf.nrl.navy.mil, linux-atm-general@lists.sourceforge.net,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 2/9] drivers/atm: Correct code taking the size of a pointer
Message-ID: <Pine.LNX.4.64.0912131240400.24267@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

sizeof(TstSchedTbl) is just the size of the pointer.  Change it to the size
of the referenced data.

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
 drivers/atm/iphase.c                |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/atm/iphase.c b/drivers/atm/iphase.c
index f734b34..6b73c2b 100644
--- a/drivers/atm/iphase.c
+++ b/drivers/atm/iphase.c
@@ -557,7 +557,7 @@ static int ia_cbr_setup (IADEV *dev, struct atm_vcc *vcc) {
           memcpy((caddr_t)&cbrVC,(caddr_t)TstSchedTbl,sizeof(cbrVC));
        } /* while */
        // Move this VCI number into this location of the CBR Sched table.
-       memcpy((caddr_t)TstSchedTbl, (caddr_t)&vcIndex,sizeof(TstSchedTbl));
+       memcpy((caddr_t)TstSchedTbl, (caddr_t)&vcIndex, sizeof(*TstSchedTbl));
        dev->CbrRemEntries--;
        toBeAssigned--;
    } /* while */ 
