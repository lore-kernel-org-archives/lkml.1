Return-Path: <linux-kernel-owner+w=401wt.eu-S1755464AbYIGNJW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755464AbYIGNJW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2008 09:09:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753720AbYIGNJN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Sep 2008 09:09:13 -0400
Received: from casper.infradead.org ([85.118.1.10]:54196 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753194AbYIGNJN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2008 09:09:13 -0400
Subject: Re: [RFC 07/13] sched: Reduce stack size requirements in
 kernel/sched.c
From: Peter Zijlstra <peterz@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mike Travis <travis@sgi.com>, Ingo Molnar <mingo@elte.hu>,
       davej@codemonkey.org.uk, David Miller <davem@davemloft.net>,
       Eric Dumazet <dada1@cosmosbay.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Jack Steiner <steiner@sgi.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Jes Sorensen <jes@sgi.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
In-Reply-To: <20080907040009.611ac986.akpm@linux-foundation.org>
References: <20080906235036.891970000@polaris-admin.engr.sgi.com>
	 <20080906235037.880702000@polaris-admin.engr.sgi.com>
	 <1220783087.8687.73.camel@twins.programming.kicks-ass.net>
	 <20080907040009.611ac986.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Sun, 07 Sep 2008 15:05:50 +0200
Message-Id: <1220792750.8687.88.camel@twins.programming.kicks-ass.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.23.91 (2.23.91-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2008-09-07 at 04:00 -0700, Andrew Morton wrote:
> On Sun, 07 Sep 2008 12:24:47 +0200 Peter Zijlstra <peterz@infradead.org> wrote:
> 
> > get_online_cpus() can sleep, but you just disabled preemption with those
> > get_cpumask_var() horribles!
> 
> make cpu_hotplug.refcount an atomic_t.

A much easier fix is just re-ordering those operations and do the
get_online_cpus() before disabling preemption. But it does indicate this
patch series isn't carefully constructed.

> > Couldn't be arsed to look through the rest, but I really hate this
> > cpumask_ptr() stuff that relies on disabling preemption.
> 
> that's harder to fix ;)

Looking at more patches than just the sched one convinced me more that
this approach isn't a good one. It seems to make code much more
fragile. 

See patch 9, there it was needed to draw out the callgraph in order to
map stuff to these global variables - we're adding global dependencies
to code that didn't have any, increasing complexity.



