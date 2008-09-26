Return-Path: <linux-kernel-owner+w=401wt.eu-S1754129AbYIZByb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754129AbYIZByb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 21:54:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752147AbYIZByW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 21:54:22 -0400
Received: from mx1.redhat.com ([66.187.233.31]:34070 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751506AbYIZByV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 21:54:21 -0400
Message-ID: <48DC406D.1050508@redhat.com>
Date: Thu, 25 Sep 2008 21:52:45 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>, prasad@linux.vnet.ibm.com,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, David Wilder <dwilder@us.ibm.com>,
       hch@lst.de, Martin Bligh <mbligh@google.com>,
       Christoph Hellwig <hch@infradead.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [RFC PATCH v4] Unified trace buffer
References: <20080925185154.230259579@goodmis.org> <20080925185236.244343232@goodmis.org> <alpine.DEB.1.10.0809252101080.8124@gandalf.stny.rr.com>
In-Reply-To: <alpine.DEB.1.10.0809252101080.8124@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steven,

Steven Rostedt wrote:
> This version has been cleaned up a bit. I've been running it as
> a back end to ftrace, and it has been handling pretty well.

Thank you for your great work.
It seems good to me(especially, encapsulating events :)).

I have one request of enhancement.

 > +static struct ring_buffer_per_cpu *
 > +ring_buffer_allocate_cpu_buffer(struct ring_buffer *buffer, int cpu)
 > +{
[...]
 > +	cpu_buffer->pages = kzalloc_node(ALIGN(sizeof(void *) * pages,
 > +					       cache_line_size()), GFP_KERNEL,
 > +					 cpu_to_node(cpu));

Here, you are using a slab object for page managing array,
the largest object size is 128KB(x86-64), so it can contain
16K pages = 64MB.

As I had improved relayfs, in some rare case(on 64bit arch),
we'd like to use larger buffer than 64MB.

http://sourceware.org/ml/systemtap/2008-q2/msg00103.html

So, I think similar hack can be applicable.

Would it be acceptable for the next version?

Thank you,

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

