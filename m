Return-Path: <linux-kernel-owner+w=401wt.eu-S1754091AbYI0AQe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754091AbYI0AQe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 20:16:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752742AbYI0AQ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 20:16:26 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55466 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752332AbYI0AQY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 20:16:24 -0400
Date: Fri, 26 Sep 2008 17:13:36 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
cc: Arnaldo Carvalho de Melo <acme@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>, prasad@linux.vnet.ibm.com,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, David Wilder <dwilder@us.ibm.com>,
       hch@lst.de, Martin Bligh <mbligh@google.com>,
       Christoph Hellwig <hch@infradead.org>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH v6] Unified trace buffer
In-Reply-To: <alpine.DEB.1.10.0809261957001.21618@gandalf.stny.rr.com>
Message-ID: <alpine.LFD.1.10.0809261707320.3265@nehalem.linux-foundation.org>
References: <20080925185154.230259579@goodmis.org> <20080925185236.244343232@goodmis.org> <alpine.DEB.1.10.0809252101080.8124@gandalf.stny.rr.com> <48DC406D.1050508@redhat.com> <alpine.DEB.1.10.0809261245420.21618@gandalf.stny.rr.com>
 <alpine.DEB.1.10.0809261349400.21618@gandalf.stny.rr.com> <20080926223129.GF15446@ghostprotocols.net> <alpine.DEB.1.10.0809261957001.21618@gandalf.stny.rr.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 26 Sep 2008, Steven Rostedt wrote:
> 
> I started using the rb_ because I was constantly breaking the 80 character 
> line limit with ring_buffer ;-)   OK, for v8, I'll rename all static 
> internal functions to rb_ and keep the global ones ring_buffer_

It would probably be better to use something else than 'rb_', because that 
prefix is already used by the red-black trees, and exported as such (eg 
"rb_next()" etc).

But at least as long as it's static, it's probably not _too_ noticeable if 
the rest of the names don't overlap. We _do_ include <linux/rbtree.h>  
almost everywhere, since we use those things in the VM, in timers etc, so 
it comes in through pretty much all headers.

			Linus
