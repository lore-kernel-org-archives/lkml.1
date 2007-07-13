Return-Path: <linux-kernel-owner+w=401wt.eu-S936746AbXGMSST@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936746AbXGMSST (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 14:18:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760278AbXGMSSJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 14:18:09 -0400
Received: from brick.kernel.dk ([80.160.20.94]:2235 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759667AbXGMSSG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 14:18:06 -0400
Date: Fri, 13 Jul 2007 20:17:48 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Gabriel C <nix.or.die@googlemail.com>,
       linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: On current git head webservers stopped working
Message-ID: <20070713181747.GX5328@kernel.dk>
References: <469745A8.6010005@googlemail.com> <20070713093459.GB5328@kernel.dk> <alpine.LFD.0.999.0707131025550.20061@woody.linux-foundation.org> <20070713173949.GW5328@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070713173949.GW5328@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 13 2007, Jens Axboe wrote:
> On Fri, Jul 13 2007, Linus Torvalds wrote:
> > 
> > 
> > On Fri, 13 Jul 2007, Jens Axboe wrote:
> > > 
> > > Does this work?
> > 
> > Ok, so it apparently works, but:
> > 
> > > diff --git a/fs/splice.c b/fs/splice.c
> > > index ed2ce99..92646aa 100644
> > > --- a/fs/splice.c
> > > +++ b/fs/splice.c
> > > @@ -491,7 +491,7 @@ ssize_t generic_file_splice_read(struct file *in, loff_t *ppos,
> > >  
> > >  	ret = 0;
> > >  	spliced = 0;
> > > -	while (len) {
> > > +	while (len && !spliced) {
> > >  		ret = __generic_file_splice_read(in, ppos, pipe, len, flags);
> > 
> > This hunk basically make sthe whole "while" loop pointless. You'll never 
> > go through it more than once.
> > 
> > So at that point, maybe the loop should be removed entirely? Or maybe this 
> > part of the patch is wrong, and the fix was in the _other_ parts?
> 
> It'll likely work without that hunk, and you are right - the loop
> should just go now. I'll update that piece in a sub sequent patch!

Oh btw, forgot to mention - that hunk isn't wrong, it's just not the fix
for that particular bug. In reality it should probably have been part of
a different patch dropping that loop as well... Anyway, I'll do that
patch and indicate as such in the changelog for that commit.

-- 
Jens Axboe

