Return-Path: <linux-kernel-owner+w=401wt.eu-S1755004AbZCWGfi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755004AbZCWGfi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 02:35:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754076AbZCWGf3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 02:35:29 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:39434 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753557AbZCWGf2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 02:35:28 -0400
Date: Mon, 23 Mar 2009 07:34:56 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Roland McGrath <roland@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Steven Rostedt <rostedt@goodmis.org>, utrace-devel@redhat.com,
       Frank Eigler <fche@redhat.com>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 3/3] utrace-based ftrace "process" engine, v2
Message-ID: <20090323063456.GA7752@elte.hu>
References: <20090321013946.890F4FC3AB@magilla.sf.frob.com> <20090321014244.9ADF1FC3AB@magilla.sf.frob.com> <20090321074301.GA19384@elte.hu> <20090321013912.ed6039c9.akpm@linux-foundation.org> <20090321091235.GA29678@elte.hu> <20090323044940.870ECFC3AB@magilla.sf.frob.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090323044940.870ECFC3AB@magilla.sf.frob.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
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


* Roland McGrath <roland@redhat.com> wrote:

> > kernel/utrace.c should probably be introduced as 
> > kernel/trace/utrace.c not kernel/utrace.c. It also overlaps pending 
> > work in the tracing tree and cooperation would be nice and desired.
> 
> Of course I would like to cooperate with everyone.  And of course 
> it does not really matter much where a source file lives.  But 
> IMHO utrace really does not fit in with the kernel/trace/ code 
> much at all.  Sure, its hooks can be used by tracer 
> implementations that use CONFIG_TRACING stuff.  But it is a 
> general API about user thread state.  It belongs in kernel/trace/ 
> "naturally" far less than, say, kprobes.  utrace will in future be 
> used to implement userland features (ptrace et al) that are just 
> aspects of the basics of what an operating system does: mediate 
> userland for userland. Those uses will have nothing to do with 
> "kernel tracing".

But it is fitting if you think of kernel/trace/ as 
kernel/instrumentation/.

The virtualization-alike uses for utrace are in essence using system 
call instrumentation callbacks to inject extra functionality into 
the system. That's possible not because it's primarily geared at 
doing that, but because the instrumentation callbacks are generic 
and complete enough. It's still correct to think of it as an 
instrumentation tool and to maintain it as such. That also makes it 
clear that none of these APIs are to be regarded permanent ABIs.

Anyway ... placement is no big deal, and kernel/utrace.c is 
certainly a good way of avoiding the tracing tree ;-)

	Ingo
