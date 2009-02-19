Return-Path: <linux-kernel-owner+w=401wt.eu-S1758122AbZBSCNU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758122AbZBSCNU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 21:13:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752364AbZBSCNK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 21:13:10 -0500
Received: from ug-out-1314.google.com ([66.249.92.172]:16043 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751838AbZBSCNJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 21:13:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=rj/TCKSGu1vRXCYU3atEjZM3kiveNd2ryEvgx2nOAcSaYx2u+ziCLgYcFVX5kJDZmn
         H/3zeHjjt7zgIdFKJHTqzQukoLVGI42VcrYgvkZOIZi8q9To4Vbv/SmNHmxCgHVjO6XP
         d/UUOM8ahlxQKz3SBHHpX9uRUWpv6t21dxLw0=
Date: Thu, 19 Feb 2009 03:13:02 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Jason Baron <jbaron@redhat.com>, mingo@elte.hu, rostedt@goodmis.org,
       linux-kernel@vger.kernel.org, acme@ghostprotocols.net, fche@redhat.com,
       compudj@krystal.dyndns.org
Subject: Re: [PATCH] new irq tracer
Message-ID: <20090219021302.GB5785@nowhere>
References: <20090218195328.GA3112@redhat.com> <1234991725.4799.1.camel@laptop> <20090218213545.GB3112@redhat.com> <1234993580.4799.11.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1234993580.4799.11.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 18, 2009 at 10:46:20PM +0100, Peter Zijlstra wrote:
> On Wed, 2009-02-18 at 16:35 -0500, Jason Baron wrote:
> > On Wed, Feb 18, 2009 at 10:15:25PM +0100, Peter Zijlstra wrote:
> > > On Wed, 2009-02-18 at 14:53 -0500, Jason Baron wrote:
> > > > hi,
> > > > 
> > > > Using a copule of tracepoints i've implemented an 'irq tracer' which has
> > > > the following column format:
> > > > 
> > > > [time][irq][action][handled][cpu][length]
> > > > 
> > > > for example on my system:
> > > > 
> > > > [ 1038.927248381]     28     eth0      1        3     0.000002745
> > > > [ 1038.927544688]     28     eth0      1        3     0.000002520
> > > > [ 1038.927593609]     28     eth0      1        3     0.000002509
> > > > [ 1038.974087675]     29     ahci      1        1     0.000013135
> > > > [ 1038.974288475]     29     ahci      1        1     0.000005542
> > > > [ 1038.974414324]     29     ahci      1        1     0.000007953
> > > > 
> > > > I think this patch is useful in understanding irq system behavior, and
> > > > for tracking down irq driver handlers that are firing too often or
> > > > spending too much time handling an irq. This approach could be extended
> > > > to the timer irq and for softirqs...
> > > 
> > > The function graph tracer can already do this, it has a special section
> > > to recognize irq entry function, and already measures time spend.
> > > 
> > > I guess with Steve's new triggers (probes or whatever they ended up
> > > being called) you could limit it to just IRQ entry points.
> > > 
> > 
> > i did look at the graph tracer first. While it does measure irq related
> > functions, it does not give this level of detail concerning which irq #,
> > which irq handler is involved, and whether or not the irq was handled
> > successfully or not. So I believe this tracepoints add a level of detail
> > that the graph tracer does not have. Furthermore, this patch requires 2
> > tracepoints, not instrumentation for all kernel functions.
> 
> How useful is that return value?
> 
> Much of the other data is already available, /proc/interrupts will
> happily tell you the source of your interrupt storm. The irq-off latency
> tracer will tell you if stuff takes too much time, the graph tracer can
> tell you what is taking how much time.
> 
> I really am having a difficult time seeing the use in such narrow
> tracers.
> 

Well, something that could be done would be to use this irq tracing framework
to produce the average of time spent in each irq handler.

kernel/trace/trace_stat.c gives some infrastructure for that.

BTW, I have the project to build a function hashlist, based on the function list
provided by dynamic ftrace, to store the average of time spent for each traced
function, using the function graph tracer.

