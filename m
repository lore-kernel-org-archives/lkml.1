Return-Path: <linux-kernel-owner+w=401wt.eu-S1756604AbZCOAbq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756604AbZCOAbq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Mar 2009 20:31:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755731AbZCOAbf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Mar 2009 20:31:35 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57709 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755348AbZCOAbe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Mar 2009 20:31:34 -0400
Date: Sat, 14 Mar 2009 17:27:08 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Lin Ming <ming.m.lin@intel.com>, Nick Piggin <npiggin@suse.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Wu Fengguang <fengguang.wu@intel.com>
Subject: Re: [Bug #12809] iozone regression with 2.6.29-rc6
In-Reply-To: <GCLaknAim2M.A.BKD.q4BvJB@chimera>
Message-ID: <alpine.LFD.2.00.0903141719510.3940@localhost.localdomain>
References: <MiincthRUSI.A.eKC.F4BvJB@chimera> <GCLaknAim2M.A.BKD.q4BvJB@chimera>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 14 Mar 2009, Rafael J. Wysocki wrote:
> 
> The following bug entry is on the current list of known regressions
> from 2.6.28.  Please verify if it still should be listed and let me know
> (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12809
> Subject		: iozone regression with 2.6.29-rc6
> Submitter	: Lin Ming <ming.m.lin@intel.com>
> Date		: 2009-02-27 9:13 (16 days old)
> First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=1cf6e7d83bf334cc5916137862c920a97aabc018
> References	: http://marc.info/?l=linux-kernel&m=123572630504360&w=4
> Handled-By	: Wu Fengguang <fengguang.wu@intel.com>

I suspect that I should just raise the default dirty limits. Wu reported 
that it fixed the regression, and while he picked some rather high 
percentages, I think we could certainly raise the rather aggressive 
default ones. 

After all, those default percentages were picked (a) with the old dirty 
logic and (b) largely at random and (c) designed to be aggressive. In 
particular, that (a) means that having fixed some of the dirty accounting, 
maybe the real bug is now that it was always too aggressive, just hidden 
by an accounting issue.

If we raised the default ratio from 5/10 to 10/20, what happens to the 
iozone regression?

		Linus
