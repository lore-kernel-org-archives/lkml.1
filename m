Return-Path: <linux-kernel-owner+w=401wt.eu-S1757404AbXIRM1U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757404AbXIRM1U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 08:27:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756032AbXIRM1L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 08:27:11 -0400
Received: from mo11.iij4u.or.jp ([210.138.174.79]:58492 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755982AbXIRM1J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 08:27:09 -0400
Date: Tue, 18 Sep 2007 21:25:56 +0900
To: jens.axboe@oracle.com, michaelc@cs.wisc.edu
Cc: tomof@acm.org, pj@sgi.com, apw@shadowen.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, mel@csn.ul.ie, linux-scsi@vger.kernel.org,
       fujita.tomonori@lab.ntt.co.jp
Subject: Re: 2.6.23-rc4-mm1
From: FUJITA Tomonori <tomof@acm.org>
In-Reply-To: <20070918101840.GN25592@kernel.dk>
References: <20070917132819.GC25592@kernel.dk>
	<20070917192528E.tomof@acm.org>
	<20070918101840.GN25592@kernel.dk>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20070918123238X.tomof@acm.org>
X-Dispatcher: imput version 20050308(IM148)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Sep 2007 12:18:40 +0200
Jens Axboe <jens.axboe@oracle.com> wrote:

> On Mon, Sep 17 2007, FUJITA Tomonori wrote:
> > On Mon, 17 Sep 2007 15:28:19 +0200
> > Jens Axboe <jens.axboe@oracle.com> wrote:
> > 
> > > On Sat, Sep 15 2007, FUJITA Tomonori wrote:
> > > > On Fri, 14 Sep 2007 21:16:35 -0700
> > > > Paul Jackson <pj@sgi.com> wrote:
> > > > 
> > > > > FUJITA Tomonori wrote:
> > > > > > Can you try this patch (against 2.6.23-rc4-mm1)?
> > > > > > 
> > > > > > >From 592bd2049cb3e6e1f1dde7cf631879f26ddffeaa Mon Sep 17 00:00:00 2001
> > > > > > From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> > > > > > Date: Mon, 10 Sep 2007 04:17:13 +0100
> > > > > > Subject: [PATCH] qla1280: sg chaining fixes
> > > > > > 
> > > > > > Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> > > > > > ---
> > > > > >  drivers/scsi/qla1280.c |    5 ++++-
> > > > > >  1 files changed, 4 insertions(+), 1 deletions(-)
> > > > > 
> > > > > This patch works for me.
> > > > > 
> > > > > I was getting the scsi errors reported earlier in
> > > > > this thread, running 2.6.23-rc4-mm1 on one of our
> > > > > big SGI Altix systems.
> > > > > 
> > > > > Applying this patch fixed it, so far as I can tell,
> > > > > which is to say my system boots cleanly once again.
> > > > 
> > > > Thanks for testing!
> > > > 
> > > > Jens, we could enable use_sg_chaining option for qla1280.
> > > 
> > > Added, thanks!
> > 
> > Thanks.
> > 
> > BTW, please don't forget to integrate the following patches:
> > 
> > 
> > - revert sg segment size ifdefs
> > 
> > http://marc.info/?l=linux-scsi&m=118881264013097&w=2
> > 
> > - remove sglist_len
> > 
> > http://marc.info/?l=linux-scsi&m=118907920405100&w=2
> 
> Added, and I rebased the sglist-* branches to current again. So
> everything should be fully uptodate once more.

Thanks, here are a few more things.

- please drop the iscsi patch since Mike has major changes to iscsi
I/O path.

- ipr sg chaining need to be disabled since libata is not ready.

- you can add Doug's ACK to scsi_debug patch:

http://marc.info/?l=linux-scsi&m=118926325931801&w=2
