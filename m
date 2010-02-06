Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753582Ab0BFImG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Feb 2010 03:42:06 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:35718 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751226Ab0BFImE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Feb 2010 03:42:04 -0500
Date: Sat, 6 Feb 2010 09:42:00 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: Russell King <linux@arm.linux.org.uk>,
       linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 1/11] arch/arm/plat-pxa: Correct NULL test
Message-ID: <Pine.LNX.4.64.1002060941410.8092@ask.diku.dk>
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
 arch/arm/plat-pxa/dma.c             |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/arm/plat-pxa/dma.c b/arch/arm/plat-pxa/dma.c
index 2975798..bcfda50 100644
--- a/arch/arm/plat-pxa/dma.c
+++ b/arch/arm/plat-pxa/dma.c
@@ -244,7 +244,7 @@ static void pxa_dma_init_debugfs(void)
 
 	dbgfs_chan = kmalloc(sizeof(*dbgfs_state) * num_dma_channels,
 			     GFP_KERNEL);
-	if (!dbgfs_state)
+	if (!dbgfs_chan)
 		goto err_alloc;
 
 	chandir = debugfs_create_dir("channels", dbgfs_root);
