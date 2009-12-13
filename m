Return-Path: <linux-kernel-owner+w=401wt.eu-S1752619AbZLMLko@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752619AbZLMLko (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 06:40:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752565AbZLMLkn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 06:40:43 -0500
Received: from mgw1.diku.dk ([130.225.96.91]:34118 "HELO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752579AbZLMLkm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 06:40:42 -0500
Date: Sun, 13 Dec 2009 12:40:39 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: ralf@linux-mips.org, linux-mips@linux-mips.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 1/9] arch/mips/alchemy: Correct code taking the size of a
 pointer
Message-ID: <Pine.LNX.4.64.0912131240100.24267@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

sizeof(dp) is just the size of the pointer.  Change it to the size of the
referenced structure.

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
 arch/mips/alchemy/common/dbdma.c    |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/mips/alchemy/common/dbdma.c b/arch/mips/alchemy/common/dbdma.c
index 4851308..40071bd 100644
--- a/arch/mips/alchemy/common/dbdma.c
+++ b/arch/mips/alchemy/common/dbdma.c
@@ -612,7 +612,7 @@ u32 au1xxx_dbdma_put_source(u32 chanid, dma_addr_t buf, int nbytes, u32 flags)
 	dma_cache_wback_inv((unsigned long)buf, nbytes);
 	dp->dscr_cmd0 |= DSCR_CMD0_V;	/* Let it rip */
 	au_sync();
-	dma_cache_wback_inv((unsigned long)dp, sizeof(dp));
+	dma_cache_wback_inv((unsigned long)dp, sizeof(*dp));
 	ctp->chan_ptr->ddma_dbell = 0;
 
 	/* Get next descriptor pointer.	*/
@@ -674,7 +674,7 @@ u32 au1xxx_dbdma_put_dest(u32 chanid, dma_addr_t buf, int nbytes, u32 flags)
 	dma_cache_inv((unsigned long)buf, nbytes);
 	dp->dscr_cmd0 |= DSCR_CMD0_V;	/* Let it rip */
 	au_sync();
-	dma_cache_wback_inv((unsigned long)dp, sizeof(dp));
+	dma_cache_wback_inv((unsigned long)dp, sizeof(*dp));
 	ctp->chan_ptr->ddma_dbell = 0;
 
 	/* Get next descriptor pointer.	*/
