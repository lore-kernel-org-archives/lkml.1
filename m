Return-Path: <linux-kernel-owner+w=401wt.eu-S1751237AbZL0V07@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751237AbZL0V07 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Dec 2009 16:26:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751137AbZL0V06
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Dec 2009 16:26:58 -0500
Received: from mgw1.diku.dk ([130.225.96.91]:47748 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750947AbZL0V05 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Dec 2009 16:26:57 -0500
Date: Sun, 27 Dec 2009 22:26:54 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: linux@arm.linux.org.uk, linux-arm-kernel@lists.infradead.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 1/5] arch/arm: Correct NULL test
Message-ID: <Pine.LNX.4.64.0912272226360.20548@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Test the just-allocated value for NULL rather than some other value.

The semantic patch that makes this change is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
expression x,y;
statement S;
@@

x = \(kmalloc\|kcalloc\|kzalloc\)(...);
(
if ((x) == NULL) S
|
if (
-   y
+   x
       == NULL)
 S
)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 arch/arm/plat-pxa/dma.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -u -p a/arch/arm/plat-pxa/dma.c b/arch/arm/plat-pxa/dma.c
--- a/arch/arm/plat-pxa/dma.c
+++ b/arch/arm/plat-pxa/dma.c
@@ -244,7 +244,7 @@ static void pxa_dma_init_debugfs(void)
 
 	dbgfs_chan = kmalloc(sizeof(*dbgfs_state) * num_dma_channels,
 			     GFP_KERNEL);
-	if (!dbgfs_state)
+	if (!dbgfs_chan)
 		goto err_alloc;
 
 	chandir = debugfs_create_dir("channels", dbgfs_root);
