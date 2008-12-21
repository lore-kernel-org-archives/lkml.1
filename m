Return-Path: <linux-kernel-owner+w=401wt.eu-S1751980AbYLUSIX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751980AbYLUSIX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2008 13:08:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750900AbYLUSIO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Dec 2008 13:08:14 -0500
Received: from mgw1.diku.dk ([130.225.96.91]:33952 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750757AbYLUSIN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2008 13:08:13 -0500
Date: Sun, 21 Dec 2008 19:08:09 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: sameo@openedhand.com, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH] drivers/mfd: Adjust NULL test
Message-ID: <Pine.LNX.4.64.0812211907400.9555@pc-004.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Since ei is already known to be non-NULL, I assume that what was intended
was to test the result of kzalloc.

The semantic patch that makes this change is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@@
expression E,E1;
identifier f,fld,fld1;
statement S1,S2;
@@

E->fld = f(...);
... when != E = E1
    when != E->fld1 = E1
if (
-   E
+   E->fld
           == NULL) S1 else S2
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/mfd/htc-egpio.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -u -p a/drivers/mfd/htc-egpio.c b/drivers/mfd/htc-egpio.c
--- a/drivers/mfd/htc-egpio.c
+++ b/drivers/mfd/htc-egpio.c
@@ -307,7 +307,7 @@ static int __init egpio_probe(struct pla
 
 	ei->nchips = pdata->num_chips;
 	ei->chip = kzalloc(sizeof(struct egpio_chip) * ei->nchips, GFP_KERNEL);
-	if (!ei) {
+	if (!ei->chip) {
 		ret = -ENOMEM;
 		goto fail;
 	}
