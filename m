Return-Path: <linux-kernel-owner+w=401wt.eu-S1753667AbZHCU2v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753667AbZHCU2v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 16:28:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753477AbZHCU2u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 16:28:50 -0400
Received: from brick.kernel.dk ([93.163.65.50]:51098 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752795AbZHCU2s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 16:28:48 -0400
Date: Mon, 3 Aug 2009 22:28:48 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Damien Wyart <damien.wyart@free.fr>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       chris.mason@oracle.com, david@fromorbit.com, hch@infradead.org,
       akpm@linux-foundation.org, jack@suse.cz, yanmin_zhang@linux.intel.com,
       richard@rsk.demon.co.uk, fweisbec@gmail.com, Alan.Brunelle@hp.com
Subject: Re: [PATCH 0/9] Per-bdi writeback flusher threads v13
Message-ID: <20090803202848.GS12579@kernel.dk>
References: <1248989044-21605-1-git-send-email-jens.axboe@oracle.com> <20090731063008.GA2796@brouette> <20090731071518.GN12579@kernel.dk> <20090803192939.GA9524@brouette>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090803192939.GA9524@brouette>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 03 2009, Damien Wyart wrote:
> > > fs/sync.c has changed some time ago and I think your patch needs this
> > > (which I had lazyly added by hand in v12 without telling):
> 
> > > --- a/fs/sync.c	2009-07-31 07:32:08.927926281 +0200
> > > +++ b/fs/sync.c	2009-07-31 07:31:52.499801359 +0200
> > > @@ -118,7 +118,7 @@ restart:
> > >   */
> > >  SYSCALL_DEFINE0(sync)
> > >  {
> > > -	wakeup_pdflush(0);
> > > +	wakeup_flusher_threads(0);
> > >  	sync_filesystems(0);
> > >  	sync_filesystems(1);
> > >  	if (unlikely(laptop_mode))
> 
> * Jens Axboe <jens.axboe@oracle.com> [2009-07-31 09:15]:
> > Argh, I had fixed that long ago, but a branch problem yesterday caused
> > it to be lost just before posting. How annoying. Thanks for the hint,
> > I'll update the v13 branch and patch.
> 
> Mmm. I wanted to test v13 on another machine and re-downloaded the patch
> this morning (Paris time) but it seems completly wrong. It applied
> cleany but I did not even try to compile as the files changed seemed
> completely unrelated to per-bdi writeback. I guess there has been an
> error in generating it.

Probably I diffed two wrong branches when updating the patch. I've
re-uploaded a newly generated diff.

-- 
Jens Axboe

