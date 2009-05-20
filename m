Return-Path: <linux-kernel-owner+w=401wt.eu-S1755971AbZETCxq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755971AbZETCxq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 22:53:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751960AbZETCxi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 22:53:38 -0400
Received: from mga03.intel.com ([143.182.124.21]:64444 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751248AbZETCxh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 22:53:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,218,1241420400"; 
   d="scan'208";a="144787978"
Date: Wed, 20 May 2009 10:52:58 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>, Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH] readahead:add blk_run_backing_dev
Message-ID: <20090520025258.GA8318@localhost>
References: <6.0.0.20.2.20090518183752.0581fdc0@172.19.0.2> <20090520100602.7438.A69D9226@jp.fujitsu.com> <6.0.0.20.2.20090520104202.071d0be8@172.19.0.2>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6.0.0.20.2.20090520104202.071d0be8@172.19.0.2>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 20, 2009 at 09:43:18AM +0800, Hisashi Hifumi wrote:
> 
> At 10:07 09/05/20, KOSAKI Motohiro wrote:
> >(cc to Wu and linux-mm)
> >
> >> Hi.
> >> 
> >> I wrote a patch that adds blk_run_backing_dev on page_cache_async_readahead
> >> so readahead I/O is unpluged to improve throughput.
> >> 
> >> Following is the test result with dd.
> >> 
> >> #dd if=testdir/testfile of=/dev/null bs=16384
> >> 
> >> -2.6.30-rc6
> >> 1048576+0 records in
> >> 1048576+0 records out
> >> 17179869184 bytes (17 GB) copied, 224.182 seconds, 76.6 MB/s
> >> 
> >> -2.6.30-rc6-patched
> >> 1048576+0 records in
> >> 1048576+0 records out
> >> 17179869184 bytes (17 GB) copied, 206.465 seconds, 83.2 MB/s
> >> 
> >> Sequential read performance on a big file was improved.
> >> Please merge my patch.
> >
> >I guess the improvement depend on readahead window size.
> >Have you mesure random access workload?
> 
> I tried with iozone. But there was no difference.

It does not impact random IO because the patch only modified the
*async* readahead path, and random IO is obviously *sync* ones.
