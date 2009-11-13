Return-Path: <linux-kernel-owner+w=401wt.eu-S1756939AbZKMSoI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756939AbZKMSoI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 13:44:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756817AbZKMSoE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 13:44:04 -0500
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:35575 "EHLO kernel.dk"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756804AbZKMSoC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 13:44:02 -0500
Date: Fri, 13 Nov 2009 19:44:07 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Corrado Zoccolo <czoccolo@gmail.com>, linux-kernel@vger.kernel.org,
       nauman@google.com, dpshah@google.com, lizf@cn.fujitsu.com,
       ryov@valinux.co.jp, fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com,
       taka@valinux.co.jp, guijianfeng@cn.fujitsu.com, jmoyer@redhat.com,
       balbir@linux.vnet.ibm.com, righi.andrea@gmail.com,
       m-ikeda@ds.jp.nec.com, akpm@linux-foundation.org, riel@redhat.com,
       kamezawa.hiroyu@jp.fujitsu.com
Subject: Re: [PATCH 03/16] blkio: Keep queue on service tree until we
	expire   it
Message-ID: <20091113184407.GB8742@kernel.dk>
References: <1258068756-10766-1-git-send-email-vgoyal@redhat.com> <1258068756-10766-4-git-send-email-vgoyal@redhat.com> <4e5e476b0911130239j3bfdef6q789fa78da36c6023@mail.gmail.com> <20091113104808.GW8742@kernel.dk> <20091113150512.GB17076@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091113150512.GB17076@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 13 2009, Vivek Goyal wrote:
> On Fri, Nov 13, 2009 at 11:48:08AM +0100, Jens Axboe wrote:
> > On Fri, Nov 13 2009, Corrado Zoccolo wrote:
> > > Hi Vivek,
> > > the following is probably not on a critical path, but maybe it can be
> > > written more efficiently.
> > > Now, it will cicle through all service trees multiple times, to
> > > retrieve the queues for the last one.
> > > What about having a cfq_for_each_queue that takes a function pointer
> > > and will apply it to all of them?
> > 
> > I thought the same when reading this. Or perhaps have a small bitmap
> > instead/with the counter to avoid looping around known empty groups.
> 
> Hi Jens,
> 
> Empty groups will not be on the group service tree. Only exception is
> the group belonging to current active queue where queue might be empty
> but still on service tree because we might be idling on it.
> 
> So we don't have to worry about looping through empty groups.

Looks ok, the forced dispatch is less of an issue.

> > I want to start merging the initial prep patches soon, so we can both
> > cut back on the size of your patchset while getting the simpler bits in.
> > Unfortunately I had to stop here, but with a few corrections it can be
> > merged too.
> 
> Now we are left with the issue of looping through various empty service
> trees with-in group. We already keep a count of busy queues in each
> service tree. One simple way is to just check for that count and if tree
> is empty, simply return back. I have modified cfq_rb_first() to check for
> count first before it tries to do rb_next().
> 
> Please let me know if you think that this is not good enough and we need
> to maintain a bit map of busy service trees in a group.

I think so, thanks!

-- 
Jens Axboe

