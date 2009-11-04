Return-Path: <linux-kernel-owner+w=401wt.eu-S1755245AbZKDKmb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755245AbZKDKmb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 05:42:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755141AbZKDKmb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 05:42:31 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:58440 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751045AbZKDKma (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 05:42:30 -0500
Date: Wed, 4 Nov 2009 11:42:04 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Ian Campbell <Ian.Campbell@citrix.com>, Tejun Heo <tj@kernel.org>,
       "Paul E. McKenney" <paulmck@us.ibm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Correct nr_processes() when CPUs have been unplugged
Message-ID: <20091104104204.GA13194@elte.hu>
References: <1257243074.23110.779.camel@zakaz.uk.xensource.com> <20091103160734.GA21362@elte.hu> <alpine.DEB.1.10.0911031324380.32136@V090114053VZO-1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0911031324380.32136@V090114053VZO-1>
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


* Christoph Lameter <cl@linux-foundation.org> wrote:

> On Tue, 3 Nov 2009, Ingo Molnar wrote:
> 
> > Sidenote: percpu areas currently are kept allocated on x86.
> 
> They must be kept allocated for all possible cpus. Arch code cannot 
> decide to not allocate per cpu areas.
> 
> Search for "for_each_possible_cpu" in the source tree if you want more 
> detail.

This has come up in the past. On-demand deallocation of percpu areas is 
a future possibility that might be useful - see previous percpu 
discussions on lkml for details.

All in one, the conclusion is that we dont want it yet (on-demand 
allocation of them is perfectly fine for now) - i just wanted to mention 
that this is a _current_ situation and an implementational choice, which 
judgement could change in the future.

The more 'virtual' our abstraction of CPUs becomes, the less the notion 
of permanent allocation will be acceptable as time goes on.

Dynamic allocation concepts are natural and the new, generic percpu 
allocator makes it more feasible to eventually deallocate percpu areas. 
(Of course various for_each_possible_cpu() assumptions will have to be 
fixed in that case.)

	Ingo
