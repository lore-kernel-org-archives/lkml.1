Return-Path: <linux-kernel-owner+w=401wt.eu-S1755269AbZESNJE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755269AbZESNJE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 09:09:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754207AbZESNI4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 09:08:56 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:45630 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754079AbZESNI4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 09:08:56 -0400
Date: Tue, 19 May 2009 09:08:41 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
       Jens Axboe <jens.axboe@oracle.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Tom Zanussi <tzanussi@gmail.com>, "Theodore Ts'o" <tytso@mit.edu>,
       Steven Whitehouse <swhiteho@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH] convert block trace points to TRACE_EVENT()
Message-ID: <20090519130841.GA3801@infradead.org>
References: <4A0BB813.9080807@cn.fujitsu.com> <x49ws8d45am.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <x49ws8d45am.fsf@segfault.boston.devel.redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 19, 2009 at 08:59:29AM -0400, Jeff Moyer wrote:
> I'm not sure I'm comfortable with this.  Having had to diagnose
> performance problems using blktrace, I find the dev_t information for
> plugs and unplugs especially interesting.  Maybe we can still figure
> this out given the context in the trace, though.  Can you comment on
> that?

The problem is that right now we still allow request queues shared by
multiple gendisks, so we can't get at the gendisk.  The blktrace ioctl
interface gets around that by doing the setup with an ioctl on the
block device node and storing the dev_t at that point.

But I don't think we actually have any drivers left sharing a queue
that way, and I'd love to get rid of that for various reasons.

> from the single letter output to the verbose strings?  Am I just being a
> curmudgeon?
> 
> I have one further question, which will expose my ignorance on this
> implementation.  Would the proposed patch change the information
> available to the blktrace utility,

That's the output from /sys/kernel/debug/tracing/trace when the
block events are enabled.  The blktrace utility should continue to
work without changes, although it could be ported to use the ftrace
binary ring buffer directly in the future.
