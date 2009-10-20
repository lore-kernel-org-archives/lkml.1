Return-Path: <linux-kernel-owner+w=401wt.eu-S1754875AbZJTGgC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754875AbZJTGgC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Oct 2009 02:36:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752269AbZJTGgA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Oct 2009 02:36:00 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:60881 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750962AbZJTGgA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Oct 2009 02:36:00 -0400
Date: Tue, 20 Oct 2009 08:35:55 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Jeff Mahoney <jeffm@suse.com>, Peter Zijlstra <peterz@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>,
       linux-ia64@vger.kernel.org
Subject: Re: Commit 34d76c41 causes linker errors on ia64 with NR_CPUS=4096
Message-ID: <20091020063555.GJ8550@elte.hu>
References: <4ADB967A.4080707@suse.com> <alpine.LRH.2.00.0910200356340.20992@twin.jikos.cz> <alpine.LRH.2.00.0910200651510.20992@twin.jikos.cz> <20091020061557.GE8550@elte.hu> <alpine.LSU.2.00.0910200820500.8582@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.00.0910200820500.8582@wotan.suse.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jiri Kosina <jkosina@suse.cz> wrote:

> On Tue, 20 Oct 2009, Ingo Molnar wrote:
> 
> > > Commit 34d76c41 introduced percpu array update_shares_data, size of which 
> > > being proportional to NR_CPUS. Unfortunately this blows up ia64 for large 
> > > NR_CPUS configuration, as ia64 allows only 64k for .percpu section.
> > > 
> > > Fix this by allocating this array dynamically and keep only pointer to it 
> > > percpu.
> > > 
> > > Signed-off-by: Jiri Kosina <jkosina@suse.cz>
> > > --- 
> > >  kernel/sched.c |   15 +++++++--------
> > >  1 files changed, 7 insertions(+), 8 deletions(-)
> > 
> > Seems like an IA64 bug to me. 
> 
> IA64 guys actually use that as some kind of optimization for fast 
> access to the percpu data in their pagefault handler, as far as I 
> know.

Still looks like a bug if it causes a breakage (linker error) on IA64, 
and if the 'fix' (i'd call it a workaround) causes a (small but nonzero) 
performance regression on other architectures.

	Ingo
