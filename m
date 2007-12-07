Return-Path: <linux-kernel-owner+w=401wt.eu-S1755847AbXLGNoh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755847AbXLGNoh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 08:44:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753398AbXLGNo3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 08:44:29 -0500
Received: from tomts40.bellnexxia.net ([209.226.175.97]:42505 "EHLO
	tomts40-srv.bellnexxia.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753325AbXLGNo2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 08:44:28 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ah4FACvdWEdMROHU/2dsb2JhbACBWo9P
Date: Fri, 7 Dec 2007 08:44:26 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: "Frank Ch. Eigler" <fche@redhat.com>
Cc: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch-RFC 00/26] LTTng Kernel Trace Thread Flag
Message-ID: <20071207134426.GA916@Krystal>
References: <20071206024243.397994403@polymtl.ca> <y0mmysnzf2q.fsf@ton.toronto.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <y0mmysnzf2q.fsf@ton.toronto.redhat.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 08:38:35 up 33 days, 18:44,  3 users,  load average: 0.46, 0.38,
	0.33
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Frank Ch. Eigler (fche@redhat.com) wrote:
> Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> writes:
> 
> > This is an RFC for addition of a new thread flag, TIF_KERNEL_TRACE, to each
> > architecture to activate system-wide system call tracing.
> > [...]
> 
> Instead of creating a new flag, could you overload TIF_SYSCALL_TRACE,
> putting the marker into syscall_trace(), and letting !PT_TRACED cause
> a skip over the ptrace notification logic?
> 
> - FChE

I don't see any PT_TRACED flag in current kernel HEAD ?

Hrm, let's see. If we share TIF_SYSCALL_TRACE with ptrace, we would then
have to figure out how to get this working :

- kernel tracing activated
- ptracing some random processes
- kernel tracing deactivated
- stop ptracing those processes

It means that we would have to keep some state information about the
ptrace status of each process. This is currently kept by
TIF_SYSCALL_TRACE, but since we would be overloading it, it would be
lost when we deactivate kernel tracing. Adding a supplementary field to
the thread_info structure is out of question here : we have to keep it
as small as possible. So where do you propose to keep this information
other than... another thread flag ?

Mathieu


-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
