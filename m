Return-Path: <linux-kernel-owner+w=401wt.eu-S1755643AbZHUSQK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755643AbZHUSQK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 14:16:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753834AbZHUSQJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 14:16:09 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37884 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753335AbZHUSQI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 14:16:08 -0400
Date: Fri, 21 Aug 2009 11:13:31 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Andrew Morton <akpm@linux-foundation.org>
cc: Ingo Molnar <mingo@elte.hu>, linux-tip-commits@vger.kernel.org,
       Arjan van de Ven <arjan@infradead.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Dave Jones <davej@redhat.com>,
       Kyle McMartin <kyle@mcmartin.ca>, Greg KH <gregkh@suse.de>,
       linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       catalin.marinas@arm.com, a.p.zijlstra@chello.nl, jens.axboe@oracle.com,
       fweisbec@gmail.com, stable@kernel.org, srostedt@redhat.com,
       tglx@linutronix.de
Subject: Re: [tip:tracing/urgent] tracing: Fix too large stack usage in
 do_one_initcall()
In-Reply-To: <20090821104820.60948082.akpm@linux-foundation.org>
Message-ID: <alpine.LFD.2.01.0908211108000.3158@localhost.localdomain>
References: <tip-4a683bf94b8a10e2bb0da07aec3ac0a55e5de61f@git.kernel.org> <20090821111450.GA32037@elte.hu> <20090821104820.60948082.akpm@linux-foundation.org>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 21 Aug 2009, Andrew Morton wrote:
> 
> We seem to have overrun an 8k stack in
> http://bugzilla.kernel.org/show_bug.cgi?id=14029

The thread "v2.6.31-rc6: BUG: unable to handle kernel NULL pointer 
dereference at 0000000000000008" also has at least one oops that has 
that "Thread overran stack, or stack corrupted" marker thing.

> Do we have a max-stack-depth tracer widget btw?

Enable FTRACE and then STACK_TRACER. Then just do

	cat /sys/kernel/debug/tracing/stack_trace

and you'll get this.

But if by "widget" you meant something nice and automatic, then I don't 
think so.

> My main concern would be maintenance.  Over time we'll chew more and
> more stack space and eventually we'll get into trouble again.  What
> means do we have for holding the line at 8k, and even improving things?

That's why I think the async thing could fix this - if we _force_ async 
calls to be asynchronous, you won't have the deep callchains for all the 
device discovery thing.

		Linus
