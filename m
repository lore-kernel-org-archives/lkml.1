Return-Path: <linux-kernel-owner+w=401wt.eu-S1753934AbZHZVeb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753934AbZHZVeb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 17:34:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753917AbZHZVea
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 17:34:30 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:56764 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753892AbZHZVe3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 17:34:29 -0400
Date: Wed, 26 Aug 2009 23:34:00 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Lameter <cl@linux-foundation.org>, peterz@infradead.org,
       raziebe@gmail.com, maximlevitsky@gmail.com, cfriesen@nortel.com,
       efault@gmx.de, riel@redhat.com, wiseman@macs.biu.ac.il,
       linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org
Subject: Re: RFC: THE OFFLINE SCHEDULER
Message-ID: <20090826213400.GA25536@elte.hu>
References: <1251298443.4791.7.camel@raz> <1251300625.18584.18.camel@twins> <alpine.DEB.1.10.0908261136590.9933@gentwo.org> <1251302598.18584.31.camel@twins> <alpine.DEB.1.10.0908261211340.9933@gentwo.org> <20090826180407.GA13632@elte.hu> <alpine.DEB.1.10.0908261509580.9933@gentwo.org> <20090826193252.GA14721@elte.hu> <alpine.DEB.1.10.0908261627110.5554@gentwo.org> <20090826135041.e6169d18.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090826135041.e6169d18.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Andrew Morton <akpm@linux-foundation.org> wrote:

> On Wed, 26 Aug 2009 16:40:09 -0400 (EDT)
> Christoph Lameter <cl@linux-foundation.org> wrote:
> 
> > Peter has not given a solution to the problem. Nor have you.
> 
> What problem?
> 
> All I've seen is "I want 100% access to a CPU".  That's not a problem
> statement - it's an implementation.
> 
> What is the problem statement?
> 
> My take on these patches: the kernel gives userspace unmediated 
> access to memory resources if it wants that. The kernel gives 
> userspace unmediated access to IO devices if it wants that. But 
> for some reason people freak out at the thought of providing 
> unmediated access to CPU resources.

Claiming all user-available CPU time from user-space is already 
possible: use SCHED_FIFO - the only question are remaining latencies 
in the final 0.01% of CPU time you cannot claim via SCHED_FIFO.

( Btw., this scheduling feature was implemented in Linux well before
  raw IO block devices were implemented, so i'm not sure what you
  mean by 'freaking out'. )

What we are objecting to are these easy isolation side-hacks for the 
remaining 0.01% that fail to address the real problem: the 
latencies. Those latencies can hurt not just isolated apps but _non 
isolated_ (and latency critical) apps too, and what we insist on is 
getting the proper fixes, not just ugly workarounds that side-step 
the problem.

( a secondary objection is the extension and extra layering
  of something that could be done within existing APIs/ABIs too. We
  want to minimize the configuration space. )

> Don't get all religious about this.  If the change is clean, 
> maintainable and useful then there's no reason to not merge it.

Precisely. This feature as proposed here hinders the correct 
solution being implemented - and hence hurts long term 
maintainability and hence is a no-merge right now. [It also weakens 
the pressure to fix latencies for a much wider set of applications, 
hence hurts the quality of Linux in the long run. (i.e. is a net 
step backwards)]

	Ingo
