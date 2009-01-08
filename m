Return-Path: <linux-kernel-owner+w=401wt.eu-S1760543AbZAHOZj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760543AbZAHOZj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 09:25:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756705AbZAHOZa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 09:25:30 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:65206 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756921AbZAHOZ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 09:25:29 -0500
Date: Thu, 8 Jan 2009 09:25:28 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Frederic Weisbecker <fweisbec@gmail.com>
cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH 2/2] tracing/branch-tracer: adapt to the stat tracing
 API
In-Reply-To: <20090108090501.GB6560@nowhere>
Message-ID: <alpine.DEB.1.10.0901080925090.22642@gandalf.stny.rr.com>
References: <4956b070.0c07560a.2b34.2325@mx.google.com> <alpine.DEB.1.10.0901072344260.2429@gandalf.stny.rr.com> <20090108090501.GB6560@nowhere>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 8 Jan 2009, Frederic Weisbecker wrote:

> On Wed, Jan 07, 2009 at 11:49:49PM -0500, Steven Rostedt wrote:
> > 
> > 
> > On Sat, 27 Dec 2008, Frederic Weisbecker wrote:
> > 
> > > This patch adapts the branch tracer to the tracing API.
> > > This is not really for inclusion but more likely a proof of concept because
> > > the branch tracer implements two "stat tracing" that were split in two files.
> > > 
> > > So I added an option to the branch tracer: stat_all_branch.
> > > If it is set, then trace_stat will output all of the branches entries stats.
> > > Otherwise, it will print the annotated branches.
> > > 
> > > Its is a kind of quick trick, waiting for a better solution.
> > > By default, the annotated branches stat are sorted by incorrect branch prediction
> > > percentage.
> > > 
> > 
> > OK, I have not had a chance to look at this code since it was sent when I 
> > was on Holiday. But I do not think that the only way to see the output of 
> > a histogram is to set it in the current_tracer. If I have the branch 
> > tracer on, I would have to run it to see the output of the histogram.
> > 
> > The histogram starts recording at boot up. Although the branch tracer is 
> > dependent on the histograms, the histogram is not dependent on the branch 
> > tracer. This code is making the histogram dependent on the trace. It took 
> > me a while to figure out how to see my histogram.
> > 
> > With the new patches (after the compile issue is solved) we could have a 
> > register_histogram or something that would put the file in the trace_stats 
> > directory. This would separate the need of coupling the tracers with the 
> > histogram even when they are not coupled.
> > 
> > -- Steve
> 
> You're right, that's a better and more scalable idea.
> Should I do it on top of the current patches (when the compile is fixed?).
> That will be more easy...

Yeah, that would be fine. Just make sure each patch works though.

Thanks,

-- Steve

