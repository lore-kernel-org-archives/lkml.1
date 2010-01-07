Return-Path: <linux-kernel-owner+w=401wt.eu-S1752312Ab0AGRos@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752312Ab0AGRos (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 12:44:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752251Ab0AGRoq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 12:44:46 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:65265 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752188Ab0AGRoj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 12:44:39 -0500
X-Authority-Analysis: v=1.0 c=1 a=r_nf4N-T2GkA:10 a=7U3hwN5JcxgA:10 a=YpAiJf3awIGcDPNwIloA:9 a=qNfy9n9ENiWBPCXZDRthvxmoek8A:4
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [RFC PATCH] introduce sys_membarrier(): process-wide memory
 barrier
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: paulmck@linux.vnet.ibm.com
Cc: Peter Zijlstra <peterz@infradead.org>,
       Josh Triplett <josh@joshtriplett.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       akpm@linux-foundation.org, tglx@linutronix.de, Valdis.Kletnieks@vt.edu,
       dhowells@redhat.com, laijs@cn.fujitsu.com, dipankar@in.ibm.com
In-Reply-To: <20100107173118.GG6764@linux.vnet.ibm.com>
References: <20100107044007.GA22863@Krystal>
	 <1262842854.28171.3710.camel@gandalf.stny.rr.com>
	 <20100107061955.GC25786@Krystal> <20100107063558.GC12939@feather>
	 <1262853855.4049.86.camel@laptop>
	 <20100107165249.GE6764@linux.vnet.ibm.com>
	 <1262884716.4049.103.camel@laptop>
	 <20100107173118.GG6764@linux.vnet.ibm.com>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Thu, 07 Jan 2010 12:44:37 -0500
Message-ID: <1262886277.28171.3734.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-01-07 at 09:31 -0800, Paul E. McKenney wrote:

> Something like the following for sys_membarrier(), then?
> 
>   smp_mb();
>   for_each_cpu(cpu, current->mm->cpu_vm_mask) {
>      if (cpu_curr(cpu)->mm == current->mm)
>         smp_call_function_single(cpu, func, NULL, 1);
>   }
> 
> Then the code changing ->mm on the other CPU also needs to have a
> full smp_mb() somewhere after the change to ->mm, but before starting
> user-space execution.  Which it might well just due to overhead, but
> we need to make sure that someone doesn't optimize us out of existence.

To change the mm requires things like flushing the TLB. I'd be surprised
if the change of the mm does not already do a smp_mb() somewhere.

-- Steve


