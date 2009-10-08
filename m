Return-Path: <linux-kernel-owner+w=401wt.eu-S1755353AbZJHIFi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755353AbZJHIFi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 04:05:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755280AbZJHIFh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 04:05:37 -0400
Received: from viefep14-int.chello.at ([62.179.121.34]:20558 "EHLO
	viefep14-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755194AbZJHIFe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 04:05:34 -0400
X-SourceIP: 213.93.53.227
Subject: Re: [PATCH 18/45] writeback: introduce wait queue for
 balance_dirty_pages()
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>, Theodore Tso <tytso@mit.edu>,
       Christoph Hellwig <hch@infradead.org>,
       Dave Chinner <david@fromorbit.com>,
       Chris Mason <chris.mason@oracle.com>,
       "Li, Shaohua" <shaohua.li@intel.com>,
       Myklebust Trond <Trond.Myklebust@netapp.com>,
       "jens.axboe@oracle.com" <jens.axboe@oracle.com>,
       Jan Kara <jack@suse.cz>, Nick Piggin <npiggin@suse.de>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20091008015822.GB14224@localhost>
References: <20091007073818.318088777@intel.com>
	 <20091007074903.422089703@intel.com>
	 <20091008100159.fb6770cf.kamezawa.hiroyu@jp.fujitsu.com>
	 <20091008015822.GB14224@localhost>
Content-Type: text/plain
Date: Thu, 08 Oct 2009 10:08:36 +0200
Message-Id: <1254989316.26976.260.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-10-08 at 09:58 +0800, Wu Fengguang wrote:
> 
> > How this runqueue->nr_iowait is handled now ?
> 
> Good question. io_schedule() has an old comment for throttling IO wait:
> 
>          * But don't do that if it is a deliberate, throttling IO wait (this task
>          * has set its backing_dev_info: the queue against which it should throttle)
>          */
>         void __sched io_schedule(void)
> 
> So it looks both Jens' and this patch behaves right in ignoring the
> iowait accounting for balance_dirty_pages() :)

Well it is a change in behaviour, and I think IOWAIT makes sense when
we're blocked due to io throttle..

Hmm?

