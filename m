Return-Path: <linux-kernel-owner+w=401wt.eu-S1753949AbZCOH4a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753949AbZCOH4a (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Mar 2009 03:56:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751358AbZCOH4U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Mar 2009 03:56:20 -0400
Received: from mga14.intel.com ([143.182.124.37]:61197 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751031AbZCOH4T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Mar 2009 03:56:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,365,1233561600"; 
   d="scan'208";a="120379903"
Date: Sun, 15 Mar 2009 15:55:52 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Lin, Ming M" <ming.m.lin@intel.com>, Nick Piggin <npiggin@suse.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [Bug #12809] iozone regression with 2.6.29-rc6
Message-ID: <20090315075552.GA6015@localhost>
References: <MiincthRUSI.A.eKC.F4BvJB@chimera> <GCLaknAim2M.A.BKD.q4BvJB@chimera> <alpine.LFD.2.00.0903141719510.3940@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0903141719510.3940@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 15, 2009 at 08:27:08AM +0800, Linus Torvalds wrote:
> 
> 
> On Sat, 14 Mar 2009, Rafael J. Wysocki wrote:
> > 
> > The following bug entry is on the current list of known regressions
> > from 2.6.28.  Please verify if it still should be listed and let me know
> > (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12809
> > Subject		: iozone regression with 2.6.29-rc6
> > Submitter	: Lin Ming <ming.m.lin@intel.com>
> > Date		: 2009-02-27 9:13 (16 days old)
> > First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=1cf6e7d83bf334cc5916137862c920a97aabc018
> > References	: http://marc.info/?l=linux-kernel&m=123572630504360&w=4
> > Handled-By	: Wu Fengguang <fengguang.wu@intel.com>
> 
> I suspect that I should just raise the default dirty limits. Wu reported 
> that it fixed the regression, and while he picked some rather high 
> percentages, I think we could certainly raise the rather aggressive 
> default ones. 
> 
> After all, those default percentages were picked (a) with the old dirty 
> logic and (b) largely at random and (c) designed to be aggressive. In 
> particular, that (a) means that having fixed some of the dirty accounting, 
> maybe the real bug is now that it was always too aggressive, just hidden 
> by an accounting issue.

I second that.

1) The _real_ dirty threshold used to be large.
2) It is a _real_ regression. It impacts real user experiences.

So when introducing Nick's correct-dirty-accounting patch, we'd better
increase the dirty thresholds correspondingly.

> If we raised the default ratio from 5/10 to 10/20, what happens to the 
> iozone regression?

Maybe tomorrow. Ling Ming?

In general we should not cater the thresholds for one specific workload.
But this is a case of _regression_, and it would be better to raise the
bars above it.

Thanks,
Fengguang
