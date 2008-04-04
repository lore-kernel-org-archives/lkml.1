Return-Path: <linux-kernel-owner+w=401wt.eu-S1758560AbYDDO7r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758560AbYDDO7r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 10:59:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756679AbYDDO7j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 10:59:39 -0400
Received: from mx1.redhat.com ([66.187.233.31]:42135 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756677AbYDDO7j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 10:59:39 -0400
Date: Fri, 4 Apr 2008 12:02:42 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Jan Kara <jack@suse.cz>
Cc: Peter Zijlstra <peterz@infradead.org>, David Chinner <dgc@sgi.com>,
       lkml <linux-kernel@vger.kernel.org>, marcelo <marcelo@kvack.org>
Subject: Re: BUG: ext3 hang in transaction commit
Message-ID: <20080404150242.GA30818@dmt>
References: <20080326231612.GC103491721@sgi.com> <20080403100742.GA16314@atrey.karlin.mff.cuni.cz> <1207235335.8514.843.camel@twins> <20080403161500.GA21434@dmt> <20080404103450.GC477@atrey.karlin.mff.cuni.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080404103450.GC477@atrey.karlin.mff.cuni.cz>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 04, 2008 at 12:34:50PM +0200, Jan Kara wrote:

> >         Max throughput per process                      =   66393.62 KB/sec
> >         Avg throughput per process                      =   26518.38 KB/sec
> >         Min xfer                                        =   44424.00 KB
> > 
> > And this is when fsync becomes nasty.
>   Could you get for me movies from Seekwatcher (taken on the host) -
> http://oss.oracle.com/~mason/seekwatcher/
>   That should confirm my suspicion. Actually, if writing data in the bad
> order is really the problem than my rewrite of ordered mode in JBD can
> substantially help this workload (I can send you the patches if you dare
> to try something really experimental ;).

OK, will record the animation.

Will be pleased to try your patches. Where can they be found?

> > blktrace output shows that the maximum latency for a single write
> > request io complete is 1.5 seconds, which is similar to what is seen
> > under "writeback" mode.
> > 
> > I reduced hung_task_timeout_secs to 30 for this report, but vim and
> > rsyslogd have been seen hung up to 120 seconds.
> > 
> 
> <snip traces of processes waiting for commit>
> 
> > As Peter mentioned it eventually gets out of this state (after several
> > minutes) and fsync instances complete.
>   Yes, that is just a combined effect of *lots* of ordered data
> accumulated in one transaction (we don't limit amount of ordered data in
> a transaction in any way) and writing them out during transaction order
> in a random order.
