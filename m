Return-Path: <linux-kernel-owner+w=401wt.eu-S1751634AbZG0QPp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751634AbZG0QPp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 12:15:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751318AbZG0QPo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 12:15:44 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:40562 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751228AbZG0QPm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 12:15:42 -0400
Date: Mon, 27 Jul 2009 18:12:34 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: chas@cmf.nrl.navy.mil, linux-atm-general@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 1/12] drivers/atm: Correct redundant test
Message-ID: <Pine.LNX.4.64.0907271812130.2682@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

str has already been tested.  It seems that this test should be on the
recently returned value snr.

A simplified version of the semantic match that finds this problem is as
follows: (http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@r exists@
local idexpression x;
expression E;
@@

if (x == NULL || ...) { ... when forall
   return ...; }
... when != \(x=E\|x--\|x++\|--x\|++x\|x-=E\|x+=E\|x|=E\|x&=E\|&x\)
(
*x == NULL
|
*x != NULL
)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/atm/solos-pci.c             |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/atm/solos-pci.c b/drivers/atm/solos-pci.c
index 9359613..307321b 100644
--- a/drivers/atm/solos-pci.c
+++ b/drivers/atm/solos-pci.c
@@ -372,7 +372,7 @@ static int process_status(struct solos_card *card, int port, struct sk_buff *skb
 	}
 
 	snr = next_string(skb);
-	if (!str)
+	if (!snr)
 		return -EIO;
 	attn = next_string(skb);
 	if (!attn)
