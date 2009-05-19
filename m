Return-Path: <linux-kernel-owner+w=401wt.eu-S1754650AbZESPvS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754650AbZESPvS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 11:51:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752949AbZESPvJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 11:51:09 -0400
Received: from sh.osrg.net ([192.16.179.4]:56421 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752701AbZESPvI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 11:51:08 -0400
Date: Wed, 20 May 2009 00:49:58 +0900
To: hch@infradead.org
Cc: jmoyer@redhat.com, lizf@cn.fujitsu.com, mingo@elte.hu,
       jens.axboe@oracle.com, rostedt@goodmis.org, fweisbec@gmail.com,
       tzanussi@gmail.com, tytso@mit.edu, swhiteho@redhat.com,
       kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH] convert block trace points to TRACE_EVENT()
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20090519130841.GA3801@infradead.org>
References: <4A0BB813.9080807@cn.fujitsu.com>
	<x49ws8d45am.fsf@segfault.boston.devel.redhat.com>
	<20090519130841.GA3801@infradead.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20090520004943Q.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Wed, 20 May 2009 00:50:01 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 May 2009 09:08:41 -0400
Christoph Hellwig <hch@infradead.org> wrote:

> On Tue, May 19, 2009 at 08:59:29AM -0400, Jeff Moyer wrote:
> > I'm not sure I'm comfortable with this.  Having had to diagnose
> > performance problems using blktrace, I find the dev_t information for
> > plugs and unplugs especially interesting.  Maybe we can still figure
> > this out given the context in the trace, though.  Can you comment on
> > that?
> 
> The problem is that right now we still allow request queues shared by
> multiple gendisks, so we can't get at the gendisk.  The blktrace ioctl
> interface gets around that by doing the setup with an ioctl on the
> block device node and storing the dev_t at that point.
> 
> But I don't think we actually have any drivers left sharing a queue
> that way, and I'd love to get rid of that for various reasons.

There are still some (e.g. drivers/block/floppy.c)? I though that we
hit this when we tried to add the command filter feature though I
might be wrong (I can't recall).
