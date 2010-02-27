Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968101Ab0B0JnN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 04:43:13 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:41259 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S968087Ab0B0JnJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 04:43:09 -0500
Date: Sat, 27 Feb 2010 10:43:01 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Tim Bird <tim.bird@am.sony.com>
Subject: Re: [PATCH][GIT PULL] ftrace: Add function names to dangling } in
 function graph tracer
Message-ID: <20100227094301.GC31794@elte.hu>
References: <1267230439.6328.149.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1267230439.6328.149.camel@gandalf.stny.rr.com>
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


* Steven Rostedt <rostedt@goodmis.org> wrote:

> 
> Ingo,
> 
> Please pull the latest tip/tracing/core tree, which can be found at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> tip/tracing/core
> 
> 
> Steven Rostedt (1):
>       ftrace: Add function names to dangling } in function graph tracer
> 
> ----
>  kernel/trace/trace_functions_graph.c |   52 ++++++++++++++++++++++++++++------
>  1 files changed, 43 insertions(+), 9 deletions(-)

Pulled, thanks Steve!

>      [tracing] cat trace
>      # tracer: function_graph
>      #
>      # CPU  DURATION                  FUNCTION CALLS
>      # |     |   |                     |   |   |   |
>       0) + 91.897 us   |                  } (irq_exit)
>       0) ! 567.961 us  |                } (smp_apic_timer_interrupt)
>       0)   <========== |
>       0) ! 579.083 us  |                _raw_spin_lock_irqsave();
>       0)   4.694 us    |                _raw_spin_unlock_irqrestore();
>       0) ! 594.862 us  |              } (add_wait_queue)
>       0) ! 603.361 us  |            } (__pollwait)
>       0) ! 613.574 us  |          } (tcp_poll)
>       0) ! 623.554 us  |        } (sock_poll)
>       0)   3.653 us    |        fget_light();
>       0)               |        sock_poll() {

Neat! I think it would read even more C-ish if it was something non-syntactic, 
like:

>       0) ! 594.862 us  |              } /* add_wait_queue */
>       0) ! 603.361 us  |            } /* __pollwait */
>       0) ! 613.574 us  |          } /* tcp_poll */
>       0) ! 623.554 us  |        } /* sock_poll */

hm?

	Ingo
