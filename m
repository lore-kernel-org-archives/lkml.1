Return-Path: <linux-kernel-owner+w=401wt.eu-S1755856AbZJZLkJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755856AbZJZLkJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 07:40:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755785AbZJZLkI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 07:40:08 -0400
Received: from brick.kernel.dk ([93.163.65.50]:45619 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755767AbZJZLkH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 07:40:07 -0400
Date: Mon, 26 Oct 2009 12:40:11 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Corrado Zoccolo <czoccolo@gmail.com>
Cc: Jeff Moyer <jmoyer@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH/RFC 0/4] cfq: implement merging and breaking up of
	cfq_queues
Message-ID: <20091026114011.GD10727@kernel.dk>
References: <1256332492-24566-1-git-send-email-jmoyer@redhat.com> <4e5e476b0910241308s4a14fb69jbc6f8d35eb0ab78@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4e5e476b0910241308s4a14fb69jbc6f8d35eb0ab78@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 24 2009, Corrado Zoccolo wrote:
> Hi Jeff,
> this series looks good.
> I like in particular the fact that you move seekiness detection in the cfqq.
> This can help with processes that issue sequential reads and seeky
> writes, or vice versa.
> Probably, also the think time could be made per-cfqq, so that the
> decision whether we should idle for a given cfqq is more precise.
> 
> On Fri, Oct 23, 2009 at 11:14 PM, Jeff Moyer <jmoyer@redhat.com> wrote:
> > Hi,
> >
> > This is a follow-up patch to the original close cooperator support for
> > CFQ.  The problem is that some programs (NFSd, dump(8), iscsi target
> > mode driver, qemu) interleave sequential I/Os between multiple threads
> > or processes.  The result is that there are large delays due to CFQ's
> > idling logic that leads to very low throughput.
> 
> You identified the problem in the idling logic, that reduces the
> throughput in this particular scenario, in which various threads or
> processes issue (in random order) the I/O requests with different I/O
> contexts on behalf of a single entity.
> In this case, any idling between those threads is detrimental.
> Ideally, such cases should be already spotted, since think time should
> be high for such processes, so I wonder if this indicates a problem in
> the current think time logic.

That isn't necessarily true, it may just as well be that there's very
little think time (don't see the connection here). A test case to
demonstrate this would be a number of processes/threads splitting a
sequential read of a file between them.

-- 
Jens Axboe

