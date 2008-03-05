Return-Path: <linux-kernel-owner+w=401wt.eu-S1764187AbYCEHPX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764187AbYCEHPX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 02:15:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752777AbYCEHPB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 02:15:01 -0500
Received: from mga10.intel.com ([192.55.52.92]:43692 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751588AbYCEHPA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 02:15:00 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,448,1199692800"; 
   d="scan'208";a="528942535"
Subject: Re: 2.6.25-rc3-git3: Reported regressions from 2.6.24
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: balbir@linux.vnet.ibm.com, Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Adrian Bunk <bunk@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Balbir Singh <balbir@in.ibm.com>
In-Reply-To: <20080305065635.GC28398@elte.hu>
References: <200803030316.07165.rjw@sisk.pl>
	 <20080304112741.GA13428@linux.vnet.ibm.com>
	 <1204682782.3248.189.camel@ymzhang> <47CE183C.7040105@linux.vnet.ibm.com>
	 <1204694154.3248.194.camel@ymzhang>  <20080305065635.GC28398@elte.hu>
Content-Type: text/plain; charset=utf-8
Date: Wed, 05 Mar 2008 15:13:09 +0800
Message-Id: <1204701189.17994.1.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.9.2 (2.9.2-2.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-03-05 at 07:56 +0100, Ingo Molnar wrote:
> * Zhang, Yanmin <yanmin_zhang@linux.intel.com> wrote:
> 
> > > Have you had a chance to git-bisect the culprit after the revert?
> >
> > How to bisect it if the reverted patch is submitted after the culprit 
> > patch?
> 
> i do this by using quilt ontop of git-bisect.
Thanks for your kind information. My machines are buys in testing 2.6.25-rc4.

Let me find a timeslot to track this issue again.

-yanmin

> 
> I do something like this:
> 
>   mkdir patches
>   echo revert.patch > patches/series
>   git-log -1 -p 62fb185130e4d420f > patches/revert.patch 
> 
>   git-bisect start
>   git-bisect  bad v2.6.24-rc3
>   git-bisect good v2.6.24
> 
>   quilt push           # the revert is applied
>   [ test the kernel ]
>   quilt pop            # revert is unapplied
> 
>   git-bisect bad       # if it's still bad
> 
>   quilt push           # apply the revert again
>   [ test the next kernel ]
>   quilt pop            # undo the revert
> 
>   git-bisect good      # if it's good
> 
> etc. NOTE: if the "quilt push" fails, it's likely because you are in a 
> point in the tree that does not have the reverted commits applied yet. 
> In that case there's no need to push/pop, just test the bisection point.
> 
> Note, since there are _two_ guilty commits here:
> 
>       commit 58e2d4ca581167c2a079f4ee02be2f0bc52e8729
>       Author: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
>       Date:   Fri Jan 25 21:08:00 2008 +0100
>       sched: group scheduling, change how cpu load is calculated
> 
>       commit 6b2d7700266b9402e12824e11e0099ae6a4a6a79
>       Author: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
>       Date:   Fri Jan 25 21:08:00 2008 +0100
>       sched: group scheduler, fix fairness of cpu bandwidth allocation for task
> 
> make sure the bisection point is never "between" these two commits.
> 
> You can check whether a bisection point has the two guilty commits 
> applied, via:
> 
>   git-log | grep -E '58e2d4ca581167c2a0|6b2d7700266b9402e12'
> 
> if this comes up empty, the guilty commits are not applied.
> 
> 	Ingo

