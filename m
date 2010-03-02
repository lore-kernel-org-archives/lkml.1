Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753123Ab0CBR5q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 12:57:46 -0500
Received: from slow3-v.mail.gandi.net ([217.70.178.89]:47847 "EHLO
	slow3-v.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751546Ab0CBR5o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 12:57:44 -0500
X-WhiteListed: mail was accepted with no delay
X-WhiteListed: mail was accepted with no delay
Date: Tue, 2 Mar 2010 09:52:01 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: mingo@elte.hu, KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Nicholas Miell <nmiell@comcast.net>,
       Linus Torvalds <torvalds@linux-foundation.org>, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com, akpm@linux-foundation.org, dvhltc@us.ibm.com,
       niv@us.ibm.com, tglx@linutronix.de, peterz@infradead.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
       linux-kernel@vger.kernel.org, Nick Piggin <npiggin@suse.de>,
       Chris Friesen <cfriesen@nortel.com>
Subject: Re: [PATCH -tip] introduce sys_membarrier(): process-wide memory
 barrier (v9)
Message-ID: <20100302175200.GC7057@feather>
References: <20100225232316.GA30196@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100225232316.GA30196@Krystal>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 25, 2010 at 06:23:16PM -0500, Mathieu Desnoyers wrote:
> I am proposing this patch for the 2.6.34 merge window, as I think it is ready
> for inclusion.
> 
> Here is an implementation of a new system call, sys_membarrier(), which
> executes a memory barrier on all threads of the current process.
[...] 

> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Acked-by: Steven Rostedt <rostedt@goodmis.org>
> Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> CC: Nicholas Miell <nmiell@comcast.net>
> CC: Linus Torvalds <torvalds@linux-foundation.org>
> CC: mingo@elte.hu
> CC: laijs@cn.fujitsu.com
> CC: dipankar@in.ibm.com
> CC: akpm@linux-foundation.org
> CC: josh@joshtriplett.org

Acked-by: Josh Triplett <josh@joshtriplett.org>

I agree that v9 seems ready for inclusion.

Out of curiosity, do you have any benchmarks for the case of not
detecting sys_membarrier dynamically?  Detecting it at library
initialization time, for instance, or even just compiling to assume its
presence?  I'd like to know how much that would improve the numbers.

If significant, it might make sense to try to have a mechanism similar
to SMP alternatives, to have different code in either case.  dlopen,
function pointers, runtime code patching (nop out the rmb), or similar.

- Josh Triplett
