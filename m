Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933065Ab0BYRZm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 12:25:42 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:47430 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933011Ab0BYRZi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 12:25:38 -0500
X-Authority-Analysis: v=1.0 c=1 a=r_nf4N-T2GkA:10 a=7U3hwN5JcxgA:10 a=uL_z7Zi1cfH8U8xzjz0A:9 a=s9VoDLb1cgqNKo7i0SAQkMX1HVcA:4
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [RFC patch] introduce sys_membarrier(): process-wide memory
 barrier (v9)
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Nick Piggin <npiggin@suse.de>, Chris Friesen <cfriesen@nortel.com>,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Nicholas Miell <nmiell@comcast.net>,
       Linus Torvalds <torvalds@linux-foundation.org>, mingo@elte.hu,
       laijs@cn.fujitsu.com, dipankar@in.ibm.com, akpm@linux-foundation.org,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, Valdis.Kletnieks@vt.edu,
       dhowells@redhat.com
In-Reply-To: <20100225165301.GF24052@Krystal>
References: <20100212224606.GA30280@Krystal> <4B82CF1A.3010501@nortel.com>
	 <20100222212321.GA2573@Krystal> <20100224091052.GY9738@laptop>
	 <20100224152251.GA16295@Krystal> <20100225053310.GA9738@laptop>
	 <20100225165301.GF24052@Krystal>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Thu, 25 Feb 2010 12:25:26 -0500
Message-ID: <1267118726.6328.20.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-02-25 at 11:53 -0500, Mathieu Desnoyers wrote:

> > It would be very trivial compared to the process-private case. Just IPI
> > all CPUs. It would allow older kernels to work with newer process based
> > apps as they get implemented. But... not a really big deal I suppose.
> 
> This is actually what I did in v1 of the patch, but this implementation met
> resistance from the RT people, who were concerned about the impact on RT tasks
> of a lower priority process doing lots of sys_membarrier() calls. So if we want
> to do other-process-aware sys_membarrier(), we would have to iterate on all
> cpus, for every running process shared memory maps and see if there is something
> shared with all shm of the current process. This is clearly not as trivial as
> just broadcasting the IPI to all cpus.

Right, it may require another syscall or parameter to let the tasks
register a shared page. Then have some mechanism to find a way to
quickly check if a CPU is running a process with that page.

-- Steve


