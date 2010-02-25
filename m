Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752739Ab0BYFXK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 00:23:10 -0500
Received: from cantor.suse.de ([195.135.220.2]:45891 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751750Ab0BYFXG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 00:23:06 -0500
Date: Thu, 25 Feb 2010 16:22:54 +1100
From: Nick Piggin <npiggin@suse.de>
To: Darren Hart <dvhltc@us.ibm.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
       Chris Friesen <cfriesen@nortel.com>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Nicholas Miell <nmiell@comcast.net>,
       Linus Torvalds <torvalds@linux-foundation.org>, mingo@elte.hu,
       laijs@cn.fujitsu.com, dipankar@in.ibm.com, akpm@linux-foundation.org,
       josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
       peterz@infradead.org, Valdis.Kletnieks@vt.edu, dhowells@redhat.com
Subject: Re: [RFC patch] introduce sys_membarrier(): process-wide memory
 barrier (v9)
Message-ID: <20100225052254.GZ9738@laptop>
References: <20100212224606.GA30280@Krystal>
 <4B82CF1A.3010501@nortel.com>
 <20100222212321.GA2573@Krystal>
 <20100224091052.GY9738@laptop>
 <4B85620A.7000901@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B85620A.7000901@us.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 24, 2010 at 09:29:46AM -0800, Darren Hart wrote:
> Nick Piggin wrote:
> 
> >When writing multiprocessor scalable software, threads should often be
> >avoided. They share so much state that it is easy to run into
> >scalability issues in the kernel. So yes it would be really nice to
> >have userspace RCU available in a process-shared mode.
> 
> A bit off topic, but I'm interested in what you feel some of these
> scalability issues are. Is it mostly bouncing this shared context
> from one CPU to the next and the related cache effects, or is there
> something more you are referring to?

Just in general shared state is almost always going to be more costly in
SMP than non-shared.

>From VM to files and fs state to signals and timers and process
accounting. And this also carries up to libc, and critical user code
like the heap allocator.

Linux is usually pretty good, a lot due to RCU, but there are still
contention points.

Andrew had investigated this a lot (in relation to samba) and had a good
talk on it, but the slides don't really do it justice.
http://www.samba.org/~tridge/talks/threads.pdf

