Return-Path: <linux-kernel-owner+w=401wt.eu-S1764704AbXHPLgz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764704AbXHPLgz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 07:36:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750822AbXHPLgn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 07:36:43 -0400
Received: from brick.kernel.dk ([87.55.233.238]:13747 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750796AbXHPLgm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 07:36:42 -0400
Date: Thu, 16 Aug 2007 13:36:38 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: NeilBrown <neilb@suse.de>
Cc: linux-kernel@vger.kernel.org, Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH 000 of 6] A few block-layer tidy-up patches.
Message-ID: <20070816113638.GX23758@kernel.dk>
References: <20070816211551.11839.patches@notabene>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070816211551.11839.patches@notabene>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 16 2007, NeilBrown wrote:
> Following are 5 patches which - I think - clean up various bits and pieces
> in the block layer.
> 
> The only part that might be seen as a function change rather than
> simply rearranging code is in ps3disk where bvec_kmap_irq is used
> instead of bio_kmap_atomic (so interrupts are disabled).
> 
> The only other user of bvec_kmap_irq is ide-floppy.c.  If that does
> need to disable interrupts, and ps3disk doesn't, make the disabling of
> interrupts should be separated from the kmapping??

Applied 1-6, thanks! BTW, your patch #2 doesn't apply cleanly on
floppy.c in current -git, and there has been no changes there since July
24th. So you must be diffing against something else?

You also don't re-indent and remove one nesting when removing
bio_for_each_segment(). It makes it easier to review, but I formatted
that as well since I had to hand-apply patch #2.

Please inspect the #block-2.6.24 branch to see the result.

-- 
Jens Axboe

