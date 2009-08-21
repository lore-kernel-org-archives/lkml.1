Return-Path: <linux-kernel-owner+w=401wt.eu-S932433AbZHUSez@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932433AbZHUSez (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 14:34:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755652AbZHUSey
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 14:34:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41496 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755552AbZHUSex (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 14:34:53 -0400
Subject: Re: [tip:tracing/urgent] tracing: Fix too large stack usage in
 do_one_initcall()
From: Steven Rostedt <srostedt@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       linux-tip-commits@vger.kernel.org,
       Arjan van de Ven <arjan@infradead.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Dave Jones <davej@redhat.com>,
       Kyle McMartin <kyle@mcmartin.ca>, Greg KH <gregkh@suse.de>,
       linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       catalin.marinas@arm.com, a.p.zijlstra@chello.nl, jens.axboe@oracle.com,
       fweisbec@gmail.com, stable@kernel.org, tglx@linutronix.de
In-Reply-To: <alpine.LFD.2.01.0908211108000.3158@localhost.localdomain>
References: <tip-4a683bf94b8a10e2bb0da07aec3ac0a55e5de61f@git.kernel.org>
	 <20090821111450.GA32037@elte.hu>
	 <20090821104820.60948082.akpm@linux-foundation.org>
	 <alpine.LFD.2.01.0908211108000.3158@localhost.localdomain>
Content-Type: text/plain
Organization: Red Hat
Date: Fri, 21 Aug 2009 14:30:39 -0400
Message-Id: <1250879439.2964.3.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-08-21 at 11:13 -0700, Linus Torvalds wrote:
> 
> On Fri, 21 Aug 2009, Andrew Morton wrote:
> > 
> > Do we have a max-stack-depth tracer widget btw?
> 
> Enable FTRACE and then STACK_TRACER. Then just do
> 
> 	cat /sys/kernel/debug/tracing/stack_trace
> 
> and you'll get this.

Just a nitpick, but you will want to also add "stacktrace" to the kernel
command line otherwise it is default off. If you forget to do that, you
can also enable it with /proc/sys/kernel/stack_tracer_enabled.

But if you forget what to do, the code will remind you:

[root@mxf ~]# cat /sys/kernel/debug/tracing/stack_trace 
        Depth    Size   Location    (-1 entries)
        -----    ----   --------
#
#  Stack tracer disabled
#
# To enable the stack tracer, either add 'stacktrace' to the
# kernel command line
# or 'echo 1 > /proc/sys/kernel/stack_tracer_enabled'
#


-- Steve


