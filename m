Return-Path: <linux-kernel-owner+w=401wt.eu-S1754125Ab0A0Gwe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754125Ab0A0Gwe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 01:52:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753614Ab0A0Gwc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 01:52:32 -0500
Received: from casper.infradead.org ([85.118.1.10]:37575 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753089Ab0A0Gwc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 01:52:32 -0500
Subject: Re: linux-next: add utrace tree
From: Peter Zijlstra <peterz@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Tom Tromey <tromey@redhat.com>, Kyle Moffett <kyle@moffetthome.net>,
       "Frank Ch. Eigler" <fche@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>, linux-next@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>, utrace-devel@redhat.com,
       Thomas Gleixner <tglx@linutronix.de>, JimKeniston <jkenisto@us.ibm.com>
In-Reply-To: <alpine.LFD.2.00.1001261535510.17519@localhost.localdomain>
References: <20100121013822.28781960.sfr@canb.auug.org.au>
	 <20100122005147.GD22003@redhat.com>
	 <20100121170541.7425ff10.akpm@linux-foundation.org>
	 <alpine.LFD.2.00.1001211724500.13231@localhost.localdomain>
	 <20100122182827.GA13185@redhat.com> <20100122200129.GG22003@redhat.com>
	 <alpine.LFD.2.00.1001221355250.13231@localhost.localdomain>
	 <20100122221348.GA4263@redhat.com>
	 <alpine.LFD.2.00.1001221604190.13231@localhost.localdomain>
	 <alpine.LFD.2.00.1001221614520.13231@localhost.localdomain>
	 <f73f7ab81001222220jfaf2edfwca3fa4c22b0b4d72@mail.gmail.com>
	 <alpine.LFD.2.00.1001232051510.3574@localhost.localdomain>
	 <m33a1tnbd9.fsf@fleche.redhat.com>
	 <alpine.LFD.2.00.1001251332370.3574@localhost.localdomain>
	 <m3636oh2rt.fsf@fleche.redhat.com>
	 <alpine.LFD.2.00.1001261535510.17519@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 27 Jan 2010 07:52:14 +0100
Message-ID: <1264575134.4283.1983.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-01-26 at 15:37 -0800, Linus Torvalds wrote:
> 
> On Tue, 26 Jan 2010, Tom Tromey wrote:
> > 
> > In non-stop mode (where you can stop one thread but leave the others
> > running), gdb wants to have the breakpoints always inserted.  So,
> > something must emulate the displaced instruction.
> 
> I'm almost totally uninterested in breakpoints that actually re-write 
> instructions. It's impossible to do that efficiently and well, especially 
> in threaded environments.
> 
> So if you do instruction rewriting, I can only say "that's your problem".

Right, so you're going to love uprobes, which does exactly that. The
current proposal is overwriting the target instruction with an INT3 and
injecting an extra vma into the target process's address space
containing the original instruction(s) and possible jumps back to the
old code stream.

I'm all in favor of not doing that extra vma and instead use stack or
TLS space, but then people complain about having to make that executable
(which is something I don't really mind, x86 had executable everything
for very long, and also, its only so when debugging the thing anyway).



