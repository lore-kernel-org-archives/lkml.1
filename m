Return-Path: <linux-kernel-owner+w=401wt.eu-S1753721AbYIZW2S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753721AbYIZW2S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 18:28:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751534AbYIZW2H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 18:28:07 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:39902 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750885AbYIZW2G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 18:28:06 -0400
Message-ID: <48DD61F4.3000704@sgi.com>
Date: Fri, 26 Sep 2008 15:28:04 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, prasad@linux.vnet.ibm.com,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, David Wilder <dwilder@us.ibm.com>,
       hch@lst.de, Martin Bligh <mbligh@google.com>,
       Christoph Hellwig <hch@infradead.org>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Steven Rostedt <srostedt@redhat.com>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [PATCH v6] Unified trace buffer
References: <20080925185154.230259579@goodmis.org>	 <20080925185236.244343232@goodmis.org>	 <alpine.DEB.1.10.0809252101080.8124@gandalf.stny.rr.com>	 <48DC406D.1050508@redhat.com>	 <alpine.DEB.1.10.0809261245420.21618@gandalf.stny.rr.com>	 <alpine.DEB.1.10.0809261349400.21618@gandalf.stny.rr.com> <1222456474.16700.289.camel@lappy.programming.kicks-ass.net>
In-Reply-To: <1222456474.16700.289.camel@lappy.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> On Fri, 2008-09-26 at 14:05 -0400, Steven Rostedt wrote:
>> +struct ring_buffer {
>> +       unsigned long           size;
>> +       unsigned                pages;
>> +       unsigned                flags;
>> +       int                     cpus;
>> +       atomic_t                record_disabled;
>> +
>> +       struct mutex            mutex;
>> +
>> +       /* FIXME: this should be online CPUS */
>> +       struct ring_buffer_per_cpu *buffers[NR_CPUS];
> 
> actually nr_possible makes sense, and you might consider always
> allocating buffers (and keeping them for offlined cpus) to avoid massive
> allocations/frees cpu-hotplug events.
> 
> Mike Travis has been going over the kernel removing constructs like
> this, and replacing them with dynamically allocated arrays of
> nr_possible.
> 
>> +};

The other thing to consider is using a percpu variable.

Cheers,
Mike
