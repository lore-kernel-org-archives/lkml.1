Return-Path: <linux-kernel-owner+w=401wt.eu-S1755447AbZJHIOY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755447AbZJHIOY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 04:14:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751243AbZJHIOX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 04:14:23 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:53611 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755234AbZJHIOV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 04:14:21 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 8 Oct 2009 17:11:14 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Wu Fengguang <fengguang.wu@intel.com>,
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
Subject: Re: [PATCH 18/45] writeback: introduce wait queue for
 balance_dirty_pages()
Message-Id: <20091008171114.d2763f9d.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1254989316.26976.260.camel@twins>
References: <20091007073818.318088777@intel.com>
	<20091007074903.422089703@intel.com>
	<20091008100159.fb6770cf.kamezawa.hiroyu@jp.fujitsu.com>
	<20091008015822.GB14224@localhost>
	<1254989316.26976.260.camel@twins>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 08 Oct 2009 10:08:36 +0200
Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> On Thu, 2009-10-08 at 09:58 +0800, Wu Fengguang wrote:
> > 
> > > How this runqueue->nr_iowait is handled now ?
> > 
> > Good question. io_schedule() has an old comment for throttling IO wait:
> > 
> >          * But don't do that if it is a deliberate, throttling IO wait (this task
> >          * has set its backing_dev_info: the queue against which it should throttle)
> >          */
> >         void __sched io_schedule(void)
> > 
> > So it looks both Jens' and this patch behaves right in ignoring the
> > iowait accounting for balance_dirty_pages() :)
> 
> Well it is a change in behaviour, and I think IOWAIT makes sense when
> we're blocked due to io throttle..
> 
> Hmm?
> 
Above comment "don't do that if it is a deliberate, throttling IO wait" is
really old but ignored.
I pesonally don't like to change the meanig of iowait in /proc/stat. 
But I'm not sure which is better to change the definitiion (which was ignored) or
fix behavior (not correct very long time)...

Hmm?, too ;)

Regards,
-Kame

