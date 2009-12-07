Return-Path: <linux-kernel-owner+w=401wt.eu-S1758672AbZLGH17@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758672AbZLGH17 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 02:27:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758576AbZLGH16
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 02:27:58 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:34753 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758527AbZLGH16 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 02:27:58 -0500
Date: Mon, 7 Dec 2009 08:27:52 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>, Tom Zanussi <tzanussi@gmail.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 2/2] perf lock: New subcommand "lock" to perf for
 analyzing lock statistics
Message-ID: <20091207072752.GG10868@elte.hu>
References: <20091115022135.GA5427@nowhere>
 <1260156884-8474-2-git-send-email-mitake@dcl.info.waseda.ac.jp>
 <20091207044125.GB5262@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091207044125.GB5262@nowhere>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> On Mon, Dec 07, 2009 at 12:34:44PM +0900, Hitoshi Mitake wrote:
> > This patch adds new subcommand "lock" to perf for analyzing lock usage statistics.
> > Current perf lock is very primitive. This cannot provide the minimum functions.
> > Of course I continue to working on this.
> > But too big patch is not good thing for you, so I post this.
> 
> Oh great!
> Yeah, the work can be done incrementally.
>
[...]
>
> 
> Very nice and promising!
> 
> I can't wait to try it.

ok, to ease testing i've created a new (and not yet permanent) topic 
tree for it to track this new perf feature: tip:perf/lock and pushed it 
out.

Note: because it's not yet in a final form i have not merged it into 
tip:master yet - when you are working on these bits you need to do this 
manually via:

  git merge tip/perf/lock

Also, we might need to rebase this branch as it's WIP, so the commit IDs 
are not permanent yet. But i thought it would be easier to do deltas on 
this basis.

Hitoshi-san, the patches did not have a Signed-off-by line from you, can 
i add them for you?

Also, i agree that the performance aspect is probably the most pressing 
issue. Note that 'perf bench sched messaging' is very locking intense so 
a 10x slowdown is not entirely unexpected - we still ought to optimize 
it all some more. 'perf lock' is an excellent testcase for this in any 
case.

Thanks,

	Ingo
