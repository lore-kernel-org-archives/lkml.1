Return-Path: <linux-kernel-owner+w=401wt.eu-S1761446AbZLJSvI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761446AbZLJSvI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 13:51:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761318AbZLJSvH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 13:51:07 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43646 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760986AbZLJSvG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 13:51:06 -0500
Date: Thu, 10 Dec 2009 13:50:44 -0500
From: "Frank Ch. Eigler" <fche@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Tim Bird <tim.bird@am.sony.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Thomas Gleixner <tglx@linutronix.de>,
       linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/4] ftrace - add function_duration tracer
Message-ID: <20091210185044.GC30999@redhat.com>
References: <4B202778.4030801@am.sony.com> <20091210070800.GB16874@elte.hu> <20091210120332.GA5042@nowhere> <20091210141121.GB1436@elte.hu> <1260456803.2146.167.camel@gandalf.stny.rr.com> <20091210153845.GA28230@elte.hu> <y0md42magc1.fsf@fche.csb> <20091210175737.GB5256@elte.hu> <20091210180412.GB30999@redhat.com> <20091210183508.GB17986@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091210183508.GB17986@elte.hu>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi -


On Thu, Dec 10, 2009 at 07:35:08PM +0100, Ingo Molnar wrote:
> [...]
> target_set.stp is not really adequate. Have you actually _tried_ to use 
> it on something real like hackbench, which runs thousands (or tens of 
> thousands) of tasks? You'll soon find that associative arrays are not 
> really adequate for that ... [...]

A few thousand entries in a hash table is really not that big a deal.


> > > Also, i dont think stap supports proper separation of per workload 
> > > measurements either. I.e. can you write a script that will work 
> > > properly even if multiple monitoring tools are running, each trying 
> > > to measure latencies?
> > 
> > Sure, always has.  You can run many scripts concurrently, each with 
> > its own internal state.  (Overheads accumulate, sadly & naturally.)
> 
> To measure latencies you need two probes, a start and a stop one. How do 
> you define a local variable that is visible to those two probes? You 
> have to create a global variable - but that will/can clash with other 
> instances.

You misunderstand systemtap "global" values.  They are global to that
particular execution of that particular script.  They are not shared
between scripts that may be concurrently running.


> ( Also, you dont offer per application channels/state from the same 
>   script. Each app has to define their own probes, duplicating the 
>   script and increasing probe chaining overhead. )

Please elaborate what you mean.


> > > Also, i personally find built-in kernel functionality more trustable 
> > > than dynamically built stap kernel modules that get inserted.
> > 
> > I understand.  In the absence of a suitable bytecode engine in the 
> > kernel, this was the only practical way to do everything we needed.
> 
> You seem to be under the mistaken assumption that your course of action 
> with SystemTap is somehow limited by what is available (or not) in the 
> upstream kernel. In reality you can implement anything you want [...]

The message we have received time, after time, after time was
stronger: that a suitable interpreter was not going to be welcome in
tree.  If this is relaxed (and perhaps even if not), we may prototype
such a thing in the new year.


- FChE
