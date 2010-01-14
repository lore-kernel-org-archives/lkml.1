Return-Path: <linux-kernel-owner+w=401wt.eu-S1755725Ab0ANMXh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755725Ab0ANMXh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 07:23:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755622Ab0ANMXh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 07:23:37 -0500
Received: from ey-out-2122.google.com ([74.125.78.25]:1574 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755580Ab0ANMXg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 07:23:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=SKZnrnod4+vP6t2V80AwOkRn5SqL4FX3sr3DhDwQ502c2lMkG2IgLTSoakpNla2DUw
         3SN+vBSRqhy7lOLonXOmKbtwRgZmmA9/jYYvaWFHJcvrxUQRwrNJHDwHjzphiGCNoonz
         Exzta1sSCiSLx27rxyE2RS6EfL/vXXK11lnog=
Date: Thu, 14 Jan 2010 13:23:31 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Arnaldo Carvalho de Melo <acme@infradead.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       utrace-devel <utrace-devel@redhat.com>,
       Jim Keniston <jkenisto@us.ibm.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Maneesh Soni <maneesh@in.ibm.com>, Mark Wielaard <mjw@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] [PATCH 7/7] Ftrace plugin for Uprobes
Message-ID: <20100114122329.GC5033@nowhere>
References: <20100111122521.22050.3654.sendpatchset@srikar.in.ibm.com> <20100111122608.22050.94088.sendpatchset@srikar.in.ibm.com> <1263468191.4244.300.camel@laptop> <20100114113509.GB5033@nowhere> <1263469381.4244.308.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1263469381.4244.308.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 14, 2010 at 12:43:01PM +0100, Peter Zijlstra wrote:
> On Thu, 2010-01-14 at 12:35 +0100, Frederic Weisbecker wrote:
> > On Thu, Jan 14, 2010 at 12:23:11PM +0100, Peter Zijlstra wrote:
> > > On Mon, 2010-01-11 at 17:56 +0530, Srikar Dronamraju wrote:
> > > > This patch implements ftrace plugin for uprobes.
> > > 
> > > Right, like others have said, trace events is a much saner interface.
> > > 
> > > So the easiest way I can see that working is to register uprobes against
> > > a file (not a pid). Then on creation it uses rmap to find all current
> > > maps of that file and install the probe if there is a consumer for that
> > > map.
> > > 
> > > Then for each new mmap() of that file, we also need to check if there's
> > > a consumer ready and install the probe.
> > 
> > 
> > 
> > That looks racy.
> > 
> > Say you first create a probe on /bin/ls:
> > 
> > perf probe p addr_in_ls /bin/ls
> > 
> > then something else launches /bin/ls behind you, probe
> > is set on it
> > 
> > then you launch:
> > 
> > perf record -e "probe:...." /bin/ls
> > 
> > Then it goes recording the previous instance.
> 
> Uhm, why? Only the perf /bin/ls instance has a consumer and will thus
> have a probe installed.
> 
> (Or if you want to use ftrace you need to always have all instances
> probed anyway)


I see, so what you suggest is to have the probe set up
as generic first. Then the process that activates it
becomes a consumer, right?

Would work, yeah.

