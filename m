Return-Path: <linux-kernel-owner+w=401wt.eu-S1754176AbYAQEO5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754176AbYAQEO5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 23:14:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752653AbYAQEOs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 23:14:48 -0500
Received: from tomts40.bellnexxia.net ([209.226.175.97]:57493 "EHLO
	tomts40-srv.bellnexxia.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752554AbYAQEOr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 23:14:47 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aq4HAFRljkdMROHU/2dsb2JhbACBWKxr
Date: Wed, 16 Jan 2008 23:14:43 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Paul Mackerras <paulus@samba.org>
Cc: john stultz <johnstul@us.ibm.com>, Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>,
       Gregory Haskins <ghaskins@novell.com>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       Thomas Gleixner <tglx@linutronix.de>, Tim Bird <tim.bird@am.sony.com>,
       Sam Ravnborg <sam@ravnborg.org>, "Frank Ch. Eigler" <fche@redhat.com>,
       Steven Rostedt <srostedt@redhat.com>,
       Daniel Walker <dwalker@mvista.com>
Subject: Re: [RFC PATCH 16/22 -v2] add get_monotonic_cycles
Message-ID: <20080117041443.GA9513@Krystal>
References: <20080116031730.GA2164@Krystal> <Pine.LNX.4.58.0801152238130.19680@gandalf.stny.rr.com> <20080116145604.GB31329@Krystal> <1f1b08da0801161436k4a7ac1e3kd83590951e7bebb9@mail.gmail.com> <1200523867.6127.5.camel@localhost.localdomain> <Pine.LNX.4.58.0801161827450.17781@gandalf.stny.rr.com> <1200536889.6127.52.camel@localhost.localdomain> <20080117024000.GD2322@Krystal> <20080117025004.GE2322@Krystal> <18318.51622.37470.246611@cargo.ozlabs.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <18318.51622.37470.246611@cargo.ozlabs.ibm.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 23:06:58 up 74 days,  9:12,  4 users,  load average: 0.53, 0.41,
	0.47
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Paul Mackerras (paulus@samba.org) wrote:
> Mathieu Desnoyers writes:
> 
> > Sorry for self-reply, but I thought, in the past, of a way to make this
> > possible.
> > 
> > It would imply the creation of a new vsyscall : vgetschedperiod
> > 
> > It would read a counter that would increment each time the thread is
> > scheduled out (or in). It would be a per thread counter
> 
> It's very hard to do a per-thread counter in the VDSO, since threads
> in the same process see the same memory, by definition.  You'd have to
> have an array of counters and have some way for each thread to know
> which entry to read.  Also you'd have to find space for tens or
> hundreds of thousands of counters, since there can be that many
> threads in a process sometimes.
> 
> Paul.
> 

Crazy ideas :

Could we do something along the lines of the thread local storage ?

Or could we map a per-thread page that would contradict this
"definition" ?

Or can we move down the beginning of the user-space thread stack of 4
bytes (it's already put at a random address anyway) and use these 32
bits to put our variable ? We don't care if userspace also modifies it;
the kernel would blindly increment it, so there would be no security
concerns involved.

Mathieu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
