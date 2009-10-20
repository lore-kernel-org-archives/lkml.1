Return-Path: <linux-kernel-owner+w=401wt.eu-S1754825AbZJTG0J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754825AbZJTG0J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Oct 2009 02:26:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753675AbZJTG0J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Oct 2009 02:26:09 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41970 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752134AbZJTG0I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Oct 2009 02:26:08 -0400
Date: Tue, 20 Oct 2009 08:26:11 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jkosina@wotan.suse.de
To: Ingo Molnar <mingo@elte.hu>
Cc: Jeff Mahoney <jeffm@suse.com>, Peter Zijlstra <peterz@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>,
       linux-ia64@vger.kernel.org
Subject: Re: Commit 34d76c41 causes linker errors on ia64 with NR_CPUS=4096
In-Reply-To: <20091020061557.GE8550@elte.hu>
Message-ID: <alpine.LSU.2.00.0910200820500.8582@wotan.suse.de>
References: <4ADB967A.4080707@suse.com> <alpine.LRH.2.00.0910200356340.20992@twin.jikos.cz> <alpine.LRH.2.00.0910200651510.20992@twin.jikos.cz> <20091020061557.GE8550@elte.hu>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Oct 2009, Ingo Molnar wrote:

> > Commit 34d76c41 introduced percpu array update_shares_data, size of which 
> > being proportional to NR_CPUS. Unfortunately this blows up ia64 for large 
> > NR_CPUS configuration, as ia64 allows only 64k for .percpu section.
> > 
> > Fix this by allocating this array dynamically and keep only pointer to it 
> > percpu.
> > 
> > Signed-off-by: Jiri Kosina <jkosina@suse.cz>
> > --- 
> >  kernel/sched.c |   15 +++++++--------
> >  1 files changed, 7 insertions(+), 8 deletions(-)
> 
> Seems like an IA64 bug to me. 

IA64 guys actually use that as some kind of optimization for fast access 
to the percpu data in their pagefault handler, as far as I know.

> It's _very_ easy to get more than 64K of percpu data - i'm wondering why 
> IA64 only triggered it now? Sure lockdep/lockstat must have triggered it 
> before.

Do we actually have lockdep on ia64?

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
