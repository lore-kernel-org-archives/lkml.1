Return-Path: <linux-kernel-owner+w=401wt.eu-S1751891AbZJWMaG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751891AbZJWMaG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Oct 2009 08:30:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751637AbZJWMaF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Oct 2009 08:30:05 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50394 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751543AbZJWMaE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Oct 2009 08:30:04 -0400
Date: Fri, 23 Oct 2009 21:30:04 +0900 (JST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jkosina@wotan.suse.de
To: Ingo Molnar <mingo@elte.hu>
Cc: "Luck, Tony" <tony.luck@intel.com>, Tejun Heo <tj@kernel.org>,
       Jeff Mahoney <jeffm@suse.com>, Peter Zijlstra <peterz@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Yu, Fenghua" <fenghua.yu@intel.com>,
       "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>
Subject: Re: Commit 34d76c41 causes linker errors on ia64 with NR_CPUS=4096
In-Reply-To: <20091023075151.GB10067@elte.hu>
Message-ID: <alpine.LSU.2.00.0910232127410.9469@wotan.suse.de>
References: <4ADD54D4.70808@kernel.org> <4ADD5530.3050107@kernel.org> <alpine.LSU.2.00.0910200826220.8582@wotan.suse.de> <4ADDC69A.5000701@suse.com> <4ADDCDED.6060706@suse.com> <20091021061109.GA27195@elte.hu> <4ADF2691.7070304@kernel.org>
 <57C9024A16AD2D4C97DC78E552063EA3E337CF79@orsmsx505.amr.corp.intel.com> <alpine.LSU.2.00.0910221640430.8582@wotan.suse.de> <57C9024A16AD2D4C97DC78E552063EA3E337D94C@orsmsx505.amr.corp.intel.com> <20091023075151.GB10067@elte.hu>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Oct 2009, Ingo Molnar wrote:

> > > Tony, is the change that will eventually have to be made to ia64 
> > > pagefault handler too intrusive for -rc6, and should we rather go 
> > > with my workaround instead, and try to find something proper for 
> > > 2.6.33?
> > 
> > Using __alloc_percpu() rather than static declaration looks to be the 
> > right fix here.  Not a "workaround".
> 
> It is a workaround for the IA64 build failure.
> 
> It's also an improvement of the scheduler code (we generally try to 
> eliminate NR_CPUs scaling of allocations) - but code improvements need 
> to happen much sooner than -rc6/-rc7.

Unfortunately refactoring the ia4 pagefault handler would require some 
refactoring in order to eliminate the 64k limitation, as far as I know, 
which doesn't seem to be feasible for this timeframe either.

So if I personally have to chose from these two options, I'd prefer my 
patch for 2.6.32 and it'd be helpful if ia64 people could look into doing 
something with the 64k limit for 2.6.33.

Acceptable for everyone? Ingo/Peter, will you merge this asap please, so 
that we don't miss 2.6.32 with it?

Thanks,

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
