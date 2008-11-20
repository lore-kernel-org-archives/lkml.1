Return-Path: <linux-kernel-owner+w=401wt.eu-S1759511AbYKTPFA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759511AbYKTPFA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 10:05:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758129AbYKTOyc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 09:54:32 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:39589 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757460AbYKTOy3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 09:54:29 -0500
Date: Thu, 20 Nov 2008 15:53:53 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Milton Miller <miltonm@bga.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, linuxppc-dev@ozlabs.org
Subject: Re: [PATCH 0/9] powerpc: port of dynamic ftrace
Message-ID: <20081120145353.GA13550@elte.hu>
References: <20081119212204.318400312@goodmis.org> <20081120081307.GD21785@elte.hu> <alpine.DEB.1.10.0811200645510.17538@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0811200645510.17538@gandalf.stny.rr.com>
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


* Steven Rostedt <rostedt@goodmis.org> wrote:

>     branch: ppc/ftrace-disable
> 
> 
> Matt Fleming (1):
>       ftrace: align __mcount_loc sections
> 
> Steven Rostedt (8):
>       ftrace: disable dynamic ftrace from PowerPC
>       powerpc: ftrace, do not latency trace idle
>       powerpc: ftrace, convert to new dynamic ftrace arch API
>       powerpc/ppc64: ftrace, mcount record powerpc port
>       powerpc: ftrace, use probe_kernel API to modify code
>       powerpc/ppc64: ftrace, handle module trampolines for dyn ftrace
>       powerpc/ppc32: ftrace, enabled dynamic ftrace
>       powerpc/ppc32: ftrace, dynamic ftrace to handle modules
> 
> ----
>  arch/powerpc/Kconfig              |    2 +
>  arch/powerpc/include/asm/ftrace.h |   14 +-
>  arch/powerpc/include/asm/module.h |   16 ++-
>  arch/powerpc/kernel/ftrace.c      |  473 +++++++++++++++++++++++++++++++++---
>  arch/powerpc/kernel/idle.c        |    5 +
>  arch/powerpc/kernel/module_32.c   |   10 +
>  arch/powerpc/kernel/module_64.c   |   13 +
>  kernel/trace/Kconfig              |    1 +
>  scripts/recordmcount.pl           |   20 ++-
>  9 files changed, 511 insertions(+), 43 deletions(-)
> 
> There is a dependency on Matt's commit for one of the PPC commits to 
> apply.  I could hack that commit to work without Matt's patch, but 
> then that just postpones conflicts later on.
> 
> Matt's change is this:
> 
>  scripts/recordmcount.pl           |   20 ++-

looks much better and the (minimal) generic impact is OK i think - as 
long as Paul Acks the powerpc changes we could freeze that branch (so 
that Paul can pull it in a few weeks) and base your ftrace-powerpc 
work on that.

( The branch should still be named something constructive like 
  powerpc-ftrace-v29 or so - not ppc/ftrace-disable - but that's a 
  detail. )

	Ingo
