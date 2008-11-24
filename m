Return-Path: <linux-kernel-owner+w=401wt.eu-S1753902AbYKXUqe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753902AbYKXUqe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 15:46:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751871AbYKXUq0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 15:46:26 -0500
Received: from tomts25-srv.bellnexxia.net ([209.226.175.188]:38243 "EHLO
	tomts25-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751083AbYKXUqZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 15:46:25 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtEEAGygKklMROB9/2dsb2JhbACBbdAugnw
Date: Mon, 24 Nov 2008 15:46:22 -0500
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>,
       linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
       ltt-dev@lists.casi.polymtl.ca, Ingo Molnar <mingo@elte.hu>,
       Sam Ravnborg <sam@ravnborg.org>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [ltt-dev] LTTng kernel integration roadmap, update
Message-ID: <20081124204622.GA6229@Krystal>
References: <20081124112842.GA15615@Krystal> <20081124114124.GA32459@infradead.org> <20081124122055.GA18626@Krystal> <alpine.DEB.1.10.0811241156030.20122@gandalf.stny.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0811241156030.20122@gandalf.stny.rr.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 15:41:14 up 7 days, 21:21,  2 users,  load average: 0.80, 0.48,
	0.39
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt (rostedt@goodmis.org) wrote:
> 
> On Mon, 24 Nov 2008, Mathieu Desnoyers wrote:
> > 
> > The key idea behind this is to answer to Thomas Gleixner concerns, who
> > supports that a tracer should output data in text-format only so it can
> > be used with tools kernel developers have on their system, like "cat".
> > 
> > However, getting data out of the kernel efficiently simply cannot be
> > done with such approach. Therefore, LTTng needs its own userspace tools
> > to splice the data out of the kernel efficiently. Another tool is used
> > to pretty-print the binary data into text.
> > 
> > Then the problem becomes : we have to make the userspace tool easy
> > enough to deploy so even Linus can find and use it. ;)
> > 
> > But indeed, the trace buffers are versioned, so if the format changes
> > between kernel versions, the userspace tools will detect it and the user
> > will know it must update its tools. So it's not really a problem there.
> > 
> > The question that prevails is therefore : should we ship userspace
> > binary with the kernel tree at all ? And if yes, how should the resuting
> > executables be packaged and deployed ? Should it be installed in the
> > system along with kernel modules or should it be populated into a
> > filesystem populated by kernelspace ?
> > 
> > Or is it better to do as we have always done and keep the userspace
> > tools separated from the kernel tree ?
> 
> I say keep the user space tools separate as much as possible.
> 

I'd be in favor of that too. We should just document and package it so
it's easy to find.

> What about having a meta-data file for all binary files. This meta-data 
> could explain the format that is read. Big endian, little endian, the 
> fields and offsets, the event ids etc.  This way we will not need a 
> "version" file, which means absolutely nothing if you do not know what 
> comes with that version. Any tool could look at the meta-data file and 
> figure out what is in the buffers.
> 
> -- Steve

This is exactly what I do in LTTng, modulo the fact that I repeat this
information also in other buffer headers, but only use the information
located in the metadata buffer header. I duplicated the information to
make sure all subbuffer headers looks the same, but I could easily
change that.

I would however keep a small subbuffer header with a version number for
each subbuffers though, just so the parser can "know" what file this is
and what metadata should be expected with it. I think about the poor
user who lost its metadata file and wonders what tool could open the
other tracefiles he has... without a header containing at least a magic
number and a version, those files won't be identified. But we can keep
this information as minimalistic as possible.

Thanks for the feedback.

Mathieu

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
