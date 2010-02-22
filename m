Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754554Ab0BVVX0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 16:23:26 -0500
Received: from mail.openrapids.net ([64.15.138.104]:40543 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753299Ab0BVVXY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 16:23:24 -0500
Date: Mon, 22 Feb 2010 16:23:21 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Chris Friesen <cfriesen@nortel.com>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Nicholas Miell <nmiell@comcast.net>,
       Linus Torvalds <torvalds@linux-foundation.org>, mingo@elte.hu,
       laijs@cn.fujitsu.com, dipankar@in.ibm.com, akpm@linux-foundation.org,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, Valdis.Kletnieks@vt.edu,
       dhowells@redhat.com
Subject: Re: [RFC patch] introduce sys_membarrier(): process-wide memory
	barrier (v9)
Message-ID: <20100222212321.GA2573@Krystal>
References: <20100212224606.GA30280@Krystal> <4B82CF1A.3010501@nortel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B82CF1A.3010501@nortel.com>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 16:19:43 up 30 days, 23:57,  3 users,  load average: 1.64, 2.09,
	2.13
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Chris Friesen (cfriesen@nortel.com) wrote:
> On 02/12/2010 04:46 PM, Mathieu Desnoyers wrote:
> 
> > Editorial question: 
> > 
> > This synchronization only takes care of threads using the current process memory
> > map. It should not be used to synchronize accesses performed on memory maps
> > shared between different processes. Is that a limitation we can live with ?
> 
> It makes sense for an initial version.  It would be unfortunate if this
> were a permanent limitation, since using separate processes with
> explicit shared memory is a useful way to mitigate memory trampler issues.
> 
> If we were going to allow that, it might make sense to add an address
> range such that only those processes which have mapped that range would
> execute the barrier.  Come to think of it, it might be possible to use
> this somehow to avoid having to execute the barrier on *all* threads
> within a process.

The extensible system call mandatory and optional flags will allow this kind of
improvement later on if this appears to be needed. It will also allow user-space
to detect if later kernels support these new features or not. But meanwhile I
think it's good to start with this implementation that covers 99.99% of
use-cases I can currently think of (ok, well, maybe I'm just unimaginative) ;)

Thanks,

Mathieu

> 
> Chris
