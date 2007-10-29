Return-Path: <linux-kernel-owner+w=401wt.eu-S1753334AbXJ2VIm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753334AbXJ2VIm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 17:08:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752197AbXJ2VIf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 17:08:35 -0400
Received: from ns.suse.de ([195.135.220.2]:37723 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752066AbXJ2VIe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 17:08:34 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Paul Jackson <pj@sgi.com>
Subject: Re: [patch 2/2] cpusets: add interleave_over_allowed option
Date: Mon, 29 Oct 2007 22:08:29 +0100
User-Agent: KMail/1.9.6
Cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>, rientjes@google.com,
       clameter@sgi.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
References: <alpine.DEB.0.9999.0710251540210.11929@chino.kir.corp.google.com> <1193674988.5035.93.camel@localhost> <20071029123558.fb077ca9.pj@sgi.com>
In-Reply-To: <20071029123558.fb077ca9.pj@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Content-Disposition: inline
Message-Id: <200710292208.30033.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 29 October 2007 20:35:58 Paul Jackson wrote:
> Lee wrote:
> > 2.  As this thread progresses, you've discussed relaxing the requirement
> > that applications pass a valid subset of mems_allowed.  I.e., something
> > that was illegal becomes legal.  An API change, I think.  But, a
> > backward compatible one, so that's OK, right? :-)
> 
> The more I have stared at this, the more certain I've become that we
> need to make the mbind/mempolicy calls modal -- the default mode
> continues to interpret node numbers and masks just as these calls do
> now, and the alternative mode provides the so called "Choice B",
> which takes node numbers and masks as if the task owned the entire
> system, and then the kernel internally and automatically scrunches
> those masks down to whatever happens to be the current cpuset of
> the task.

So the user space asks for 8 nodes because it knows the machine
has that many from /sys and it only gets 4 if a cpuset says so? That's
just bad semantics. And is not likely to make the user programs happy.

I don't think you'll get around to teaching user space (or rather libnuma)
about cpusets and let it handle it.

>From the libnuma perspective the machine size would be essentially 
current cpuset size. 

On the syscall level I don't think it makes much sense to change though.

The alternative would be to throw out the complete cpuset concept and go for 
virtual nodes inside containers with virtualized /sys.

-Andi


