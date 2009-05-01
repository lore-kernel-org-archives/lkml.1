Return-Path: <linux-kernel-owner+w=401wt.eu-S1757468AbZEADMH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757468AbZEADMH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 23:12:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758194AbZEADLx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 23:11:53 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:57733 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756618AbZEADLx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 23:11:53 -0400
Date: Thu, 30 Apr 2009 23:11:52 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 1/3] ring-buffer: add counters for commit overrun and
 nmi dropped entries
In-Reply-To: <20090430200034.fb794702.akpm@linux-foundation.org>
Message-ID: <alpine.DEB.2.00.0904302311320.20374@gandalf.stny.rr.com>
References: <20090501022210.851418183@goodmis.org> <20090501022400.894326175@goodmis.org> <20090430200034.fb794702.akpm@linux-foundation.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 30 Apr 2009, Andrew Morton wrote:

> On Thu, 30 Apr 2009 22:22:11 -0400 Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > +unsigned long ring_buffer_nmi_dropped_cpu(struct ring_buffer *buffer, int cpu)
> > +{
> > +	struct ring_buffer_per_cpu *cpu_buffer;
> > +	unsigned long ret;
> > +
> > +	if (!cpumask_test_cpu(cpu, buffer->cpumask))
> > +		return 0;
> > +
> > +	cpu_buffer = buffer->buffers[cpu];
> > +	ret = cpu_buffer->nmi_dropped;
> > +
> > +	return ret;
> > +}
> > +EXPORT_SYMBOL_GPL(ring_buffer_nmi_dropped_cpu);
> > +
> > +/**
> > + * ring_buffer_commit_overrun_cpu - get the number of overruns caused by commits
> > + * @buffer: The ring buffer
> > + * @cpu: The per CPU buffer to get the number of overruns from
> > + */
> > +unsigned long
> > +ring_buffer_commit_overrun_cpu(struct ring_buffer *buffer, int cpu)
> > +{
> > +	struct ring_buffer_per_cpu *cpu_buffer;
> > +	unsigned long ret;
> > +
> > +	if (!cpumask_test_cpu(cpu, buffer->cpumask))
> > +		return 0;
> > +
> > +	cpu_buffer = buffer->buffers[cpu];
> > +	ret = cpu_buffer->commit_overrun;
> > +
> > +	return ret;
> > +}
> 
> hm.  Four functions in a row, all of which differ in but a single line.
> 
> unsigned long
> ring_buffer_commit_overrun_cpu(struct ring_buffer *buffer, int cpu)
> {
> 	return some_common_function(buffer, cpu)->commit_overrun;
> }
> 
> ?

But that actually takes thought. I like my cut and paste ;-)

-- Steve

