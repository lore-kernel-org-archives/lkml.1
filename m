Return-Path: <linux-kernel-owner+w=401wt.eu-S1754999AbZCORkg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754999AbZCORkg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Mar 2009 13:40:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752747AbZCORk1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Mar 2009 13:40:27 -0400
Received: from fk-out-0910.google.com ([209.85.128.187]:37361 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751648AbZCORk0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Mar 2009 13:40:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=UsfgqXkg7UaZIbSYXWouw11iCzp6GzeswgEswKuK++TQjAf08xL6Njt8jutUxyFgZ1
         +Vvig9RSZ4N2izXC1Tlo9jE05+90N/mgxjzeXbS8E9vOr3TC7tCMqSTzBRjKrhWyOzvJ
         Qk0IfakxkGg1HrkMq+xO7QEuv01bpbQRQk1b0=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH 11/14] block: implement and use [__]blk_end_request_all()
Date: Sun, 15 Mar 2009 18:40:20 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc7-next-20090311; KDE/4.2.0; i686; ; )
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>,
       Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
       Russell King <rmk@arm.linux.org.uk>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Mike Miller <mike.miller@hp.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Jeff Garzik <jgarzik@pobox.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Jeremy Fitzhardinge <jeremy@xensource.com>,
       Alex Dubov <oakad@yahoo.com>
References: <1236920578-2179-1-git-send-email-tj@kernel.org> <200903142119.10056.bzolnier@gmail.com> <20090315164837.GE27476@kernel.dk>
In-Reply-To: <20090315164837.GE27476@kernel.dk>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200903151840.21087.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 15 March 2009, Jens Axboe wrote:
> On Sat, Mar 14 2009, Bartlomiej Zolnierkiewicz wrote:
> > On Saturday 14 March 2009, James Bottomley wrote:
> > > On Sat, 2009-03-14 at 20:23 +0100, Bartlomiej Zolnierkiewicz wrote:
> > > > > > More generic comment follows -> this patch is guaranteed to clash
> > > > > > with at least linux-next/pata-2.6 tree so why not introduce block
> > > > > > layer helpers now, then push all driver updates through respective
> > > > > > driver maintainers and deal with end_request() later (after all
> > > > > > driver updates are in-tree)?
> > > > > 
> > > > > Most of the lld changes being trivial, I was hoping to push things
> > > > > through blk tree, but IDE seems to be the most intertwined with the
> > > > > block layer and it's likely to see quite some amount of not-so-trivial
> > > > > changes to subtle paths.  How about pushing !IDE parts into blk tree
> > > > > and pulling blk into pata-2.6, make IDE related changes there and
> > > > > pulling back into blk tree so that further progresses can be made?
> > > > 
> > > > There is a "tiny" problem with this -- pata-2.6 is a quilt tree based on
> > > > Linus' tree and it is not going to change for now (for various reasons).
> > > 
> > > Actually this one's easily solvable if you base the quilt on the block
> > > tree (just specify it to linux-next in the BASE directive and it will do
> > > the right thing).
> > > 
> > > What I'd do is actually run two quilts: one based on vanilla and one
> > > based on block and only add block dependent patches to the latter.  This
> > > is like running a postmerge git tree (you can only send a pull request
> > > for it after block goes in).
> > 
> > Thanks for the hint but it sounds like a major pain once you hit some
> > changes touching the same code areas that block patches do...
> > 
> > Besides this is guaranteed to inrease the workload on my side so it
> > won't happen simply because of -ENOTIME.
> 
> When things collide, it is more work for everyone. But such is life for
> middle/core layer changes. Rebasing _really_ should not be a lot of
> work. And you are going to have to do it sooner or later, either upfront
> or after your patches stop applying because the block changes went
> upstream.

The task of running the secondary tree is not merely rebasing of patches
(which I already do on a daily basis) as it also involves extra coordination,
testing, updates etc.

Really, no more IDE workload on my side is possible and this is a fact not
something to be discussed about (unless someone is willing to help with IDE
maintainance tasks or sponsor my kernel work).

> The only sane way to handle conflicts like this is from the bottom and
> up.
> 
> You could try a more helpful approach, Bart.

Well, see my initial reply.  I proposed the middle-point approach which would
spread an extra effort across all parties involved and should also result in
a better review/testing of changes...

Thanks,
Bart
