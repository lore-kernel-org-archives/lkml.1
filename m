Return-Path: <linux-kernel-owner+w=401wt.eu-S1758149AbYLMPiT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758149AbYLMPiT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Dec 2008 10:38:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752859AbYLMPiG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Dec 2008 10:38:06 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:50252 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751119AbYLMPiE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Dec 2008 10:38:04 -0500
Date: Sat, 13 Dec 2008 16:37:59 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: rmk@arm.linux.org.uk, linux-arm-kernel@lists.arm.linux.org.uk,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH] arch/arm/common/sa1111.c: Correct error handling code
Message-ID: <Pine.LNX.4.64.0812131637330.20442@pc-004.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

If it is reasonable to apply PTR_ERR to the result of calling clk_get, then
that result should first be tested with IS_ERR, not with !.

The semantic patch that makes this change is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@@
expression E,E1;
@@

if (
-   E == NULL
+   IS_ERR(E)
   ) { <+... when != E = E1
        PTR_ERR(E)
       ...+> }
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 arch/arm/common/sa1111.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -u -p a/arch/arm/common/sa1111.c b/arch/arm/common/sa1111.c
--- a/arch/arm/common/sa1111.c
+++ b/arch/arm/common/sa1111.c
@@ -630,7 +630,7 @@ __sa1111_probe(struct device *me, struct
 		return -ENOMEM;
 
 	sachip->clk = clk_get(me, "SA1111_CLK");
-	if (!sachip->clk) {
+	if (IS_ERR(sachip->clk)) {
 		ret = PTR_ERR(sachip->clk);
 		goto err_free;
 	}
