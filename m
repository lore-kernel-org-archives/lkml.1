Return-Path: <linux-kernel-owner+w=401wt.eu-S1757105AbZCNT4S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757105AbZCNT4S (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Mar 2009 15:56:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754412AbZCNT4K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Mar 2009 15:56:10 -0400
Received: from accolon.hansenpartnership.com ([76.243.235.52]:57710 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753999AbZCNT4J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Mar 2009 15:56:09 -0400
Subject: Re: [PATCH 11/14] block: implement and use
	[__]blk_end_request_all()
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Tejun Heo <tj@kernel.org>, axboe@kernel.dk, linux-kernel@vger.kernel.org,
       Russell King <rmk@arm.linux.org.uk>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Mike Miller <mike.miller@hp.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Jeff Garzik <jgarzik@pobox.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Jeremy Fitzhardinge <jeremy@xensource.com>,
       Alex Dubov <oakad@yahoo.com>
In-Reply-To: <200903142023.14747.bzolnier@gmail.com>
References: <1236920578-2179-1-git-send-email-tj@kernel.org>
	 <200903132021.55921.bzolnier@gmail.com> <49BB0ECB.6090003@kernel.org>
	 <200903142023.14747.bzolnier@gmail.com>
Content-Type: text/plain
Date: Sat, 14 Mar 2009 14:56:00 -0500
Message-Id: <1237060560.3907.57.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-03-14 at 20:23 +0100, Bartlomiej Zolnierkiewicz wrote:
> > > More generic comment follows -> this patch is guaranteed to clash
> > > with at least linux-next/pata-2.6 tree so why not introduce block
> > > layer helpers now, then push all driver updates through respective
> > > driver maintainers and deal with end_request() later (after all
> > > driver updates are in-tree)?
> > 
> > Most of the lld changes being trivial, I was hoping to push things
> > through blk tree, but IDE seems to be the most intertwined with the
> > block layer and it's likely to see quite some amount of not-so-trivial
> > changes to subtle paths.  How about pushing !IDE parts into blk tree
> > and pulling blk into pata-2.6, make IDE related changes there and
> > pulling back into blk tree so that further progresses can be made?
> 
> There is a "tiny" problem with this -- pata-2.6 is a quilt tree based on
> Linus' tree and it is not going to change for now (for various reasons).

Actually this one's easily solvable if you base the quilt on the block
tree (just specify it to linux-next in the BASE directive and it will do
the right thing).

What I'd do is actually run two quilts: one based on vanilla and one
based on block and only add block dependent patches to the latter.  This
is like running a postmerge git tree (you can only send a pull request
for it after block goes in).

James


