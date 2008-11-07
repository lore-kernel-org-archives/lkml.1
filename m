Return-Path: <linux-kernel-owner+w=401wt.eu-S1753922AbYKGQbE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753922AbYKGQbE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 11:31:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752757AbYKGQav
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 11:30:51 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49529 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750776AbYKGQau (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 11:30:50 -0500
Date: Fri, 7 Nov 2008 08:29:26 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: David Howells <dhowells@redhat.com>
Cc: Nicolas Pitre <nico@cam.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-kernel@vger.kernel.org, Ralf Baechle <ralf@linux-mips.org>,
       benh@kernel.crashing.org, paulus@samba.org,
       David Miller <davem@davemloft.net>, Ingo Molnar <mingo@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>, linux-arch@vger.kernel.org
Subject: Re: [RFC patch 08/18] cnt32_to_63 should use smp_rmb()
Message-Id: <20081107082926.ee3e1efe.akpm@linux-foundation.org>
In-Reply-To: <8189.1226074915@redhat.com>
References: <20081107075003.fa93ccf4.akpm@linux-foundation.org>
	<20081107003816.9b0f947a.akpm@linux-foundation.org>
	<20081107052336.652868737@polymtl.ca>
	<20081107053349.861709786@polymtl.ca>
	<20081106220530.5b0e3a96.akpm@linux-foundation.org>
	<alpine.LFD.2.00.0811070256450.13034@xanadu.home>
	<25363.1226056819@redhat.com>
	<alpine.LFD.2.00.0811070952150.13034@xanadu.home>
	<8189.1226074915@redhat.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 07 Nov 2008 16:21:55 +0000 David Howells <dhowells@redhat.com> wrote:

> Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > If gcc did that then it would need to generate static instances of
> > inlined functions within individual compilation units.  It would be a
> > disaster for the kernel.  For a start, functions which are "inlined" in kernel
> > modules wouldn't be able to access their static storage and modprobing
> > them would fail.
> 
> Do you expect a static inline function that lives in a header file and that
> has a static variable in it to share that static variable over all instances
> of that function in a program?  Or do you expect the static variable to be
> limited at the file level?  Or just at the invocation level?

I'd expect it to behave in the same way as it would if the function was
implemented out-of-line.

But it occurs to me that the modrobe-doesnt-work thing would happen if
the function _is_ inlined anyway, so we won't be doing that.

Whatever.  Killing this many puppies because gcc may do something so
bizarrely wrong isn't justifiable.

