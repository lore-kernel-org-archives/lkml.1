Return-Path: <linux-kernel-owner+w=401wt.eu-S1756930AbZGAFDh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756930AbZGAFDh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 01:03:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751622AbZGAFD3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 01:03:29 -0400
Received: from mga10.intel.com ([192.55.52.92]:63512 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751003AbZGAFD2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 01:03:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,321,1243839600"; 
   d="scan'208";a="704044336"
Subject: Re: fio sync read 4k block size 35% regression
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Nick Piggin <npiggin@suse.de>, Ying Han <yinghan@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20090701041010.GB22364@localhost>
References: <1246418733.2560.468.camel@ymzhang>
	 <20090701041010.GB22364@localhost>
Content-Type: text/plain; charset=UTF-8
Date: Wed, 01 Jul 2009 13:03:55 +0800
Message-Id: <1246424635.2560.470.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-07-01 at 12:10 +0800, Wu Fengguang wrote:
> On Wed, Jul 01, 2009 at 11:25:33AM +0800, Zhang, Yanmin wrote:
> > Comapraing with 2.6.30, fio sync read (block size 4k) has about 35% regression
> > with kernel 2.6.31-rc1 ﻿on my stoakley machine with a JBOD (13 SCSI disks).
> > 
> > Every disk has 1 partition and 4 1-GB files. Start 10 processes per disk to
> > do sy﻿nc read sequentinally.
> > 
> > Bisected down to below patch.
> > 
> > 51daa88ebd8e0d437289f589af29d4b39379ea76 is first bad commit
> > commit 51daa88ebd8e0d437289f589af29d4b39379ea76
> > Author: Wu Fengguang <fengguang.wu@intel.com>
> > Date:   Tue Jun 16 15:31:24 2009 -0700
> > 
> >     readahead: remove sync/async readahead call dependency
> > 
> >     The readahead call scheme is error-prone in that it expects the call sites
> >     to check for async readahead after doing a sync one.  I.e.
> > 
> >                         if (!page)
> >                                 page_cache_sync_readahead();
> >                         page = find_get_page();
> >                         if (page && PageReadahead(page))
> >                                 page_cache_async_readahead();
> > 
> > 
> > I also test block size 64k and 128k, but they don't have regression. Perhaps
> > the default read_ahead_kb is equal to 128?
> > 
> > Other 2 machines have no such regression. The JBODS of the 2 machines consists
> > of 12 and 7 SATA/SAS disks while every disk has 2 partitions.
> 
> Yanmin, thanks for the tests!
> 
> Maybe the patch posted here can restore the performance:
> 
> http://lkml.org/lkml/2009/5/21/319
I tried it and it doesn't help.

Yanmin


