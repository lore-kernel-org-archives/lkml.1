Return-Path: <linux-kernel-owner+w=401wt.eu-S1758582AbZJEHaJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758582AbZJEHaJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 03:30:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758532AbZJEHaI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 03:30:08 -0400
Received: from brick.kernel.dk ([93.163.65.50]:48728 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758475AbZJEHaG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 03:30:06 -0400
Date: Mon, 5 Oct 2009 09:29:29 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Philipp Reisner <philipp.reisner@linbit.com>, drbd-dev@linbit.com
Subject: Re: linux-next: block/drbd tree build failure
Message-ID: <20091005072929.GS26573@kernel.dk>
References: <20091005143552.977a2d4d.sfr@canb.auug.org.au> <20091005063138.GO26573@kernel.dk> <20091005182103.0a391d15.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091005182103.0a391d15.sfr@canb.auug.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 05 2009, Stephen Rothwell wrote:
> Hi Jens,
> 
> On Mon, 5 Oct 2009 08:31:38 +0200 Jens Axboe <jens.axboe@oracle.com> wrote:
> >
> > On Mon, Oct 05 2009, Stephen Rothwell wrote:
> > > 
> > > Today's linux-next build (x86_64 allmodconfig) failed like this:
> > > 
> > > drivers/block/drbd/drbd_req.c: In function '_drbd_start_io_acct':
> > > drivers/block/drbd/drbd_req.c:43: error: subscripted value is neither array nor pointer
> > > drivers/block/drbd/drbd_req.c: In function '_drbd_end_io_acct':
> > > drivers/block/drbd/drbd_req.c:56: error: subscripted value is neither array nor pointer
> > > 
> > > I reported a similar error against the dbd tree, which was fixed, but now
> > > the commit that caused that error has been reverted and thus we get
> > > this :-(
> > > 
> > > I have reverted the drbd commits from the block tree for today.
> > 
> > That's probably my fault, not drbd. I moved it to a new branch since it
> > isn't going into 2.6.32, and perhaps dropped that fix along the way.
> > I'll look into it.
> 
> The original problem was caused by commit
> a9327cac440be4d8333bba975cbbf76045096275 ("Seperate read and write
> statistics of in_flight requests") which went into Linus' tree on Sept
> 15.  The drbd tee was fixed to cope with that change.  Then that commit
> was reverted in Linus' tree on Oct 5, so the fix to the drbd tree needs
> to be reverted as well.  Unfortunately, the drbd tree has been rebased
> into (basically) one commit, so that commit needs fixing.

Ah indeed, thanks. I'll put a fixup patch in place.

-- 
Jens Axboe

