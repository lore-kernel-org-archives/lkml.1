Return-Path: <linux-kernel-owner+w=401wt.eu-S1752563AbYAQLnR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752563AbYAQLnR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 06:43:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751384AbYAQLnB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 06:43:01 -0500
Received: from nessie.weebeastie.net ([220.233.7.36]:54146 "EHLO
	bunyip.lochness.weebeastie.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751379AbYAQLnA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 06:43:00 -0500
Date: Thu, 17 Jan 2008 22:40:50 +1100
From: CaT <cat@zip.com.au>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.24-rc7: memory leak?
Message-ID: <20080117114050.GR3940@zip.com.au>
References: <20080117063410.GQ3940@zip.com.au> <1200568923.28661.9.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1200568923.28661.9.camel@twins>
Organisation: Furball Inc.
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 17, 2008 at 12:22:03PM +0100, Peter Zijlstra wrote:
> On Thu, 2008-01-17 at 17:34 +1100, CaT wrote:
> > cache). During the rsync the memory used grew to just shy of 1.6gig and
> > now, about 2 hours after the rsync has well and truly finished, the used
> > memory is at 1.23gig. This is what free reports:
> > 
> >              total       used       free     shared    buffers cached
> > Mem:       2058128    1994468      63660          0     688604 11432
> > -/+ buffers/cache:    1294432     763696
> > Swap:      1048568          0    1048568
> 
> How much memory does:
> 
>   echo 3 > /proc/sys/vm/drop_caches
> 
> gain you?

56M used now. Should all this cache usage not be counted towards the
'Cached' entry in meminfo rather then getting counted as part of used
ram. I assume that this would not cause an oom situation and would be
freed up if all that memory really did need to be used.

> > ext3_inode_cache  1235577 1240565    768    5    1 : tunables   54   27    8 : slabdata 248113 248113      0
> > dentry            703661 749797    200   19    1 : tunables  120   60    8 : slabdata  39463  39463      0
> > buffer_head       174535 209087    104   37    1 : tunables  120   60    8 : slabdata   5651   5651      0
> 
> would get freed by doing that.

They were indeed.

> this one:
> 
> > size-64           537590 850249     64   59    1 : tunables  120   60    8 : slabdata  14411  14411      0
> 
> I'm unsure about, if that one sticks around that'd be something to worry
> about. See if you can monitor this value and try to determine:

This went away also.

>  - if it ever drops
>  - what makes it grow (fastest)
> 
> I guess we could stick some instrumentation in there to track that
> bucket.

Might help prevent upraised eyebrows or worse. :)

-- 
    "To the extent that we overreact, we proffer the terrorists the
    greatest tribute."
    	- High Court Judge Michael Kirby
