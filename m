Return-Path: <linux-kernel-owner+w=401wt.eu-S1752853AbXCSJVu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752853AbXCSJVu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 05:21:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752848AbXCSJVu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 05:21:50 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:34808 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752620AbXCSJVt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 05:21:49 -0400
Date: Mon, 19 Mar 2007 10:21:51 +0100
From: Adrian Bunk <bunk@stusta.de>
To: Pierre Ossman <drzeus-mmc@drzeus.cx>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [-mm patch] remove mmc_deselect_cards()
Message-ID: <20070319092151.GE752@stusta.de>
References: <20070306004408.d3f6434d.akpm@linux-foundation.org> <20070307224111.GD3441@stusta.de> <45EFA384.5050509@drzeus.cx>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <45EFA384.5050509@drzeus.cx>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 08, 2007 at 06:47:48AM +0100, Pierre Ossman wrote:
> Adrian Bunk wrote:
> > On Tue, Mar 06, 2007 at 12:44:08AM -0800, Andrew Morton wrote:
> >> ...
> >> Changes since 2.6.20-rc2-mm1:
> >> ...
> >>  git-mmc.patch
> >> ...
> >>  git trees
> >> ...
> > 
> > mmc_deselect_cards() is no longer used.
> > 
> > Signed-off-by: Adrian Bunk <bunk@stusta.de>
> > 
> 
> Indeed, but it's probably better to just remove it rather than have old crud
> lying around.
> 
> Rgds

Updated patch below.

cu
Adrian


<--  snip  -->


mmc_deselect_cards() is no longer used.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---

 drivers/mmc/core/mmc_ops.c |    5 -----
 drivers/mmc/core/mmc_ops.h |    1 -
 2 files changed, 6 deletions(-)

--- linux-2.6.21-rc3-mm2/drivers/mmc/core/mmc_ops.h.old	2007-03-09 09:01:13.000000000 +0100
+++ linux-2.6.21-rc3-mm2/drivers/mmc/core/mmc_ops.h	2007-03-09 09:01:18.000000000 +0100
@@ -13,7 +13,6 @@
 #define _MMC_MMC_OPS_H
 
 int mmc_select_card(struct mmc_card *card);
-int mmc_deselect_cards(struct mmc_host *host);
 int mmc_go_idle(struct mmc_host *host);
 int mmc_send_op_cond(struct mmc_host *host, u32 ocr, u32 *rocr);
 int mmc_all_send_cid(struct mmc_host *host, u32 *cid);
--- linux-2.6.21-rc3-mm2/drivers/mmc/core/mmc_ops.c.old	2007-03-09 09:01:24.000000000 +0100
+++ linux-2.6.21-rc3-mm2/drivers/mmc/core/mmc_ops.c	2007-03-09 09:01:34.000000000 +0100
@@ -53,11 +53,6 @@
 	return _mmc_select_card(card->host, card);
 }
 
-int mmc_deselect_cards(struct mmc_host *host)
-{
-	return _mmc_select_card(host, NULL);
-}
-
 int mmc_go_idle(struct mmc_host *host)
 {
 	int err;

