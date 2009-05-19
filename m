Return-Path: <linux-kernel-owner+w=401wt.eu-S1754413AbZESRdm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754413AbZESRdm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 13:33:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751383AbZESRde
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 13:33:34 -0400
Received: from brick.kernel.dk ([93.163.65.50]:34383 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751177AbZESRde (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 13:33:34 -0400
Date: Tue, 19 May 2009 19:33:35 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: hch@infradead.org, jmoyer@redhat.com, lizf@cn.fujitsu.com, mingo@elte.hu,
       rostedt@goodmis.org, fweisbec@gmail.com, tzanussi@gmail.com,
       tytso@mit.edu, swhiteho@redhat.com, kosaki.motohiro@jp.fujitsu.com,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH] convert block trace points to TRACE_EVENT()
Message-ID: <20090519173334.GB4140@kernel.dk>
References: <4A0BB813.9080807@cn.fujitsu.com> <x49ws8d45am.fsf@segfault.boston.devel.redhat.com> <20090519130841.GA3801@infradead.org> <20090520004943Q.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090520004943Q.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 20 2009, FUJITA Tomonori wrote:
> On Tue, 19 May 2009 09:08:41 -0400
> Christoph Hellwig <hch@infradead.org> wrote:
> 
> > On Tue, May 19, 2009 at 08:59:29AM -0400, Jeff Moyer wrote:
> > > I'm not sure I'm comfortable with this.  Having had to diagnose
> > > performance problems using blktrace, I find the dev_t information for
> > > plugs and unplugs especially interesting.  Maybe we can still figure
> > > this out given the context in the trace, though.  Can you comment on
> > > that?
> > 
> > The problem is that right now we still allow request queues shared by
> > multiple gendisks, so we can't get at the gendisk.  The blktrace ioctl
> > interface gets around that by doing the setup with an ioctl on the
> > block device node and storing the dev_t at that point.
> > 
> > But I don't think we actually have any drivers left sharing a queue
> > that way, and I'd love to get rid of that for various reasons.
> 
> There are still some (e.g. drivers/block/floppy.c)? I though that we
> hit this when we tried to add the command filter feature though I
> might be wrong (I can't recall).

And mtd, iirc. But only a few. I'll fiddle up a patch to finally get rid
of this, it has been pending for... years.

-- 
Jens Axboe

