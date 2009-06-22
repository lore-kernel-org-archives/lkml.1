Return-Path: <linux-kernel-owner+w=401wt.eu-S1756548AbZFVNLR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756548AbZFVNLR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 09:11:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754412AbZFVNLE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 09:11:04 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:46898 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753858AbZFVNLD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 09:11:03 -0400
Date: Mon, 22 Jun 2009 15:10:50 +0200
From: Ingo Molnar <mingo@elte.hu>
To: eranian@gmail.com
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Performance analysis under Linux (was: Re: [GIT PULL] Performance
	Counters for Linux)
Message-ID: <20090622131050.GA600@elte.hu>
References: <20090611160329.GA3366@elte.hu> <7c86c4470906120256m545363d4h85a3e84a88291ac7@mail.gmail.com> <20090612102804.GA15914@elte.hu> <7c86c4470906181458l6985e13av6c503b34e4f3b1d3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7c86c4470906181458l6985e13av6c503b34e4f3b1d3@mail.gmail.com>
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

* stephane eranian <eranian@googlemail.com> wrote:

[...]
> Those represent very advanced and very useful PMUs. Having
> implemented user and kernel support for both of them, I can attest
> that they challenge any interfaces. But perfmon is the proof that
> those can be exposed with their full strength thru a generic
> kernel API. Therefore, I am relatively hopeful, there should be a
> way to expose them through your API.

The thing is, in my opinion the main challenge is not in and was
never in exposing as many PMU features as possible.

The main challenge is in:

   _also making it a useful solution to developers/users_

That is a key area where IMO perfcounters and perfmon differs. The 
challenge of performance analysis is in:

  1) Making the tool usage patterns as natural as possible. Make the
     tools transparent and configuration-less by default.

  2) Offer people the same rough set of common and robust features
     regardless on what CPU (or even architecture) they are on.
     Adding some CPU-specific feature (without generalizing it at
     the same time) _never_ worked well enough.

  3) Visualize the information in a rich way, making it work in as
     many development workflows as possible.

tools/perf/ offers the seeds to that - it is a "full solution" 
attempt at sane performance analysis tooling. It tries to be 
'Oprofile done right' and 'pfmon done right'.

'perf' tries to keep the best aspects of oprofile (its user-tooling 
work-flow in essence), based on a robust and tightly integrated 
kernel side - and tries to expand the range and type of analysis 
that can be done.

I do claim we had few if any sane performance analysis tools before 
under Linux, and i think we are still in the stone ages and still 
have a lot of work to do in this area.

As a sidenote, IMO Linux has become somewhat vulnerable to creeping 
featurities in the past few years partly because we simply dont have 
good enough tools that can _prove_ it in an easy way that a patch is 
having bad effects to performance.

I see many kernel developers using oprofile only as a last-ditch 
option - and that's a pity - running a profiler and interpreting its 
results should be as easy as editing a file or committing a change.

We've only scratched the surface really, and the main road ahead us 
is IMO not just in terms of PMU hw feature support depth (which is 
relatively straightforward), but in terms of walking the full 
distance and bringing it all to developers and putting it on their 
desk.

So for every "will you support advanced PMU feature X, Y and Z" 
question you ask, the first-level answer is: 'please show the 
developer usecase and integrate it into our tools so we can see how 
it all works and how useful it is'.

"A tool might want to do this" is not a good enough answer. We now 
have a working OSS tool-space with 'perf' where such arguments for 
more PMU features can be made in very specific terms: patches, 
numbers and comparisons. Actual hands-on utility, happy developers 
and faster apps is what matters in the end - not just the list of 
PMU features we expose.

	Ingo
