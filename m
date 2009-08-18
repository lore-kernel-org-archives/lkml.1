Return-Path: <linux-kernel-owner+w=401wt.eu-S1757775AbZHRIuv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757775AbZHRIuv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 04:50:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752971AbZHRIuv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 04:50:51 -0400
Received: from brick.kernel.dk ([93.163.65.50]:33028 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751474AbZHRIuu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 04:50:50 -0400
Date: Tue, 18 Aug 2009 10:50:51 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Willy Tarreau <w@1wt.eu>
Cc: Miklos Szeredi <miklos@szeredi.hu>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] splice: update mtime and atime on files
Message-ID: <20090818085051.GM12579@kernel.dk>
References: <E1MbyLM-0006Xd-OE@pomaz-ex.szeredi.hu> <20090815064241.GE12579@kernel.dk> <20090818050027.GE11624@1wt.eu> <20090818083547.GK12579@kernel.dk> <20090818084625.GF18709@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090818084625.GF18709@1wt.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 18 2009, Willy Tarreau wrote:
> On Tue, Aug 18, 2009 at 10:35:48AM +0200, Jens Axboe wrote:
> > On Tue, Aug 18 2009, Willy Tarreau wrote:
> > > On Sat, Aug 15, 2009 at 08:42:41AM +0200, Jens Axboe wrote:
> > > > On Fri, Aug 14 2009, Miklos Szeredi wrote:
> > > > > From: Miklos Szeredi <mszeredi@suse.cz>
> > > > > 
> > > > > Splice should update the modification and access times on regular
> > > > > files just like read and write.  Not updating mtime will confuse
> > > > > backup tools, etc...
> > > > > 
> > > > > This patch only adds the time updates for regular files.  For pipes
> > > > > and other special files that splice touches the need for updating the
> > > > > times is less clear.  Let's discuss and fix that separately.
> > > > 
> > > > Thanks Miklos, I've queued this one up.
> > > 
> > > wouldn't it make sense to send that to stable too ? The patch is not
> > > intrusive and looks like a fix to me.
> > 
> > It doesn't really meet the stable criteria, as it's not a security issue
> > nor does it crash the kernel.
> 
> Oh there are many other things which go to stable, especially bug

I'm aware of that, doesn't mean it's what the rules describe or that
it's necessarily a good idea :-)

> fixes and minor improvements. We *could* classify this in the bug
> fixes as, I Miklos suggested it, this could have an impact on
> modified files which would currently not be backed up for instance.

I've never heard anyone complain about this, and I suspect that Miklos
found it from code inspection rather than experiencing an issue with it.
So while it can indeed be classified as a bug (and it is), the impact is
not huge.

That said, I don't have a huge issue with shoving this in -stable. I
just don't think it's a big deal.

-- 
Jens Axboe

