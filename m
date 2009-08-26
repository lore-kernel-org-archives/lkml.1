Return-Path: <linux-kernel-owner+w=401wt.eu-S1751659AbZHZGWX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751659AbZHZGWX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 02:22:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751193AbZHZGWW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 02:22:22 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:52547 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750902AbZHZGWW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 02:22:22 -0400
Subject: Re: [PATCH 08/12] add trace events for each syscall entry/exit
From: Peter Zijlstra <peterz@infradead.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Hendrik Brueckner <brueckner@linux.vnet.ibm.com>,
       Jason Baron <jbaron@redhat.com>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, laijs@cn.fujitsu.com, rostedt@goodmis.org,
       jiayingz@google.com, mbligh@google.com, lizf@cn.fujitsu.com,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
In-Reply-To: <20090825183119.GC2448@Krystal>
References: <20090825141547.GE6114@nowhere>
	 <20090825160237.GG4639@cetus.boeblingen.de.ibm.com>
	 <20090825162004.GA25058@Krystal> <20090825165912.GI6114@nowhere>
	 <20090825173107.GJ6114@nowhere>  <20090825183119.GC2448@Krystal>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Wed, 26 Aug 2009 08:21:09 +0200
Message-Id: <1251267669.7538.1195.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-08-25 at 14:31 -0400, Mathieu Desnoyers wrote:

> (Well, I do not have time currently to look into the gory details
> (sorry), but let's try to take a step back from the problem.)
> 
> The design proposal for this kthread behavior wrt syscalls is based on a
> very specific and current kernel behavior, that may happen to change and
> that I have actually seen proven incorrect. For instance, some
> proprietary Linux driver does very odd things with system calls within
> kernel threads, like invoking them with int 0x80.
> 
> Yes, this is odd, but do we really want to tie the tracer that much to
> the actual OS implementation specificities ?
> 
> That sounds like a recipe for endless breakages and missing bits of
> instrumentation.
> 
> So my advice would be: if we want to trace the syscall entry/exit paths,
> let's trace them for the _whole_ system, and find ways to make it work
> for corner-cases rather than finding clever ways to diminish
> instrumentation coverage.
> 
> Given the ret from fork example happens to be the first event fired
> after the thread is created, we should be able to deal with this problem
> by initializing the thread structure used by syscall exit tracing to an
> initial "ret from fork" value.

So you're saying we should let proprietary crap influence the design of
the kernel in any way?
