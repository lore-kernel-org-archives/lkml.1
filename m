Return-Path: <linux-kernel-owner+w=401wt.eu-S1753310AbXDEUiL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753310AbXDEUiL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 16:38:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753209AbXDEUiK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 16:38:10 -0400
Received: from smtp.osdl.org ([65.172.181.24]:50879 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753313AbXDEUiH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 16:38:07 -0400
Date: Thu, 5 Apr 2007 13:37:42 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: David Howells <dhowells@redhat.com>, Jakub Jelinek <jakub@redhat.com>,
       Ulrich Drepper <drepper@redhat.com>, Andi Kleen <andi@firstfloor.org>,
       Rik van Riel <riel@redhat.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
       Hugh Dickins <hugh@veritas.com>
Subject: Re: preemption and rwsems (was: Re: missing madvise functionality)
Message-Id: <20070405133742.88abc4f8.akpm@linux-foundation.org>
In-Reply-To: <20070405191129.GC22092@elte.hu>
References: <20070404160006.8d81a533.akpm@linux-foundation.org>
	<46128051.9000609@redhat.com>
	<p73648dz5oa.fsf@bingen.suse.de>
	<46128CC2.9090809@redhat.com>
	<20070403172841.GB23689@one.firstfloor.org>
	<20070403125903.3e8577f4.akpm@linux-foundation.org>
	<4612B645.7030902@redhat.com>
	<20070403202937.GE355@devserv.devel.redhat.com>
	<19526.1175777338@redhat.com>
	<20070405191129.GC22092@elte.hu>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 Apr 2007 21:11:29 +0200
Ingo Molnar <mingo@elte.hu> wrote:

> 
> * David Howells <dhowells@redhat.com> wrote:
> 
> > But short of recording the lock sequence, I don't think there's anyway 
> > to find out for sure.  printk probably won't cut it as a recording 
> > mechanism because its overheads are too great.
> 
> getting a good trace of it is easy: pick up the latest -rt kernel from:
> 
> 	http://redhat.com/~mingo/realtime-preempt/
> 
> enable EVENT_TRACING in that kernel, run the workload 
> and do:
> 
> 	scripts/trace-it > to-ingo.txt
> 
> and send me the output.

Did that - no output was generated.  config at
http://userweb.kernel.org/~akpm/config-akpm2.txt

> It will be large but interesting. That should 
> get us a whole lot closer to what happens. A (much!) more finegrained 
> result would be to also enable FUNCTION_TRACING and to do:
> 
> 	echo 1 > /proc/sys/kernel/mcount_enabled
> 
> before running trace-it.

Did that - still no output.

I did get an interesting dmesg spew:
http://userweb.kernel.org/~akpm/dmesg-akpm2.txt
