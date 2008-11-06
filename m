Return-Path: <linux-kernel-owner+w=401wt.eu-S1753700AbYKFGae@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753700AbYKFGae (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 01:30:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751166AbYKFGaZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 01:30:25 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:59180 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751388AbYKFGaZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 01:30:25 -0500
Date: Thu, 6 Nov 2008 07:30:12 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Ken Chen <kenchen@google.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [patch] sched: fix single-depth wchan output
Message-ID: <20081106063012.GA15731@elte.hu>
References: <b040c32a0811052158r4f6662dega3503a0c7ec72620@mail.gmail.com> <20081106061125.GA6384@elte.hu> <b040c32a0811052216i4594a094gdcee3ae280cddec7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b040c32a0811052216i4594a094gdcee3ae280cddec7@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ken Chen <kenchen@google.com> wrote:

> On Wed, Nov 5, 2008 at 10:11 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
> > hm, this adds overhead - and the thing is that WCHAN is rather 
> > uninformative to begin with (because it's a single dimension), so 
> > we should phase it out, not expand it.
> >
> > How about adding a /proc/<PID>/stacktrace file that gives us the 
> > stack trace of any task in the system? That would be useful for a 
> > number of other purposes as well, and about 100 times more useful 
> > than wchan. (often it would be more useful than sysrq-t dumps)
> 
> Sure, my main motivation is to remove frame pointer generation. 
> x86_64 unconditionally adds fp for kernel/sched.c right now.  I'm 
> all for phasing out wchan if people don't think there is value in 
> it.

are you interested in adding /proc/<PID>/stacktrace? If yes then we 
could remove fp generation for 64-bit right now and add your 
stacktrace patch when you are done with it.

Generally we want frame pointers for high quality backtraces and 
trouble-shooting. The small cost is almost always worth paying and 
most distros enable framepointers for that reason. On 32-bit a 
no-framepointers kernel image has less register pressure, but on 
64-bit there's little reason to not enable them.

	Ingo
