Return-Path: <linux-kernel-owner+w=401wt.eu-S1760723AbZEADDm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760723AbZEADDm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 23:03:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754380AbZEADDe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 23:03:34 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57151 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753563AbZEADDd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 23:03:33 -0400
Date: Thu, 30 Apr 2009 20:00:34 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 1/3] ring-buffer: add counters for commit overrun and
 nmi dropped entries
Message-Id: <20090430200034.fb794702.akpm@linux-foundation.org>
In-Reply-To: <20090501022400.894326175@goodmis.org>
References: <20090501022210.851418183@goodmis.org>
	<20090501022400.894326175@goodmis.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Apr 2009 22:22:11 -0400 Steven Rostedt <rostedt@goodmis.org> wrote:

> +unsigned long ring_buffer_nmi_dropped_cpu(struct ring_buffer *buffer, int cpu)
> +{
> +	struct ring_buffer_per_cpu *cpu_buffer;
> +	unsigned long ret;
> +
> +	if (!cpumask_test_cpu(cpu, buffer->cpumask))
> +		return 0;
> +
> +	cpu_buffer = buffer->buffers[cpu];
> +	ret = cpu_buffer->nmi_dropped;
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(ring_buffer_nmi_dropped_cpu);
> +
> +/**
> + * ring_buffer_commit_overrun_cpu - get the number of overruns caused by commits
> + * @buffer: The ring buffer
> + * @cpu: The per CPU buffer to get the number of overruns from
> + */
> +unsigned long
> +ring_buffer_commit_overrun_cpu(struct ring_buffer *buffer, int cpu)
> +{
> +	struct ring_buffer_per_cpu *cpu_buffer;
> +	unsigned long ret;
> +
> +	if (!cpumask_test_cpu(cpu, buffer->cpumask))
> +		return 0;
> +
> +	cpu_buffer = buffer->buffers[cpu];
> +	ret = cpu_buffer->commit_overrun;
> +
> +	return ret;
> +}

hm.  Four functions in a row, all of which differ in but a single line.

unsigned long
ring_buffer_commit_overrun_cpu(struct ring_buffer *buffer, int cpu)
{
	return some_common_function(buffer, cpu)->commit_overrun;
}

?

