Return-Path: <linux-kernel-owner+w=401wt.eu-S1752732AbZIZPBH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752732AbZIZPBH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Sep 2009 11:01:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752345AbZIZPBG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Sep 2009 11:01:06 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:38280 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752161AbZIZPBE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Sep 2009 11:01:04 -0400
Date: Sat, 26 Sep 2009 17:01:03 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Ulrich Drepper <drepper@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       linux kernel <linux-kernel@vger.kernel.org>,
       linux-perf-users@vger.kernel.org
Subject: Re: [PATCH] perf tools: Dont use openat()
Message-ID: <20090926150103.GB30071@elte.hu>
References: <4ABB6EB7.7000002@gmail.com> <20090924131250.GA15132@elte.hu> <4ABB767D.6080004@gmail.com> <4ABBDF77.3090106@redhat.com> <4ABBE9B7.1050505@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ABBE9B7.1050505@gmail.com>
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


* Eric Dumazet <eric.dumazet@gmail.com> wrote:

> Ulrich Drepper a ??crit :
> > -----BEGIN PGP SIGNED MESSAGE-----
> > Hash: SHA1
> > 
> > Eric Dumazet wrote:
> >>> We can certainly remove that reliance - wanna send a patch for it?
> > 
> > Come on, the silliness has to stop.  The kernel must be recent and to
> > use it adequately the C library also must be recent.  And "recent" is
> > not even correct anymore: the functions are available for more then two
> > years.  Removing the use of the modern interfaces makes everything
> > slower and might even re-introduce race conditions my patch fixed.
> > 
> 
> First time I ear that C library *must* be recent. This was never
> mentionned in Documentation/Changes, "Minimal Requirements"
> 
> "perf list" can be 100x slower, and even racy, I dont mind. At all.
> 
> $ time perf list >/dev/null 2>/dev/null
> 
> real    0m0.001s
> user    0m0.000s
> sys     0m0.001s

Yep, doesnt look problematic from a performance POV.

> With openat(), I cannot use "perf" on machines I can only change 
> kernel, since changing glibc is too risky for legacy apps. I could use 
> static and private glibc, but last time I tried this I lost few hours 
> and failed.

Yeah, we generally dont want to force an upgrade of other components if 
possible. The fact that you ran into it in a pre -rc1 kernel means that 
there's a thousand others out there who will run into similar problems.

	Ingo
