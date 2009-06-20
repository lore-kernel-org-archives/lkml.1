Return-Path: <linux-kernel-owner+w=401wt.eu-S1753000AbZFTEdc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753000AbZFTEdc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jun 2009 00:33:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751175AbZFTEdV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Jun 2009 00:33:21 -0400
Received: from mga03.intel.com ([143.182.124.21]:49651 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750952AbZFTEdU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jun 2009 00:33:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,257,1243839600"; 
   d="scan'208";a="156653021"
Date: Sat, 20 Jun 2009 11:55:04 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>,
       "Alan.Brunelle@hp.com" <Alan.Brunelle@hp.com>,
       "hifumi.hisashi@oss.ntt.co.jp" <hifumi.hisashi@oss.ntt.co.jp>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       "jens.axboe@oracle.com" <jens.axboe@oracle.com>,
       "randy.dunlap@oracle.com" <randy.dunlap@oracle.com>
Subject: Re: [RESEND] [PATCH] readahead:add blk_run_backing_dev
Message-ID: <20090620035504.GA19516@localhost>
References: <6.0.0.20.2.20090601095926.06ee98d8@172.19.0.2> <4A2936A7.9070309@gmail.com> <20090606233056.7B9F.A69D9226@jp.fujitsu.com> <20090606224538.GA6173@localhost> <20090618120436.ad3196e3.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090618120436.ad3196e3.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 19, 2009 at 03:04:36AM +0800, Andrew Morton wrote:
> On Sun, 7 Jun 2009 06:45:38 +0800
> Wu Fengguang <fengguang.wu@intel.com> wrote:
> 
> > > > Do you have a place where the raw blktrace data can be retrieved for
> > > > more in-depth analysis?
> > >
> > > I think your comment is really adequate. In another thread, Wu Fengguang pointed
> > > out the same issue.
> > > I and Wu also wait his analysis.
> > 
> > And do it with a large readahead size :)
> > 
> > Alan, this was my analysis:
> > 
> > : Hifumi, can you help retest with some large readahead size?
> > :
> > : Your readahead size (128K) is smaller than your max_sectors_kb (256K),
> > : so two readahead IO requests get merged into one real IO, that means
> > : half of the readahead requests are delayed.
> > 
> > ie. two readahead requests get merged and complete together, thus the effective
> > IO size is doubled but at the same time it becomes completely synchronous IO.
> > 
> > :
> > : The IO completion size goes down from 512 to 256 sectors:
> > :
> > : before patch:
> > :   8,0    3   177955    50.050313976     0  C   R 8724991 + 512 [0]
> > :   8,0    3   177966    50.053380250     0  C   R 8725503 + 512 [0]
> > :   8,0    3   177977    50.056970395     0  C   R 8726015 + 512 [0]
> > :   8,0    3   177988    50.060326743     0  C   R 8726527 + 512 [0]
> > :   8,0    3   177999    50.063922341     0  C   R 8727039 + 512 [0]
> > :
> > : after patch:
> > :   8,0    3   257297    50.000760847     0  C   R 9480703 + 256 [0]
> > :   8,0    3   257306    50.003034240     0  C   R 9480959 + 256 [0]
> > :   8,0    3   257307    50.003076338     0  C   R 9481215 + 256 [0]
> > :   8,0    3   257323    50.004774693     0  C   R 9481471 + 256 [0]
> > :   8,0    3   257332    50.006865854     0  C   R 9481727 + 256 [0]
> > 
> 
> I haven't sent readahead-add-blk_run_backing_dev.patch in to Linus yet
> and it's looking like 2.6.32 material, if ever.
> 
> If it turns out to be wonderful, we could always ask the -stable
> maintainers to put it in 2.6.x.y I guess.

Agreed. The expected (and interesting) test on a properly configured
HW RAID has not happened yet, hence the theory remains unsupported.

Thanks,
Fengguang
