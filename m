Return-Path: <linux-kernel-owner+w=401wt.eu-S932173AbYB2AQh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932173AbYB2AQh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 19:16:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753878AbYB2AQ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 19:16:28 -0500
Received: from relay1.sgi.com ([192.48.171.29]:59834 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753473AbYB2AQ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 19:16:27 -0500
Date: Thu, 28 Feb 2008 18:16:11 -0600
From: Paul Jackson <pj@sgi.com>
To: David Rientjes <rientjes@google.com>
Cc: mingo@elte.hu, a.p.zijlstra@chello.nl, tglx@linutronix.de, oleg@tv-sign.ru,
       rostedt@goodmis.org, maxk@qualcomm.com, linux-kernel@vger.kernel.org
Subject: Re: [RFC/PATCH 0/4] CPUSET driven CPU isolation
Message-Id: <20080228181611.49671331.pj@sgi.com>
In-Reply-To: <alpine.DEB.1.00.0802281452340.13082@chino.kir.corp.google.com>
References: <20080227222103.673194000@chello.nl>
	<20080228075010.GA28781@elte.hu>
	<20080228020808.3fd22f77.pj@sgi.com>
	<20080228090847.GA1133@elte.hu>
	<20080228031710.3405e405.pj@sgi.com>
	<alpine.DEB.1.00.0802280129580.15900@chino.kir.corp.google.com>
	<alpine.DEB.1.00.0802280212070.23040@chino.kir.corp.google.com>
	<20080228113728.7b8e5811.pj@sgi.com>
	<alpine.DEB.1.00.0802281309480.24402@chino.kir.corp.google.com>
	<20080228164637.114fb19d.pj@sgi.com>
	<alpine.DEB.1.00.0802281452340.13082@chino.kir.corp.google.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David wrote:
> Move the watchdog/0 thread to a cpuset that doesn't have access to cpu 0.  

I still don't understand ... you must have some context in mind that
I've spaced out ... I can't even tell if that is a statement or a
question.

> I'd hesitate to do that unless you can guarantee that restricting 
> kthreads mems_allowed via the cpuset interface won't cause any problems 
> either.  Is there a benefit to reducing the size of a kthread's 
> mems_allowed that doesn't have an adverse effect on the kernel?  What 
> about kswapd?

Well ... I'm suspecting we've got this portion of our discussion wrapped
around the axle one time too many.

Backing up, hopefully unwrapping, you seemed to allow moving bound tasks
only to cpusets with the same cpus (how come you didn't check for the
same memory nodes too?).  If you really needed to move bound tasks at all,
then that seemed like an unnecessarily tight constraint.  It wouldn't hurt
the bound task to move to another cpuset that still allowed the CPUs it was
bound to.

... but after an another iteration of that subthread ... I'm wondering
why you have to move bound tasks at all.  How about PF_THREAD_BIND just
meaning (1) "can't be moved to any other cpuset", and (2) "always
placed in the top cpuset," so we don't have to worry about being unable
to move threads out of child cpusets.

Do you have any situation in which pinned threads have to be moved?

I don't.  Can we just prohibit it?

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
