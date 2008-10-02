Return-Path: <linux-kernel-owner+w=401wt.eu-S1755917AbYJBXhY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755917AbYJBXhY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 19:37:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753487AbYJBXhB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 19:37:01 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:54445 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753019AbYJBXhA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 19:37:00 -0400
Date: Thu, 2 Oct 2008 19:36:57 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>, Jonathan Corbet <corbet@lwn.net>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, prasad@linux.vnet.ibm.com,
       "Frank Ch. Eigler" <fche@redhat.com>, David Wilder <dwilder@us.ibm.com>,
       hch@lst.de, Martin Bligh <mbligh@google.com>,
       Christoph Hellwig <hch@infradead.org>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Steven Rostedt <srostedt@redhat.com>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [PATCH] ring_buffer: map to cpu not page
In-Reply-To: <alpine.DEB.1.10.0810021917030.26504@gandalf.stny.rr.com>
Message-ID: <alpine.DEB.1.10.0810021936180.26504@gandalf.stny.rr.com>
References: <alpine.DEB.1.10.0809292359030.19533@gandalf.stny.rr.com> <20080930092001.69849210@bike.lwn.net> <1222790072.24384.21.camel@twins> <alpine.LFD.2.00.0809300930090.3389@nehalem.linux-foundation.org> <alpine.DEB.1.10.0809301242550.1984@gandalf.stny.rr.com>
 <alpine.LFD.2.00.0809300958120.3389@nehalem.linux-foundation.org> <alpine.DEB.1.10.0810011114000.30777@gandalf.stny.rr.com> <20081002085030.GF26084@elte.hu> <20081002085145.GA3202@elte.hu> <20081002090517.GA8708@elte.hu> <20081002093835.GA17699@elte.hu>
 <alpine.DEB.1.10.0810021917030.26504@gandalf.stny.rr.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2 Oct 2008, Steven Rostedt wrote:

> 
> My original patch had a compile bug when NUMA was configured. I
> referenced cpu when it should have been cpu_buffer->cpu.
> 
> Ingo quickly fixed this bug by replacing cpu with 'i' because that
> was the loop counter. Unfortunately, the 'i' was the counter of
> pages, not CPUs. This caused a crash when the number of pages allocated
> for the buffers exceeded the number of pages, which would usually

That should have been:

 "when the number of pages allocated for the buffers exceeded the number
  of cpus".

> be the case.
> 

-- Steve

