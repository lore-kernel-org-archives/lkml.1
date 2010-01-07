Return-Path: <linux-kernel-owner+w=401wt.eu-S1753494Ab0AGS7q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753494Ab0AGS7q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 13:59:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752184Ab0AGS7q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 13:59:46 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:58774 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751996Ab0AGS7p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 13:59:45 -0500
X-Authority-Analysis: v=1.0 c=1 a=r_nf4N-T2GkA:10 a=7U3hwN5JcxgA:10 a=A4rvb2VEmdymzsuO98sA:9 a=gaiv2k21_jbaHa4GltUA:7 a=ilSRbTLCZn0MZTDXsMxuIgPyeoIA:4
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [RFC PATCH] introduce sys_membarrier(): process-wide memory
 barrier
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: paulmck@linux.vnet.ibm.com
Cc: Oleg Nesterov <oleg@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       akpm@linux-foundation.org, josh@joshtriplett.org, tglx@linutronix.de,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com
In-Reply-To: <20100107183946.GL6764@linux.vnet.ibm.com>
References: <20100107044007.GA22863@Krystal>
	 <1262852862.4049.78.camel@laptop> <20100107183010.GA14980@redhat.com>
	 <20100107183946.GL6764@linux.vnet.ibm.com>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Thu, 07 Jan 2010 13:59:42 -0500
Message-ID: <1262890782.28171.3738.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-01-07 at 10:39 -0800, Paul E. McKenney wrote:

> > sys_membarrier() should "insert" mb() on behalf of B "instead"
> > of barrier(), right? But, if we send IPI, B enters kernel mode
> > and returns to user-mode. Should this imply mb() in any case?
> 
> Hello, Oleg,
> 
> The issue is with some suggested optimizations that would avoid sending
> the IPI to CPUs that are not running threads in the same process as the
> thread executing the sys_membarrier().  Some forms of these optimizations
> sample ->mm without locking, and the question is whether this is safe.

Note, we are not suggesting optimizations. It has nothing to do with
performance of the syscall. We just can't allow one process to be DoSing
another process on another cpu by it sending out millions of IPIs.
Mathieu already showed that you could cause a 2x slowdown to the
unrelated tasks.

-- Steve


