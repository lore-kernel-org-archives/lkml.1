Return-Path: <linux-kernel-owner+w=401wt.eu-S1754151AbYKJEou@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754151AbYKJEou (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2008 23:44:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753233AbYKJEol
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Nov 2008 23:44:41 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37304 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753132AbYKJEok (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2008 23:44:40 -0500
Date: Sun, 9 Nov 2008 20:42:56 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Nicolas Pitre <nico@cam.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Russell King <rmk+lkml@arm.linux.org.uk>,
       David Howells <dhowells@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       lkml <linux-kernel@vger.kernel.org>, Ralf Baechle <ralf@linux-mips.org>,
       benh@kernel.crashing.org, paulus@samba.org,
       David Miller <davem@davemloft.net>, Ingo Molnar <mingo@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>, linux-arch@vger.kernel.org
Subject: Re: [PATCH v2] clarify usage expectations for cnt32_to_63()
Message-Id: <20081109204256.89ab7925.akpm@linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.0811092304300.13034@xanadu.home>
References: <9405.1226101315@redhat.com>
	<20081108001555.GE18378@flint.arm.linux.org.uk>
	<alpine.LFD.2.00.0811080939180.13034@xanadu.home>
	<alpine.LFD.2.00.0811081746060.13034@xanadu.home>
	<20081109022549.GA18508@Krystal>
	<alpine.LFD.2.00.0811082143320.13034@xanadu.home>
	<alpine.LFD.2.00.0811082356090.13034@xanadu.home>
	<alpine.LFD.2.00.0811090015570.13034@xanadu.home>
	<20081109064855.GA23782@Krystal>
	<alpine.LFD.2.00.0811090827160.13034@xanadu.home>
	<20081109162250.GB10181@Krystal>
	<alpine.LFD.2.00.0811092304300.13034@xanadu.home>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 09 Nov 2008 23:20:00 -0500 (EST) Nicolas Pitre <nico@cam.org> wrote:

> On Sun, 9 Nov 2008, Mathieu Desnoyers wrote:
> 
> > * Nicolas Pitre (nico@cam.org) wrote:
> > > Do you really have such instances where multiple call sites are needed?  
> > > That sounds even more confusing to me than the current model.  Better 
> > > encapsulate the usage of this macro within some function which has a 
> > > stronger meaning, such as sched_clock(), and call _that_ from multiple 
> > > sites instead.
> > 
> > I see a few reasons for it :
> > 
> > - If we want to inline the whole read function so we don't pay the extra
> >   runtime cost of a function call, this would become required.
> 
> You can inline it as you want as long as it remains in the same .c file.  
> The static variable is still shared amongst all call sites in that case.

Please don't rely upon deep compiler behaviour like that.  It is
unobvious to the reader and it might break if someone uses it incorrectly,
or if the compiler implementation changes, or if a non-gcc compiler is
used, etc.

It is far better to make the management of the state explicit and at
the control of the caller.  Get the caller to allocate the state and
pass its address into this function.  Simple, clear, explicit and
robust.
