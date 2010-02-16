Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932450Ab0BPA5x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 19:57:53 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:39604 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932299Ab0BPA5u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 19:57:50 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: paulmck@linux.vnet.ibm.com
Subject: Re: [RFC patch] introduce sys_membarrier(): process-wide memory barrier (v9)
Cc: kosaki.motohiro@jp.fujitsu.com,
       Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       Steven Rostedt <rostedt@goodmis.org>,
       Nicholas Miell <nmiell@comcast.net>,
       Linus Torvalds <torvalds@linux-foundation.org>, mingo@elte.hu,
       laijs@cn.fujitsu.com, dipankar@in.ibm.com, akpm@linux-foundation.org,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, Valdis.Kletnieks@vt.edu,
       dhowells@redhat.com
In-Reply-To: <20100215195916.GF6750@linux.vnet.ibm.com>
References: <20100212224606.GA30280@Krystal> <20100215195916.GF6750@linux.vnet.ibm.com>
Message-Id: <20100216093625.72B6.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue, 16 Feb 2010 09:57:46 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Fri, Feb 12, 2010 at 05:46:06PM -0500, Mathieu Desnoyers wrote:
> > Here is an implementation of a new system call, sys_membarrier(), which
> > executes a memory barrier on all threads of the current process. It can be used
> > to distribute the cost of user-space memory barriers asymmetrically by
> > transforming pairs of memory barriers into pairs consisting of sys_membarrier()
> > and a compiler barrier. For synchronization primitives that distinguish between
> > read-side and write-side (e.g. userspace RCU, rwlocks), the read-side can be
> > accelerated significantly by moving the bulk of the memory barrier overhead to
> > the write-side.
> > 
> > The first user of this system call is the "liburcu" Userspace RCU implementation
> > found at http://lttng.org/urcu. It aims at greatly simplifying and enhancing the
> > current implementation, which uses a scheme similar to the sys_membarrier(), but
> > based on signals sent to each reader thread.
> > 
> > Editorial question: 
> > 
> > This synchronization only takes care of threads using the current process memory
> > map. It should not be used to synchronize accesses performed on memory maps
> > shared between different processes. Is that a limitation we can live with ?
> 
> Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

Yes.

Personally, I think this patch's concept is clear and it can construct the base
of userland lockless programming.
If a userland programmer want to use lockless, hazard pointer is one of common
technique and this syscall help it.



