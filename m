Return-Path: <linux-kernel-owner+w=401wt.eu-S1760844AbZCXP2g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760844AbZCXP2g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 11:28:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760120AbZCXP1P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 11:27:15 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:58118 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757428AbZCXP1O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 11:27:14 -0400
Date: Tue, 24 Mar 2009 11:27:10 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 3/3] function-graph: ignore times across schedule
In-Reply-To: <20090324135833.GB32043@elte.hu>
Message-ID: <alpine.DEB.2.00.0903241126340.22830@gandalf.stny.rr.com>
References: <20090324135422.026619569@goodmis.org> <20090324135610.441707783@goodmis.org> <20090324135833.GB32043@elte.hu>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 24 Mar 2009, Ingo Molnar wrote:

> * Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > From: Steven Rostedt <srostedt@redhat.com>
> > 
> > Impact: more accurate timings
> > 
> > The current method of function graph tracing does not take into
> > account the time spent when a task is not running. This shows functions
> > that call schedule have increased costs:
> > 
> >  3) + 18.664 us   |      }
> >  ------------------------------------------
> >  3)    <idle>-0    =>  kblockd-123
> >  ------------------------------------------
> > 
> >  3)               |      finish_task_switch() {
> >  3)   1.441 us    |        _spin_unlock_irq();
> >  3)   3.966 us    |      }
> >  3) ! 2959.433 us |    }
> >  3) ! 2961.465 us |  }
> 
> dunno - i actually like how it shows the _real_ elapsed time. Why is 
> this wrong?

OK,

I'll include a trace option called "sleep-time" to allow the user to 
decide to show this or not.

-- Steve

