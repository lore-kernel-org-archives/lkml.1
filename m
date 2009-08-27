Return-Path: <linux-kernel-owner+w=401wt.eu-S1751735AbZH0Stj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751735AbZH0Stj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 14:49:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751535AbZH0Sti
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 14:49:38 -0400
Received: from brick.kernel.dk ([93.163.65.50]:35400 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751507AbZH0Sti (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 14:49:38 -0400
Date: Thu, 27 Aug 2009 20:49:39 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       alan@lxorguk.ukuu.org.uk, jeff@garzik.org, dhowells@redhat.com
Subject: Re: [PATCH 0/3] Convert libata pio task to slow-work
Message-ID: <20090827184939.GK12579@kernel.dk>
References: <1251364122-9592-1-git-send-email-jens.axboe@oracle.com> <4A967DD7.20603@kernel.org> <20090827124927.GJ12579@kernel.dk> <4A96830F.9040805@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A96830F.9040805@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 27 2009, Tejun Heo wrote:
> Hello, Jens.
> 
> Jens Axboe wrote:
> >> It would be nice if merging of this series and the lazy work can be
> >> held a bit but there's no harm in merging either.  If the concurrency
> >> managed workqueue turns out to be a good idea, we can replace it then.
> > 
> > It can wait, what you describe above sounds really cool and would
> > hopefully allow us to get rid of all workqueues (provided it scales well
> > and doesn't fall down on cache line contention with many different
> > instances pounding on it).
> 
> Almost all operations are per-cpu so cache lines shouldn't bounce too
> much.  The only part I worry about is the part which checks whether a
> work is currently executing on the current cpu which currently is
> implemeted as a hash table.  The hash table is only 16 pointers long
> and will be mostly empty so hopefully it doesn't add any significant
> overhead.

OK, we'll let time and experimentation be the judge.

> > Care to post it? I know you don't think it's perfect yet, but it would
> > make a lot more sense to throw effort into this rather than waste time
> > on partial solutions.
> 
> I have this printed out code with full of red markings from proof
> reading and flush implementation is mostly broken.  Please give me a
> couple of days.  I'll post a rough unsplit version which at least
> compiles with the planned changes applied by the end of the week.  :-)

Alright, fair enough.

One question - do the 'exposed' workqueues (the ones that drivers
allocate/create) sitting in front of the global cpu queue allow more
than one thread per cpu, or is that property retained for the global cpu
queue (where it is a necessity)?

-- 
Jens Axboe

