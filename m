Return-Path: <linux-kernel-owner+w=401wt.eu-S1758606AbZE0CJb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758606AbZE0CJb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 22:09:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754577AbZE0CJW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 22:09:22 -0400
Received: from mga03.intel.com ([143.182.124.21]:25468 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752491AbZE0CJW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 22:09:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,256,1241420400"; 
   d="scan'208";a="147249591"
Date: Wed, 27 May 2009 10:09:09 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "jens.axboe@oracle.com" <jens.axboe@oracle.com>
Subject: Re: [PATCH] readahead:add blk_run_backing_dev
Message-ID: <20090527020909.GB17658@localhost>
References: <6.0.0.20.2.20090518183752.0581fdc0@172.19.0.2> <20090518175259.GL4140@kernel.dk> <20090520025123.GB8186@localhost> <6.0.0.20.2.20090521145005.06f81fe0@172.19.0.2> <20090522010538.GB6010@localhost> <6.0.0.20.2.20090522102551.0705aea0@172.19.0.2> <20090522023323.GA10864@localhost> <20090526164252.0741b392.akpm@linux-foundation.org> <6.0.0.20.2.20090527092105.076be238@172.19.0.2>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6.0.0.20.2.20090527092105.076be238@172.19.0.2>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 27, 2009 at 08:25:04AM +0800, Hisashi Hifumi wrote:
> 
> At 08:42 09/05/27, Andrew Morton wrote:
> >On Fri, 22 May 2009 10:33:23 +0800
> >Wu Fengguang <fengguang.wu@intel.com> wrote:
> >
> >> > I tested above patch, and I got same performance number.
> >> > I wonder why if (PageUptodate(page)) check is there...
> >> 
> >> Thanks!  This is an interesting micro timing behavior that
> >> demands some research work.  The above check is to confirm if it's
> >> the PageUptodate() case that makes the difference. So why that case
> >> happens so frequently so as to impact the performance? Will it also
> >> happen in NFS?
> >> 
> >> The problem is readahead IO pipeline is not running smoothly, which is
> >> undesirable and not well understood for now.
> >
> >The patch causes a remarkably large performance increase.  A 9%
> >reduction in time for a linear read? I'd be surprised if the workload
> 
> Hi Andrew.
> Yes, I tested this with dd.
> 
> >even consumed 9% of a CPU, so where on earth has the kernel gone to?
> >
> >Have you been able to reproduce this in your testing?
> 
> Yes, this test on my environment is reproducible.

Hisashi, does your environment have some special configurations?

Thanks,
Fengguang
