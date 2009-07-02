Return-Path: <linux-kernel-owner+w=401wt.eu-S1754762AbZGBNmS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754762AbZGBNmS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 09:42:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754189AbZGBNmE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 09:42:04 -0400
Received: from mga14.intel.com ([143.182.124.37]:24246 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754154AbZGBNmD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 09:42:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,334,1243839600"; 
   d="scan'208";a="160906907"
Date: Thu, 2 Jul 2009 20:41:28 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Pavel Levshin <lpk@581.spb.su>,
       "wli@movementarian.org" <wli@movementarian.org>,
       Nick Piggin <npiggin@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: fio mmap sequential read 30% regression
Message-ID: <20090702124128.GB8503@localhost>
References: <1246521682.2560.490.camel@ymzhang>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1246521682.2560.490.camel@ymzhang>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 02, 2009 at 04:01:22PM +0800, Zhang, Yanmin wrote:
> Comapring with 2.6.30's result, fio mmap sequtial read has
> about 30% regression on one of my stoakley machine with 1
> JBOD (7 SAS disks) with kernel 2.6.31-rc1.
> 
> ﻿Every disk has 2 partitions and 4 1-GB files per partition. Start
> 10 processes per disk to do mmap read sequentinally.
> 
> Bisect down to below patch.
> 
> ef00e08e26dd5d84271ef706262506b82195e752 is first bad commit
> commit ef00e08e26dd5d84271ef706262506b82195e752
> Author: Linus Torvalds <torvalds@linux-foundation.org>
> Date:   Tue Jun 16 15:31:25 2009 -0700
> 
>     readahead: clean up and simplify the code for filemap page fault readahead
>     
>     This shouldn't really change behavior all that much, but the single rather
>     complex function with read-ahead inside a loop etc is broken up into more
>     manageable pieces.
>     
>     The behaviour is also less subtle, with the read-ahead being done up-front
>     rather than inside some subtle loop and thus avoiding the now unnecessary
>     extra state variables (ie "did_readaround" is gone).
>     
>     Fengguang: the code split in fact fixed a bug reported by Pavel Levshin:
>     the PGMAJFAULT accounting used to be bypassed when MADV_RANDOM is set, in
>     which case the original code will directly jump to no_cached_page reading.
> 
> 
> The bisect is stable.

Let me take care of this bug: it may well be caused by my other readahead patches.

Thanks,
Fengguang

