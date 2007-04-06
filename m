Return-Path: <linux-kernel-owner+w=401wt.eu-S1751905AbXDFTao@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751905AbXDFTao (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 15:30:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751943AbXDFTao
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 15:30:44 -0400
Received: from smtp.osdl.org ([65.172.181.24]:60300 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751905AbXDFTam (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 15:30:42 -0400
Date: Fri, 6 Apr 2007 12:30:09 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: David Howells <dhowells@redhat.com>, Jakub Jelinek <jakub@redhat.com>,
       Ulrich Drepper <drepper@redhat.com>, Andi Kleen <andi@firstfloor.org>,
       Rik van Riel <riel@redhat.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
       Hugh Dickins <hugh@veritas.com>
Subject: Re: preemption and rwsems (was: Re: missing madvise functionality)
Message-Id: <20070406123010.802c76b4.akpm@linux-foundation.org>
In-Reply-To: <20070406090822.GA2425@elte.hu>
References: <46128051.9000609@redhat.com>
	<p73648dz5oa.fsf@bingen.suse.de>
	<46128CC2.9090809@redhat.com>
	<20070403172841.GB23689@one.firstfloor.org>
	<20070403125903.3e8577f4.akpm@linux-foundation.org>
	<4612B645.7030902@redhat.com>
	<20070403202937.GE355@devserv.devel.redhat.com>
	<19526.1175777338@redhat.com>
	<20070405191129.GC22092@elte.hu>
	<20070405133742.88abc4f8.akpm@linux-foundation.org>
	<20070406090822.GA2425@elte.hu>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Apr 2007 11:08:22 +0200
Ingo Molnar <mingo@elte.hu> wrote:

> * Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > > getting a good trace of it is easy: pick up the latest -rt kernel 
> > > from:
> > > 
> > > 	http://redhat.com/~mingo/realtime-preempt/
> > > 
> > > enable EVENT_TRACING in that kernel, run the workload and do:
> > > 
> > > 	scripts/trace-it > to-ingo.txt
> > > 
> > > and send me the output.
> > 
> > Did that - no output was generated.  config at
> > http://userweb.kernel.org/~akpm/config-akpm2.txt
> 
> sorry, i forgot to mention that you should turn off 
> CONFIG_WAKEUP_TIMING.
> 
> i've attached an updated version of trace-it.c, which will turn this off 
> itself, using a sysctl. I also made WAKEUP_TIMING default-off.

ok.  http://userweb.kernel.org/~akpm/to-ingo.txt is the trace of

	taskset -c 0 ./jakubs-test-app

while the system was doing the 150,000 context switches/sec.

It isn't very interesting.
