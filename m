Return-Path: <linux-kernel-owner+w=401wt.eu-S1754786AbXJFFmq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754786AbXJFFmq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2007 01:42:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751251AbXJFFmi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Oct 2007 01:42:38 -0400
Received: from stout.engsoc.carleton.ca ([134.117.69.22]:57832 "EHLO
	stout.engsoc.carleton.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750711AbXJFFmh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2007 01:42:37 -0400
Date: Sat, 6 Oct 2007 01:42:34 -0400
From: Kyle McMartin <kyle@mcmartin.ca>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: dri-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       airlied@linux.ie, arashi@sacredchao.net
Subject: Revert "intel_agp: fix stolen mem range on G33"
Message-ID: <20071006054234.GC14767@fattire.cabal.ca>
References: <4706D4B1.6050101@sacredchao.net> <20071006044221.GA14767@fattire.cabal.ca> <20071006053410.GB14767@fattire.cabal.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071006053410.GB14767@fattire.cabal.ca>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This reverts commit f443675affe3f16dd428e46f0f7fd3f4d703eeab, which
breaks horribly if you aren't running an unreleased xf86-video-intel
driver out of git.

Conflicts:

	drivers/char/agp/intel-agp.c

Signed-off-by: Kyle McMartin <kyle@mcmartin.ca>
---

 drivers/char/agp/intel-agp.c |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/drivers/char/agp/intel-agp.c b/drivers/char/agp/intel-agp.c
index a5d0e95..141ca17 100644
--- a/drivers/char/agp/intel-agp.c
+++ b/drivers/char/agp/intel-agp.c
@@ -506,11 +506,6 @@ static void intel_i830_init_gtt_entries(void)
 			break;
 		}
 	} else {
-		/* G33's GTT stolen memory is separate from gfx data
-		 * stolen memory.
-		 */
-		if (IS_G33)
-			size = 0;
 		switch (gmch_ctrl & I855_GMCH_GMS_MASK) {
 		case I855_GMCH_GMS_STOLEN_1M:
 			gtt_entries = MB(1) - KB(size);
-- 
1.5.3.3

On Sat, Oct 06, 2007 at 01:34:10AM -0400, Kyle McMartin wrote:
> On Sat, Oct 06, 2007 at 12:42:21AM -0400, Kyle McMartin wrote:
> > commit f443675affe3f16dd428e46f0f7fd3f4d703eeab
> >     intel_agp: fix stolen mem range on G33
> >     G33 GTT stolen memory is below graphics data stolen memory and be seperate,
> >     so don't subtract it in stolen mem counting.
> >     
> 
> Found it, without this corresponding change to xf86-video-intel, this
> breaks utterly:
> 
> commit 2a8592f2ebcba86b1127aa889155d58a3dc186ca
> Author: Zhenyu Wang <zhenyu.z.wang@intel.com>
> Date:   Wed Sep 5 14:52:56 2007 +0800
> 
>     Fix G33 GTT stolen mem range
>     
>     G33 GTT table lives in seperate stolen mem with
>     graphics data stolen mem.
> 
> I think this should be reverted for 2.6.23, it certainly doesn't seem to have
> been appropriate for 2.6.23-rc6.
> 
> Cheers,
> 	Kyle M.
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
