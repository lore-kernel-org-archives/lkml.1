Return-Path: <linux-kernel-owner+w=401wt.eu-S934082AbZDHPka@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934082AbZDHPka (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 11:40:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933948AbZDHPjz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 11:39:55 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:36630 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933922AbZDHPjy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 11:39:54 -0400
Date: Wed, 8 Apr 2009 17:39:07 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: "Frank Ch. Eigler" <fche@redhat.com>, Andi Kleen <andi@firstfloor.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Vegard Nossum <vegard.nossum@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>,
       Avi Kivity <avi@redhat.com>,
       Satoshi Oshima <satoshi.oshima.fk@hitachi.com>,
       systemtap-ml <systemtap@sources.redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PROTO][PATCH -tip 0/7] kprobes: support jump
	optimization on x86
Message-ID: <20090408153907.GB3741@elte.hu>
References: <49DA7702.5030308@redhat.com> <20090408011743.GB5977@nowhere> <49DC0307.6080107@redhat.com> <20090408101056.GA14482@elte.hu> <20090408110602.GA14687@one.firstfloor.org> <20090408130150.GC13827@redhat.com> <49DCBC12.3040700@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49DCBC12.3040700@redhat.com>
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


* Masami Hiramatsu <mhiramat@redhat.com> wrote:

> Frank Ch. Eigler wrote:
> > On Wed, Apr 08, 2009 at 01:06:02PM +0200, Andi Kleen wrote:
> >> [...]
> >>> I'm curious: what is the biggest kprobe count you've ever seen, in 
> >>> the field? 1000? 10,000? 100,000? More?
> >> The limit is iirc how much memory the gcc compiling the probes program
> >> consumes before running out of swap space.
> > 
> > On a machine with lots of free RAM, gcc will not hold itself back.  On
> > my home server, a 40000-kprobe script compiled (pass 4) in about 4
> > seconds using about 200MB RAM.
> 
> Hm, when 40,000 kprobes are optimized, it will consume less than 
> 8MB ... I guess that is acceptable for recent machines.

That's more than acceptable, especially for some heavy 
instrumentation.

So we can forget about this "uses more memory" downside. Performance 
matters far more, and jprobes are fantastic in that regard.

	Ingo
