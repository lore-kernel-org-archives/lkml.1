Return-Path: <linux-kernel-owner+w=401wt.eu-S1755241AbZKDKlL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755241AbZKDKlL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 05:41:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755168AbZKDKlL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 05:41:11 -0500
Received: from ns.dcl.info.waseda.ac.jp ([133.9.216.194]:59633 "EHLO
	ns.dcl.info.waseda.ac.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755054AbZKDKlK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 05:41:10 -0500
Date: Wed, 04 Nov 2009 19:41:08 +0900 (JST)
Message-Id: <20091104.194108.635980116686317754.mitake@dcl.info.waseda.ac.jp>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, rusty@rustcorp.com.au, tglx@linutronix.de,
       a.p.zijlstra@chello.nl, efault@gmx.de, acme@redhat.com,
       fweisbec@gmail.com
Subject: Re: [PATCH v2 3/7] Adding general performance benchmarking
 subcommand to perf.
From: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
In-Reply-To: <20091103172926.GC11535@elte.hu>
References: <20091103.195535.789626513029853730.mitake@dcl.info.waseda.ac.jp>
	<20091103172926.GC11535@elte.hu>
X-Mailer: Mew version 5.2 on Emacs 22.2 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH v2 3/7] Adding general performance benchmarking subcommand to perf.
Date: Tue, 3 Nov 2009 18:29:26 +0100

> 
> * Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp> wrote:
> 
> > 
> > Adding general performance benchmarking subcommand to perf.
> > This patch adds bench/sched-pipe.c.
> > 
> > bench/sched-pipe.c is a benchmark program
> > to measure performance of pipe() system call.
> > This benchmark is based on pipe-test-1m.c by Ingo Molnar.
> > http://people.redhat.com/mingo/cfs-scheduler/tools/pipe-test-1m.c
> > 
> > Example of use:
> > % perf bench sched pipe               # Use default options
> > 4.575  	     	   		      # Result is time
> > % perf bench sched pipe -l 2000	      # This option means "loop 2000 counts"
> > 0.024
> 
> ok, -l makes sense.
> 
> Shouldnt we output the unit of measurement, i.e. '4.575 usecs'? Also, we 
> should perhaps print something like:
> 
>   % perf bench sched pipe
> 
>   (executing 1000000 pipe operations between two tasks)
> 
>      4.575 usecs per op
>     218579 ops/sec   
> 
> ?

I have to admit that single float value output is too simple.
So I'll fix the default output.

But, I believe that simple form makes sense for
processing by scripts or graph tools like gnuplot.
I'll add the option (may be --simple) to switch
friendliness of outputs.

Tools like automatic graph generator
will be helpful for us. I'll write it after
completion of current work.

I'll send new patch series including help improvement
you told in previous mail later.
