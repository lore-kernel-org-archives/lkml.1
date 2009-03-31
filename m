Return-Path: <linux-kernel-owner+w=401wt.eu-S1754132AbZCaLSb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754132AbZCaLSb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 07:18:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751220AbZCaLSV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 07:18:21 -0400
Received: from brick.kernel.dk ([93.163.65.50]:52354 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750991AbZCaLSV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 07:18:21 -0400
Date: Tue, 31 Mar 2009 13:18:18 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Tejun Heo <tj@kernel.org>
Cc: Theodore Tso <tytso@mit.edu>, Chris Mason <chris.mason@oracle.com>,
       Fernando Luis =?iso-8859-1?Q?V=E1zquez?= Cao 
	<fernando@oss.ntt.co.jp>,
       Jeff Garzik <jeff@garzik.org>, Christoph Hellwig <hch@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       david@fromorbit.com
Subject: Re: [PATCH 2/7] ext3: call blkdev_issue_flush() on fsync()
Message-ID: <20090331111818.GL5178@kernel.dk>
References: <49D01F94.6000101@oss.ntt.co.jp> <49D02328.7060108@oss.ntt.co.jp> <49D0258A.9020306@garzik.org> <49D03377.1040909@oss.ntt.co.jp> <49D0B535.2010106@oss.ntt.co.jp> <49D0B70E.8060506@oss.ntt.co.jp> <20090330140427.GG13356@mit.edu> <1238422551.30488.47.camel@think.oraclecorp.com> <20090330143343.GJ13356@mit.edu> <49D17162.1090207@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49D17162.1090207@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 31 2009, Tejun Heo wrote:
> Hello,
> 
> Theodore Tso wrote:
> > On Mon, Mar 30, 2009 at 10:15:51AM -0400, Chris Mason wrote:
> >> I'm not sure we want to stick Fernando with changing how barriers are
> >> done in individual filesystems, his patch is just changing the existing
> >> call points.
> > 
> > Well, his patch actually added some calls to block_issue_flush().  But
> > yes, it's probably better if he just changes the existing call points,
> > and we can have the relevant filesystem maintainers double check to
> > make sure that there aren't any new call points which are needed.
> 
> How about having something like blk_ensure_cache_flushed() which
> issues flush iff there hasn't been any write since the last flush?
> It'll be easy to implement and will filter out duplicate flushes in
> most cases.

My original ide implementation of flushes actually did this. My memory
is a little hazy on why it was dropped, I'm guessing because it
basically never triggered anyway.

-- 
Jens Axboe

