Return-Path: <linux-kernel-owner+w=401wt.eu-S1760128AbZDAMZV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760128AbZDAMZV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 08:25:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764058AbZDAMYi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 08:24:38 -0400
Received: from brick.kernel.dk ([93.163.65.50]:54312 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764072AbZDAMYh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 08:24:37 -0400
Date: Wed, 1 Apr 2009 14:24:35 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: tj@kernel.org, bharrosh@panasas.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/8] block: fix SG_IO vector request data length
	handling
Message-ID: <20090401122434.GE5178@kernel.dk>
References: <1238583884-13517-3-git-send-email-tj@kernel.org> <20090401204716N.fujita.tomonori@lab.ntt.co.jp> <20090401115058.GD5178@kernel.dk> <20090401211851Y.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090401211851Y.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 01 2009, FUJITA Tomonori wrote:
> On Wed, 1 Apr 2009 13:50:58 +0200
> Jens Axboe <jens.axboe@oracle.com> wrote:
> 
> > On Wed, Apr 01 2009, FUJITA Tomonori wrote:
> > > On Wed,  1 Apr 2009 20:04:38 +0900
> > > Tejun Heo <tj@kernel.org> wrote:
> > > 
> > > > Impact: fix SG_IO behavior such that it matches the documentation
> > > > 
> > > > SG_IO howto says that if ->dxfer_len and sum of iovec disagress, the
> > > > shorter one wins.  However, the current implementation returns -EINVAL
> > > > for such cases.  Trim iovc if it's longer than ->dxfer_len.
> > > 
> > > Is that description about sg's SG_IO?
> > 
> > The more important question is what sg.c actually does, that's more
> > important than the documentation.
> 
> Do you think that Doug is a person who makes such mistake? ;)
> 
> Seems that sg worked as the howto says. But I think that I broke it
> when I converted sg to use the block layer. I'll fix it soon.

OK

> About this patch, as we know, there are lots of subtle differences
> between sg's SG_IO and the block's. I'm not sure that it's a good idea
> to change the behavior of the block's SG_IO.

Depends on what it is. For something like this where the alternative is
returning -EINVAL and the patch makes it work, we definitely should just
do it.

-- 
Jens Axboe

