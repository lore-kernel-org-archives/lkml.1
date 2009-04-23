Return-Path: <linux-kernel-owner+w=401wt.eu-S1753902AbZDWC4Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753902AbZDWC4Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 22:56:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752552AbZDWCz7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 22:55:59 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:45182 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752531AbZDWCz7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 22:55:59 -0400
Date: Thu, 23 Apr 2009 11:54:19 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Theodore Tso <tytso@mit.edu>
Cc: Andrea Righi <righi.andrea@gmail.com>, randy.dunlap@oracle.com,
       Carl Henrik Lunde <chlunde@ping.uio.no>,
       Jens Axboe <jens.axboe@oracle.com>, eric.rannaud@gmail.com,
       Balbir Singh <balbir@linux.vnet.ibm.com>, fernando@oss.ntt.co.jp,
       dradford@bluehost.com, Gui@smtp1.linux-foundation.org,
       agk@sourceware.org, subrata@linux.vnet.ibm.com,
       Paul Menage <menage@google.com>, akpm@linux-foundation.org,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       dave@linux.vnet.ibm.com, matt@bluehost.com, roberto@unbit.it,
       ngupta@google.com
Subject: Re: [PATCH 9/9] ext3: do not throttle metadata and journal IO
Message-Id: <20090423115419.c493266a.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090423012254.GZ15541@mit.edu>
References: <20090421163537.GI19186@mit.edu>
	<20090421172317.GM19637@balbir.in.ibm.com>
	<20090421174620.GD15541@mit.edu>
	<20090421181429.GO19637@balbir.in.ibm.com>
	<20090421191401.GF15541@mit.edu>
	<20090421204905.GA5573@linux>
	<20090422093349.1ee9ae82.kamezawa.hiroyu@jp.fujitsu.com>
	<20090422102153.9aec17b9.kamezawa.hiroyu@jp.fujitsu.com>
	<20090422102239.GA1935@linux>
	<20090423090535.ec419269.kamezawa.hiroyu@jp.fujitsu.com>
	<20090423012254.GZ15541@mit.edu>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Apr 2009 21:22:54 -0400
Theodore Tso <tytso@mit.edu> wrote:

> On Thu, Apr 23, 2009 at 09:05:35AM +0900, KAMEZAWA Hiroyuki wrote:
> > So, current status is.
> > 
> >   A. memcg should support dirty_ratio for its own memory reclaim.
> >      in plan.
> > 
> >   B. another cgroup can be implemnted to support cgroup_dirty_limit().
> >      But relationship with "A" should be discussed.
> >      no plan yet.
> > 
> >   C. I/O cgroup and bufferred I/O tracking system.
> >      Now under patch review.
> > 
> > And this I/O throttle is mainly for "C" discussion. 
> 
> How much testing has been done in terms of whether the I/O throttling
> actually works?  Not just, "the kernel doesn't crash", but that where
> you have one process generating a large amount of I/O load, in various
> different ways, and whether the right things happens?  If so, how has
> this been measured?

I/O control people should prove it. And they do, I think.

> 
> I'm really concerned that given some of the ways that I/O will "leak"
> out --- the via pdflush, swap writeout, etc., that without the rest of
> the pieces in place, I/O throttling by itself might not prove to be
> very effective.  Sure, if the workload is only doing direct I/O, life
> is pretty easy and it shouldn't be hard to throttle the cgroup.
> 
It's just a problem of "what we do and what we don't, now".
Andrea, Vivek, could you clarify ? As other project, I/O controller will not be
100% at first implementation. 

> But in the case where there is bufferred I/O, without write
> throttling, it's hard to see how well the I/O controller will work in
> practice.  In fact, I wouldn't be that surprised if it's possible to
> trigger the OOM killer.......
> 

yes, then, memcg should have dirty_ratio handler. And, we may have to
implement dirty-ratio controller.  So, please don't merge memcg discussion
and I/O BW throttoling. It's related to each other but different problem.

Thanks,
-Kame

