Return-Path: <linux-kernel-owner+w=401wt.eu-S1751645AbZJWHwI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751645AbZJWHwI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Oct 2009 03:52:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751300AbZJWHwH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Oct 2009 03:52:07 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:45511 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751214AbZJWHwF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Oct 2009 03:52:05 -0400
Date: Fri, 23 Oct 2009 09:51:51 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Jiri Kosina <jkosina@suse.cz>, Tejun Heo <tj@kernel.org>,
       Jeff Mahoney <jeffm@suse.com>, Peter Zijlstra <peterz@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Yu, Fenghua" <fenghua.yu@intel.com>,
       "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>
Subject: Re: Commit 34d76c41 causes linker errors on ia64 with NR_CPUS=4096
Message-ID: <20091023075151.GB10067@elte.hu>
References: <4ADD54D4.70808@kernel.org> <4ADD5530.3050107@kernel.org> <alpine.LSU.2.00.0910200826220.8582@wotan.suse.de> <4ADDC69A.5000701@suse.com> <4ADDCDED.6060706@suse.com> <20091021061109.GA27195@elte.hu> <4ADF2691.7070304@kernel.org> <57C9024A16AD2D4C97DC78E552063EA3E337CF79@orsmsx505.amr.corp.intel.com> <alpine.LSU.2.00.0910221640430.8582@wotan.suse.de> <57C9024A16AD2D4C97DC78E552063EA3E337D94C@orsmsx505.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <57C9024A16AD2D4C97DC78E552063EA3E337D94C@orsmsx505.amr.corp.intel.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Luck, Tony <tony.luck@intel.com> wrote:

> > Tony, is the change that will eventually have to be made to ia64 
> > pagefault handler too intrusive for -rc6, and should we rather go 
> > with my workaround instead, and try to find something proper for 
> > 2.6.33?
> 
> Using __alloc_percpu() rather than static declaration looks to be the 
> right fix here.  Not a "workaround".

It is a workaround for the IA64 build failure.

It's also an improvement of the scheduler code (we generally try to 
eliminate NR_CPUs scaling of allocations) - but code improvements need 
to happen much sooner than -rc6/-rc7.

	Ingo
