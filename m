Return-Path: <linux-kernel-owner+w=401wt.eu-S1760933AbXF0Gbh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760933AbXF0Gbh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 02:31:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758135AbXF0Gb3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 02:31:29 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:43534 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757526AbXF0Gb2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 02:31:28 -0400
Date: Wed, 27 Jun 2007 08:30:55 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       josh@freedesktop.org, dipankar@in.ibm.com
Subject: Re: [PATCH] Force rcutorture tasks to spread over CPUs
Message-ID: <20070627063055.GB3186@elte.hu>
References: <20070613042804.GA6132@linux.vnet.ibm.com> <20070626161317.767d5ec0.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070626161317.767d5ec0.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Andrew Morton <akpm@linux-foundation.org> wrote:

> On Tue, 12 Jun 2007 21:28:04 -0700
> "Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:
> 
> > +	while (!startwriters)
> > +		barrier();	/* Force scheduler to spread over CPUs. */
> 
> one wonders whether a cpu_relax() would be a bit nicer here.  That 
> implicitly does a barrier().
> 
> This patch doesn't make much sense for non-SMP builds?

i think this patch should be unnecessary because we found the real SMP 
balancing bug in the upstream scheduler causing this rcu problem, see:

 commit 92c4ca5c3a5e180e9762438db235f41d192cb955
 Author: Christoph Lameter <clameter@sgi.com>
 Date:   Sat Jun 23 17:16:33 2007 -0700

     sched: fix next_interval determination in idle_balance()

	Ingo
