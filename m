Return-Path: <linux-kernel-owner+w=401wt.eu-S1756472AbZAHJFz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756472AbZAHJFz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 04:05:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753851AbZAHJFP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 04:05:15 -0500
Received: from mu-out-0910.google.com ([209.85.134.185]:60278 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753590AbZAHJFG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 04:05:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ISnPD0dyAuacfljWh2sjCPYLLq4uHu0yuBhSHGBzzytgMTkkXdksSKhc7fI98LqSzU
         V7/g1xUqtxvBxJ0285Ax/S2CuVmOpqQ8m2sOzhpg4mvXuaKU3oHgT0lkOOfLya8ZOOlh
         42yisKmxTMnlqtK1CXVxcKo+93TCFkZa0OAEs=
Date: Thu, 8 Jan 2009 10:05:02 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH 2/2] tracing/branch-tracer: adapt to the stat tracing
	API
Message-ID: <20090108090501.GB6560@nowhere>
References: <4956b070.0c07560a.2b34.2325@mx.google.com> <alpine.DEB.1.10.0901072344260.2429@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0901072344260.2429@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 07, 2009 at 11:49:49PM -0500, Steven Rostedt wrote:
> 
> 
> On Sat, 27 Dec 2008, Frederic Weisbecker wrote:
> 
> > This patch adapts the branch tracer to the tracing API.
> > This is not really for inclusion but more likely a proof of concept because
> > the branch tracer implements two "stat tracing" that were split in two files.
> > 
> > So I added an option to the branch tracer: stat_all_branch.
> > If it is set, then trace_stat will output all of the branches entries stats.
> > Otherwise, it will print the annotated branches.
> > 
> > Its is a kind of quick trick, waiting for a better solution.
> > By default, the annotated branches stat are sorted by incorrect branch prediction
> > percentage.
> > 
> 
> OK, I have not had a chance to look at this code since it was sent when I 
> was on Holiday. But I do not think that the only way to see the output of 
> a histogram is to set it in the current_tracer. If I have the branch 
> tracer on, I would have to run it to see the output of the histogram.
> 
> The histogram starts recording at boot up. Although the branch tracer is 
> dependent on the histograms, the histogram is not dependent on the branch 
> tracer. This code is making the histogram dependent on the trace. It took 
> me a while to figure out how to see my histogram.
> 
> With the new patches (after the compile issue is solved) we could have a 
> register_histogram or something that would put the file in the trace_stats 
> directory. This would separate the need of coupling the tracers with the 
> histogram even when they are not coupled.
> 
> -- Steve

You're right, that's a better and more scalable idea.
Should I do it on top of the current patches (when the compile is fixed?).
That will be more easy...

Thanks.

