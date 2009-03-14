Return-Path: <linux-kernel-owner+w=401wt.eu-S1757693AbZCNUQv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757693AbZCNUQv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Mar 2009 16:16:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752579AbZCNUQm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Mar 2009 16:16:42 -0400
Received: from mail-bw0-f175.google.com ([209.85.218.175]:36176 "EHLO
	mail-bw0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752544AbZCNUQm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Mar 2009 16:16:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=ddMtlXszso1d9sAhBMIV0hbKblWaqRHnRv8w8Xxk7hoV7sk/YWrLeJGKnka+mdwHA5
         0tpcBTFIuuhZX1dyOJ9AcqG1Po6tduKtjQ3yHv2moSEcwbfaSryidKyGgIh5Hi6sk3Az
         VITDLTq5wB1ZOov6jivt0WeMLFdPH9HMqXLGs=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Subject: Re: [PATCH 11/14] block: implement and use [__]blk_end_request_all()
Date: Sat, 14 Mar 2009 21:19:09 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc7-next-20090311; KDE/4.2.0; i686; ; )
Cc: Tejun Heo <tj@kernel.org>, axboe@kernel.dk, linux-kernel@vger.kernel.org,
       Russell King <rmk@arm.linux.org.uk>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Mike Miller <mike.miller@hp.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Jeff Garzik <jgarzik@pobox.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Jeremy Fitzhardinge <jeremy@xensource.com>,
       Alex Dubov <oakad@yahoo.com>
References: <1236920578-2179-1-git-send-email-tj@kernel.org> <200903142023.14747.bzolnier@gmail.com> <1237060560.3907.57.camel@localhost.localdomain>
In-Reply-To: <1237060560.3907.57.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200903142119.10056.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 14 March 2009, James Bottomley wrote:
> On Sat, 2009-03-14 at 20:23 +0100, Bartlomiej Zolnierkiewicz wrote:
> > > > More generic comment follows -> this patch is guaranteed to clash
> > > > with at least linux-next/pata-2.6 tree so why not introduce block
> > > > layer helpers now, then push all driver updates through respective
> > > > driver maintainers and deal with end_request() later (after all
> > > > driver updates are in-tree)?
> > > 
> > > Most of the lld changes being trivial, I was hoping to push things
> > > through blk tree, but IDE seems to be the most intertwined with the
> > > block layer and it's likely to see quite some amount of not-so-trivial
> > > changes to subtle paths.  How about pushing !IDE parts into blk tree
> > > and pulling blk into pata-2.6, make IDE related changes there and
> > > pulling back into blk tree so that further progresses can be made?
> > 
> > There is a "tiny" problem with this -- pata-2.6 is a quilt tree based on
> > Linus' tree and it is not going to change for now (for various reasons).
> 
> Actually this one's easily solvable if you base the quilt on the block
> tree (just specify it to linux-next in the BASE directive and it will do
> the right thing).
> 
> What I'd do is actually run two quilts: one based on vanilla and one
> based on block and only add block dependent patches to the latter.  This
> is like running a postmerge git tree (you can only send a pull request
> for it after block goes in).

Thanks for the hint but it sounds like a major pain once you hit some
changes touching the same code areas that block patches do...

Besides this is guaranteed to inrease the workload on my side so it
won't happen simply because of -ENOTIME.

Thanks,
Bart
