Return-Path: <linux-kernel-owner+w=401wt.eu-S1756196AbYLEKF4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756196AbYLEKF4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 05:05:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751482AbYLEKFs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 05:05:48 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:34345 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751476AbYLEKFr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 05:05:47 -0500
Date: Fri, 5 Dec 2008 11:05:19 +0100
From: Ingo Molnar <mingo@elte.hu>
To: David Miller <davem@davemloft.net>
Cc: tglx@linutronix.de, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, akpm@linux-foundation.org,
       eranian@googlemail.com, dada1@cosmosbay.com, robert.richter@amd.com,
       arjan@infradead.org, hpa@zytor.com, a.p.zijlstra@chello.nl,
       rostedt@goodmis.org, paulus@samba.org
Subject: Re: [patch 0/3] [Announcement] Performance Counters for Linux
Message-ID: <20081205100519.GA4430@elte.hu>
References: <20081204225345.654705757@linutronix.de> <20081204.171233.201039452.davem@davemloft.net> <20081205061012.GA12785@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081205061012.GA12785@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
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


* Ingo Molnar <mingo@elte.hu> wrote:

> > >  - No interaction with ptrace: any task (with sufficient permissions) can
> > >    monitor other tasks, without having to stop that task.
> > 
> > This isn't going to work.
> >
> > If you look at the things the perfmon libraries do, you do need to stop 
> > the task.
> >
> > Consider counter virtualization as the most direct example. [...]
> 
> Note that counter virtualization is not offered in the perfmon3 patchset that has 
> been posted to lkml. (It is part of the much larger 'full' perfmon patchset which 
> has not been submitted for integration)
> 
> Nevertheless we will offer counter virtualization in -v2 of our patchset [...]

i've just implemented it. Running an (infinite-loop) hello.c with 6 counters on a 
CPU that has only two counters now gives the expected:

 counter[0 cycles              ]:           3368245084 , delta: 842019470 events
 counter[1 instructions        ]:           1384678210 , delta: 346108294 events
 counter[2 cache-refs          ]:                  659 , delta: 150 events
 counter[3 cache-misses        ]:                    0 
 counter[4 branch-instructions ]:            266919398 , delta: 66731508 events
 counter[5 branch-misses       ]:                 1201 , delta: 315 events

This will be in -v2.

	Ingo
