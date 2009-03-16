Return-Path: <linux-kernel-owner+w=401wt.eu-S1761097AbZCPHdZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761097AbZCPHdZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 03:33:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760708AbZCPHal
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 03:30:41 -0400
Received: from mga03.intel.com ([143.182.124.21]:17153 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760701AbZCPHaj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 03:30:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,372,1233561600"; 
   d="scan'208";a="120583906"
Date: Mon, 16 Mar 2009 15:30:17 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: "Lin, Ming M" <ming.m.lin@intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [Bug #12809] iozone regression with 2.6.29-rc6
Message-ID: <20090316073017.GA9059@localhost>
References: <MiincthRUSI.A.eKC.F4BvJB@chimera> <GCLaknAim2M.A.BKD.q4BvJB@chimera> <alpine.LFD.2.00.0903141719510.3940@localhost.localdomain> <1237179822.27907.6.camel@minggr.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=gb2312
Content-Disposition: inline
In-Reply-To: <1237179822.27907.6.camel@minggr.sh.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 16, 2009 at 01:03:42PM +0800, Lin, Ming wrote:
> On Sun, 2009-03-15 at 08:27 +0800, Linus Torvalds wrote:
> > 
> > On Sat, 14 Mar 2009, Rafael J. Wysocki wrote:
> > > 
> > > The following bug entry is on the current list of known regressions
> > > from 2.6.28.  Please verify if it still should be listed and let me know
> > > (either way).
> > > 
> > > 
> > > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12809
> > > Subject		: iozone regression with 2.6.29-rc6
> > > Submitter	: Lin Ming <ming.m.lin@intel.com>
> > > Date		: 2009-02-27 9:13 (16 days old)
> > > First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=1cf6e7d83bf334cc5916137862c920a97aabc018
> > > References	: http://marc.info/?l=linux-kernel&m=123572630504360&w=4
> > > Handled-By	: Wu Fengguang <fengguang.wu@intel.com>
> > 
> > I suspect that I should just raise the default dirty limits. Wu reported 
> > that it fixed the regression, and while he picked some rather high 
> > percentages, I think we could certainly raise the rather aggressive 
> > default ones. 
> > 
> > After all, those default percentages were picked (a) with the old dirty 
> > logic and (b) largely at random and (c) designed to be aggressive. In 
> > particular, that (a) means that having fixed some of the dirty accounting, 
> > maybe the real bug is now that it was always too aggressive, just hidden 
> > by an accounting issue.
> > 
> > If we raised the default ratio from 5/10 to 10/20, what happens to the 
> > iozone regression?
> 
> echo 10 > /proc/sys/vm/dirty_background_ratio
> echo 20 > /proc/sys/vm/dirty_ratio
> 
> It fixed the regression of iozone (filesize 1200M) on 4P dual-core HT
> machine(8G mem).

A quick&coarse calculation: 8G * 15% = 1200M.
This means an iozone process dirtying 1200M data won't be write-blocked.

So the thresholds of 10/20 are just about enough for fixing this regression.

Thanks,
Fengguang

