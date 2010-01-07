Return-Path: <linux-kernel-owner+w=401wt.eu-S1752781Ab0AGO1n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752781Ab0AGO1n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 09:27:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752216Ab0AGO1n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 09:27:43 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:32970 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750951Ab0AGO1m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 09:27:42 -0500
X-Authority-Analysis: v=1.0 c=1 a=r_nf4N-T2GkA:10 a=7U3hwN5JcxgA:10 a=NxCurGSypRDGMPjQZM8A:9 a=EFXI3Qub4OP4sP8HFX8A:7 a=aa3d6ZXQn8yc7yoFLHHNtdqhbtQA:4 a=A0X8C_FPr_91ywAm:21 a=6eHwggJ0t_Z9e5q0:21
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [RFC PATCH] introduce sys_membarrier(): process-wide memory
 barrier
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: linux-kernel@vger.kernel.org,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
       josh@joshtriplett.org, tglx@linutronix.de, peterz@infradead.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com
In-Reply-To: <20100107061955.GC25786@Krystal>
References: <20100107044007.GA22863@Krystal>
	 <1262842854.28171.3710.camel@gandalf.stny.rr.com>
	 <20100107061955.GC25786@Krystal>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Thu, 07 Jan 2010 09:27:38 -0500
Message-ID: <1262874458.28171.3728.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-01-07 at 01:19 -0500, Mathieu Desnoyers wrote:

> I see your point.

Actually you are missing the point ;-)

> 
> This would probably be good for machines with very large number of cpus
> and without IPI broadcast support, running processes with only few
> threads. I really start to think that we should have some way to compare
> the number of threads belonging to a process and choose between the
> broadcast IPI and the per-cpu IPI depending if we are over or under an
> arbitrary threshold.


This has nothing to do with performance. It has to do with a thread
should not interfere with a thread belonging to another process. We
really don't care how long the sys_membarrier() takes (it's the slow
path anyway). We do care that a critical RT task is being interrupted by
some java thread sending thousands of IPIs.

-- Steve


