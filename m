Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968155Ab0B0KEX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 05:04:23 -0500
Received: from ey-out-2122.google.com ([74.125.78.26]:16842 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S968113Ab0B0KEW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 05:04:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=jRuoNB2xW8uQ2o2HwZt/JcemSNujLptPMrFvAr00u2xNINTKDZt3xZGf0Fide37mAG
         LrcjQ14Z5a4/UnbDfkDcoRnfTlyZ6kb0rs0mrc5umsg6NojdCy7RbskwSJ88NdYySTuO
         ofsc1iXFq19c99udXik+7OjkpklmOIvUqkYQs=
Date: Sat, 27 Feb 2010 11:04:18 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
       Tim Bird <tim.bird@am.sony.com>
Subject: Re: [PATCH][GIT PULL] ftrace: Add function names to dangling } in
	function graph tracer
Message-ID: <20100227100417.GC5130@nowhere>
References: <1267230439.6328.149.camel@gandalf.stny.rr.com> <20100227094301.GC31794@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100227094301.GC31794@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 27, 2010 at 10:43:01AM +0100, Ingo Molnar wrote:
> >      [tracing] cat trace
> >      # tracer: function_graph
> >      #
> >      # CPU  DURATION                  FUNCTION CALLS
> >      # |     |   |                     |   |   |   |
> >       0) + 91.897 us   |                  } (irq_exit)
> >       0) ! 567.961 us  |                } (smp_apic_timer_interrupt)
> >       0)   <========== |
> >       0) ! 579.083 us  |                _raw_spin_lock_irqsave();
> >       0)   4.694 us    |                _raw_spin_unlock_irqrestore();
> >       0) ! 594.862 us  |              } (add_wait_queue)
> >       0) ! 603.361 us  |            } (__pollwait)
> >       0) ! 613.574 us  |          } (tcp_poll)
> >       0) ! 623.554 us  |        } (sock_poll)
> >       0)   3.653 us    |        fget_light();
> >       0)               |        sock_poll() {
> 
> Neat! I think it would read even more C-ish if it was something non-syntactic, 
> like:
> 
> >       0) ! 594.862 us  |              } /* add_wait_queue */
> >       0) ! 603.361 us  |            } /* __pollwait */
> >       0) ! 613.574 us  |          } /* tcp_poll */
> >       0) ! 623.554 us  |        } /* sock_poll */
> 
> hm?



Agreed. It won't even be confusing with other events that are
printed as comments, since we have the closing brace before.



> 
> 	Ingo

