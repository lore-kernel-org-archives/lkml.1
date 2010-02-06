Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755021Ab0BFIpE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Feb 2010 03:45:04 -0500
Received: from mgw1.diku.dk ([130.225.96.91]:52545 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754507Ab0BFIpA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Feb 2010 03:45:00 -0500
Date: Sat, 6 Feb 2010 09:44:58 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 10/11] drivers/video/mbx: Correct NULL test
Message-ID: <Pine.LNX.4.64.1002060944400.8092@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Test the value that was just allocated rather than the previously tested one.

A simplified version of the semantic match that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@r@
expression *x;
expression e;
identifier l;
@@

if (x == NULL || ...) {
    ... when forall
    return ...; }
... when != goto l;
    when != x = e
    when != &x
*x == NULL
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/video/mbx/mbxfb.c           |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/video/mbx/mbxfb.c b/drivers/video/mbx/mbxfb.c
index afea9ab..7140405 100644
--- a/drivers/video/mbx/mbxfb.c
+++ b/drivers/video/mbx/mbxfb.c
@@ -950,7 +950,7 @@ static int __devinit mbxfb_probe(struct platform_device *dev)
 
 	mfbi->fb_virt_addr = ioremap_nocache(mfbi->fb_phys_addr,
 					     res_size(mfbi->fb_req));
-	if (!mfbi->reg_virt_addr) {
+	if (!mfbi->fb_virt_addr) {
 		dev_err(&dev->dev, "failed to ioremap frame buffer\n");
 		ret = -EINVAL;
 		goto err4;
