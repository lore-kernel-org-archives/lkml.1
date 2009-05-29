Return-Path: <linux-kernel-owner+w=401wt.eu-S1758365AbZE2JHN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758365AbZE2JHN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 05:07:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756589AbZE2JHA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 05:07:00 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:38671 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757280AbZE2JG7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 05:06:59 -0400
Date: Fri, 29 May 2009 11:06:42 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>, mingo@redhat.com, hpa@zytor.com,
       acme@redhat.com, linux-kernel@vger.kernel.org, tglx@linutronix.de,
       cjashfor@linux.vnet.ibm.com, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perfcounters/core] perf stat: handle Ctrl-C
Message-ID: <20090529090642.GB21461@elte.hu>
References: <tip-58d7e993b16b62d30f8ef27757614056fe4def11@git.kernel.org> <18974.28935.538648.438570@cargo.ozlabs.ibm.com> <1243513143.6600.47.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1243513143.6600.47.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> On Thu, 2009-05-28 at 21:09 +1000, Paul Mackerras wrote:
> > tip-bot for Ingo Molnar writes:
> > 
> > > perf stat: handle Ctrl-C
> > > 
> > > Before this change, if a long-running perf stat workload was Ctrl-C-ed,
> > > the utility exited without displaying statistics.
> > > 
> > > After the change, the Ctrl-C gets propagated into the workload (and
> > > causes its early exit there), but perf stat itself will still continue
> > > to run and will display counter results.
> > > 
> > > This is useful to run open-ended workloads, let them run for
> > > a while, then Ctrl-C them to get the stats.
> > 
> > Unfortunately it means that if you do e.g.
> > 
> > $ while true; do perf stat something; done
> > 
> > it's impossible to kill the loop with ctrl-C.  To fix this we need to
> > make perf stat kill itself with the signal after printing the results,
> > so bash sees the died-due-to-signal exit status and stops the loop.
> 
> Yep, just ran into the same..
> 
> ^Z kill $! worked though, but that's not ideal.

would be nice to have a fix for this - i suspect people will run 
into this frequently.

	Ingo
