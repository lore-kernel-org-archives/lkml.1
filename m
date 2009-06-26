Return-Path: <linux-kernel-owner+w=401wt.eu-S1751900AbZFZEjn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751900AbZFZEjn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 00:39:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750892AbZFZEjf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 00:39:35 -0400
Received: from brick.kernel.dk ([93.163.65.50]:57300 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750839AbZFZEjf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 00:39:35 -0400
Date: Fri, 26 Jun 2009 06:39:37 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: NeilBrown <neilb@suse.de>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: linux-next: block tree build failure
Message-ID: <20090626043937.GJ31415@kernel.dk>
References: <20090626125331.89c689f2.sfr@canb.auug.org.au> <f236aae1aa8ea7c4f3700dbca2f3ae14.squirrel@neil.brown.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f236aae1aa8ea7c4f3700dbca2f3ae14.squirrel@neil.brown.name>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 26 2009, NeilBrown wrote:
> On Fri, June 26, 2009 12:53 pm, Stephen Rothwell wrote:
> > Hi Jens,
> >
> > Today's linux-next build (powerpc ppc64_defconfig) failed like this:
> >
> > block/blk-core.c: In function '__make_request':
> > block/blk-core.c:1179: error: expected ';' before 'return'
> >
> > Caused by commit 6cf2a6c8d01514e86a8d38e4eeed402378b635dc ("Restore
> > barrier support for md and probably other virtual devices") which I have
> > reverted for today.
> 
> Arg, that's my fault - sorry.
> 
> +               bio_endio(bio, -EOPNOTSUPP)
> +                       return 0;
> 
> should of course be
> 
> +               bio_endio(bio, -EOPNOTSUPP);
> +               return 0;

I was certain I ran it through a compile cycle, sorry about that
Stephen. And Neil sending uncompiled patches, very uncool. Did you even
test it? I've pulled it for now.

-- 
Jens Axboe

