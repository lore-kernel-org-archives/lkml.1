Return-Path: <linux-kernel-owner+w=401wt.eu-S1751921AbZGAEMa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751921AbZGAEMa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 00:12:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751035AbZGAEMW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 00:12:22 -0400
Received: from mga03.intel.com ([143.182.124.21]:9855 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751262AbZGAEMV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 00:12:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,320,1243839600"; 
   d="scan'208";a="160317619"
Date: Wed, 1 Jul 2009 12:12:14 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Cc: Nick Piggin <npiggin@suse.de>, Ying Han <yinghan@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: fio sync read 4k block size 35% regression
Message-ID: <20090701041214.GA13609@localhost>
References: <1246418733.2560.468.camel@ymzhang>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1246418733.2560.468.camel@ymzhang>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 01, 2009 at 11:25:33AM +0800, Zhang, Yanmin wrote:
> Comapraing with 2.6.30, fio sync read (block size 4k) has about 35% regression
> with kernel 2.6.31-rc1 ﻿on my stoakley machine with a JBOD (13 SCSI disks).
> 
> Every disk has 1 partition and 4 1-GB files. Start 10 processes per disk to
> do sy﻿nc read sequentinally.
> 
> Bisected down to below patch.
> 
> 51daa88ebd8e0d437289f589af29d4b39379ea76 is first bad commit
> commit 51daa88ebd8e0d437289f589af29d4b39379ea76
> Author: Wu Fengguang <fengguang.wu@intel.com>
> Date:   Tue Jun 16 15:31:24 2009 -0700
> 
>     readahead: remove sync/async readahead call dependency
> 
>     The readahead call scheme is error-prone in that it expects the call sites
>     to check for async readahead after doing a sync one.  I.e.
> 
>                         if (!page)
>                                 page_cache_sync_readahead();
>                         page = find_get_page();
>                         if (page && PageReadahead(page))
>                                 page_cache_async_readahead();
> 
> 
> I also test block size 64k and 128k, but they don't have regression. Perhaps
> the default read_ahead_kb is equal to 128?
> 
> Other 2 machines have no such regression. The JBODS of the 2 machines consists
> of 12 and 7 SATA/SAS disks while every disk has 2 partitions.

Yanmin, thanks for the tests!

Maybe the patch posted here can restore the performance:

        http://lkml.org/lkml/2009/5/21/319
        Subject Re: [PATCH] readahead:add blk_run_backing_dev

Thanks,
Fengguang
