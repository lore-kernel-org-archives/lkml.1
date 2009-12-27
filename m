Return-Path: <linux-kernel-owner+w=401wt.eu-S1751383AbZL0WZ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751383AbZL0WZ4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Dec 2009 17:25:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751197AbZL0WZz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Dec 2009 17:25:55 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:38641 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751004AbZL0WZy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Dec 2009 17:25:54 -0500
Date: Sun, 27 Dec 2009 23:25:52 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: linux@arm.linux.org.uk, linux-arm-kernel@lists.infradead.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 1/5] arch/arm: Correct NULL test
In-Reply-To: <20091227215106.GA18317@pengutronix.de>
Message-ID: <Pine.LNX.4.64.0912272325130.22240@ask.diku.dk>
References: <Pine.LNX.4.64.0912272226360.20548@ask.diku.dk>
 <20091227215106.GA18317@pengutronix.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Test the just-allocated value for NULL rather than some other value.
Adjust the size of the allocated array as well, according to the location
storing the result.

The semantic patch that makes the first change is as follows:
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
 arch/arm/plat-pxa/dma.c             |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/plat-pxa/dma.c b/arch/arm/plat-pxa/dma.c
index 2975798..fb28dc9 100644
--- a/arch/arm/plat-pxa/dma.c
+++ b/arch/arm/plat-pxa/dma.c
@@ -242,9 +242,9 @@ static void pxa_dma_init_debugfs(void)
 	if (!dbgfs_state)
 		goto err_state;
 
-	dbgfs_chan = kmalloc(sizeof(*dbgfs_state) * num_dma_channels,
+	dbgfs_chan = kmalloc(sizeof(*dbgfs_chan) * num_dma_channels,
 			     GFP_KERNEL);
-	if (!dbgfs_state)
+	if (!dbgfs_chan)
 		goto err_alloc;
 
 	chandir = debugfs_create_dir("channels", dbgfs_root);
