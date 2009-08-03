Return-Path: <linux-kernel-owner+w=401wt.eu-S1754603AbZHCT3l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754603AbZHCT3l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 15:29:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754235AbZHCT3l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 15:29:41 -0400
Received: from smtp-115-monday.nerim.net ([62.4.16.115]:55230 "EHLO
	maiev.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754202AbZHCT3k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 15:29:40 -0400
Date: Mon, 3 Aug 2009 21:29:39 +0200
From: Damien Wyart <damien.wyart@free.fr>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       chris.mason@oracle.com, david@fromorbit.com, hch@infradead.org,
       akpm@linux-foundation.org, jack@suse.cz, yanmin_zhang@linux.intel.com,
       richard@rsk.demon.co.uk, fweisbec@gmail.com, Alan.Brunelle@hp.com
Subject: Re: [PATCH 0/9] Per-bdi writeback flusher threads v13
Message-ID: <20090803192939.GA9524@brouette>
References: <1248989044-21605-1-git-send-email-jens.axboe@oracle.com>
 <20090731063008.GA2796@brouette>
 <20090731071518.GN12579@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090731071518.GN12579@kernel.dk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > fs/sync.c has changed some time ago and I think your patch needs this
> > (which I had lazyly added by hand in v12 without telling):

> > --- a/fs/sync.c	2009-07-31 07:32:08.927926281 +0200
> > +++ b/fs/sync.c	2009-07-31 07:31:52.499801359 +0200
> > @@ -118,7 +118,7 @@ restart:
> >   */
> >  SYSCALL_DEFINE0(sync)
> >  {
> > -	wakeup_pdflush(0);
> > +	wakeup_flusher_threads(0);
> >  	sync_filesystems(0);
> >  	sync_filesystems(1);
> >  	if (unlikely(laptop_mode))

* Jens Axboe <jens.axboe@oracle.com> [2009-07-31 09:15]:
> Argh, I had fixed that long ago, but a branch problem yesterday caused
> it to be lost just before posting. How annoying. Thanks for the hint,
> I'll update the v13 branch and patch.

Mmm. I wanted to test v13 on another machine and re-downloaded the patch
this morning (Paris time) but it seems completly wrong. It applied
cleany but I did not even try to compile as the files changed seemed
completely unrelated to per-bdi writeback. I guess there has been an
error in generating it.

Best,
-- 
Damien Wyart
