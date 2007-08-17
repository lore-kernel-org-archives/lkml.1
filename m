Return-Path: <linux-kernel-owner+w=401wt.eu-S1761007AbXHQAk3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761007AbXHQAk3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 20:40:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750850AbXHQAkU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 20:40:20 -0400
Received: from ns.suse.de ([195.135.220.2]:38880 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750764AbXHQAkS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 20:40:18 -0400
From: Neil Brown <neilb@suse.de>
To: Jens Axboe <jens.axboe@oracle.com>
Date: Fri, 17 Aug 2007 10:40:11 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18116.61035.621593.588647@notabene.brown>
Cc: linux-kernel@vger.kernel.org, Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH 000 of 6] A few block-layer tidy-up patches.
In-Reply-To: message from Jens Axboe on Thursday August 16
References: <20070816211551.11839.patches@notabene>
	<20070816113638.GX23758@kernel.dk>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday August 16, jens.axboe@oracle.com wrote:
> On Thu, Aug 16 2007, NeilBrown wrote:
> > Following are 5 patches which - I think - clean up various bits and pieces
> > in the block layer.
> > 
> > The only part that might be seen as a function change rather than
> > simply rearranging code is in ps3disk where bvec_kmap_irq is used
> > instead of bio_kmap_atomic (so interrupts are disabled).
> > 
> > The only other user of bvec_kmap_irq is ide-floppy.c.  If that does
> > need to disable interrupts, and ps3disk doesn't, make the disabling of
> > interrupts should be separated from the kmapping??
> 
> Applied 1-6, thanks! BTW, your patch #2 doesn't apply cleanly on
> floppy.c in current -git, and there has been no changes there since July
> 24th. So you must be diffing against something else?

Yes, current -mm.  That is where I usually work.  I'll make sure
future patches are against -linus or -block.

> 
> You also don't re-indent and remove one nesting when removing
> bio_for_each_segment(). It makes it easier to review, but I formatted
> that as well since I had to hand-apply patch #2.

I meant to mention that in the changelog comment.  I deliberately
didn't re-indent most of the loops to ease review.  I was going to
send an indent-only patch it the first was accepted.  No need now :-)

> 
> Please inspect the #block-2.6.24 branch to see the result.

I don't know where to look for this.  I checked
  http://git.kernel.org/?p=linux/kernel/git/axboe/linux-2.6-block.git
but they don't seem to be there.
??

Thanks,
NeilBrown
