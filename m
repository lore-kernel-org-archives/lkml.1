Return-Path: <linux-kernel-owner+w=401wt.eu-S1756483AbYANWnt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756483AbYANWnt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 17:43:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753141AbYANWnl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 17:43:41 -0500
Received: from nz-out-0506.google.com ([64.233.162.225]:47573 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750982AbYANWnk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 17:43:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=VejlU5Cp+/Hv51ITmeoEP808ngcWZuI/A0jwJ/2CjcjjuHxcf5IHlLF2ZYxwSF3jjCcwIF9u9plUTiIbadV6NkjlzJt+f0sMcshT2UWbLQEXln9YxKwR/Z195zO1wtX+xtE09R3K7wkLHAaOxZHGfI6taDrqmi6+BFRmzQrlaY8=
Message-ID: <cf3edd8d0801141443r988a340n10d2940501117832@mail.gmail.com>
Date: Mon, 14 Jan 2008 22:43:37 +0000
From: "Colin Fowler" <elethiomel@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: Performance loss 2.6.22->22.6.23->2.6.24-rc7 on CPU intensive benchmark on 8 Core Xeon
Cc: linux-kernel@vger.kernel.org, "Peter Zijlstra" <a.p.zijlstra@chello.nl>
In-Reply-To: <cf3edd8d0801141442nedf4ac1p6b1fd6bc94900063@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <cf3edd8d0801140937w755c3e75me83c214ebc1f4cd3@mail.gmail.com>
	 <20080114185520.GA26540@elte.hu>
	 <cf3edd8d0801141442nedf4ac1p6b1fd6bc94900063@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Forgot to add that the results are at http://vangogh.cs.tcd.ie/fowler/cfs/


On Jan 14, 2008 10:42 PM, Colin Fowler <elethiomel@gmail.com> wrote:
> Hi Ingo, thanks for the reply.
>
> Modifying /proc/sys/kernel/sched_latency_ns to be double may have in
> fact made things slightly worse. I used 24-rc7
>
> Your script was only written to run for 15 seconds, so I ran it so it
> multiple times so it covered most of the benchmark.
> Other issues with these data may be that for much of the benchmark I
> am building data structures utilizing at most 1 to 3 cores. I'm not
> concerned with these timings personally as this is considered the
> offline part of the render. Once these data structures are built I
> proceed to render across 8 cores. This is the section of the benchmark
> I get my timings from ( I use RDTSC before and after the render
> segment). The majority of the overall time taken for a run is
> therefore data structure building. I do not time this.
>
> Colin.
>
>
>
> On Jan 14, 2008 6:55 PM, Ingo Molnar <mingo@elte.hu> wrote:
> >
> > * Colin Fowler <elethiomel@gmail.com> wrote:
> >
> > > Benchmark : A ray-trace is performed on 500 times on 17 separate
> > > scenes. Workload is distributed by tiling the framebuffer into N 32x32
> > > pixel tiles. Each CPU grabs one of N tiles out of the queue and
> > > repeats until no jobs are left. Rendering is to a shared framebuffer
> > > (obviously this causes problems with caching). Locking and
> > > synchronization is done using pthreads.
> > >
> > > Other details: The system is cleanly booted for each run. No I/O is
> > > performed during the timed portions of the test. The benchmark does
> > > however read a model file from the drive and build a data structure
> > > from it before each timed portion.
> > >
> > > On the 2.6.22 series of kernels results are pretty much the same. On
> > > 2.6.23 series kernels I see a loss in speed of ~2% across the board.
> > > On 2.6.24-rc7 that loss in speed is perhaps very slightly worse (~3%).
> > > 2.6.22 Kernels tested: 22.9(Ubuntu Stock Kernel), 22.14, 22.15
> > > 2.6.23 Kernels tested: 23.1, 23.3,  23.13
> > > 2.6.24 Kernels tested: 24-rc7
> > >
> > > I have my kernel compiled to use the SLAB allocator. All other
> > > tweaking options are set as defaults. My config files are available at
> > > http://vangogh.cs.tcd.ie/fowler/configs . Perhaps I'm configuring
> > > something wrong for the type of work I do?
> >
> > Could you try CONFIG_SCHED_DEBUG=y and CONFIG_SCHEDSTATS=y and double
> > the value of /proc/sys/kernel/sched_latency_ns - does that make any
> > difference? Please also run the following script while the ray-trace app
> > is running:
> >
> >   http://people.redhat.com/mingo/cfs-scheduler/tools/cfs-debug-info.sh
> >
> > and send me the output of it, so that we can have an idea about what's
> > going on in your system during this workload.
> >
> >         Ingo
> >
>
