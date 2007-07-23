Return-Path: <linux-kernel-owner+w=401wt.eu-S1757952AbXGWFWq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757952AbXGWFWq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 01:22:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752857AbXGWFWh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 01:22:37 -0400
Received: from brick.kernel.dk ([80.160.20.94]:15358 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753405AbXGWFWg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 01:22:36 -0400
Date: Mon, 23 Jul 2007 07:22:45 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Rik van Riel <riel@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Fengguang Wu <wfg@mail.ustc.edu.cn>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Tim Pepper <lnxninja@us.ibm.com>,
       Chris Snook <csnook@redhat.com>
Subject: Re: [PATCH 3/3] readahead: scale max readahead size depending on
	memory size
Message-ID: <20070723052244.GW11657@kernel.dk>
References: <20070721210005.000228000@chello.nl> <20070721210052.497469000@chello.nl> <20070722082434.GR11657@kernel.dk> <1185093405.20032.205.camel@twins> <20070722085041.GS11657@kernel.dk> <46A3EDD9.2090707@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46A3EDD9.2090707@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 22 2007, Rik van Riel wrote:
> Jens Axboe wrote:
>
>> I just wish you had a rationale behind them, I don't think it's that
>> great of a series. I agree with the low point of 128k. Then it'd be sane
>> to try and determine what the upper limit of ra window size goodness is,
>> which is probably impossible since it depends on the hardware a lot. But
>> lets just say the upper value is 2mb, then I think it's pretty silly
>> _not_ to use 2mb on a 1g machine for instance. So more aggressive
>> scaling.
>
> 1 or 2 MB is a nice number.
>
> Seek time (plus rotational latency) on disks still takes
> on the order of 10 ms, while disks commonly transfer data
> on the order of 50MB/second.
>
> That means one disk seek (10ms) takes as long as it takes
> to read around 512kB of data.
>
> The current 128kB means that if you have lots of streaming
> IO going on, you spend only 20% of the time transferring
> data and get roughly 10MB/s.  Seek 10ms, read 2.5ms worth
> of data.
>
> OTOH, if you do 2MB per request for the same heavy streaming
> workload (say, an ftp or nfs server doing media files), you
> can get 80% of the disk throughput, or 40MB/s.  This is because
> you spend 40ms transferring data for every 10ms seek time.
>
> Yes, filesystem metadata will reduce this "occasionally",
> but the general idea holds.

I meant real numbers, the above is just rudimentary math. AS and CFQ
makes sure that you get a window of more than one request in, so huge
read-ahead sizes aren't as interesting.

So - more testing, less hand waving :-)

-- 
Jens Axboe

