Return-Path: <linux-kernel-owner+w=401wt.eu-S1753850Ab0AZXi7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753850Ab0AZXi7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 18:38:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753693Ab0AZXi5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 18:38:57 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38863 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753624Ab0AZXi4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 18:38:56 -0500
Date: Tue, 26 Jan 2010 15:37:49 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Tom Tromey <tromey@redhat.com>
cc: Kyle Moffett <kyle@moffetthome.net>, "Frank Ch. Eigler" <fche@redhat.com>,
       Oleg Nesterov <oleg@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Peter Zijlstra <peterz@infradead.org>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>, linux-next@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>, utrace-devel@redhat.com,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: linux-next: add utrace tree
In-Reply-To: <m3636oh2rt.fsf@fleche.redhat.com>
Message-ID: <alpine.LFD.2.00.1001261535510.17519@localhost.localdomain>
References: <20100121013822.28781960.sfr@canb.auug.org.au> <20100122005147.GD22003@redhat.com> <20100121170541.7425ff10.akpm@linux-foundation.org> <alpine.LFD.2.00.1001211724500.13231@localhost.localdomain> <20100122182827.GA13185@redhat.com>
 <20100122200129.GG22003@redhat.com> <alpine.LFD.2.00.1001221355250.13231@localhost.localdomain> <20100122221348.GA4263@redhat.com> <alpine.LFD.2.00.1001221604190.13231@localhost.localdomain> <alpine.LFD.2.00.1001221614520.13231@localhost.localdomain>
 <f73f7ab81001222220jfaf2edfwca3fa4c22b0b4d72@mail.gmail.com> <alpine.LFD.2.00.1001232051510.3574@localhost.localdomain> <m33a1tnbd9.fsf@fleche.redhat.com> <alpine.LFD.2.00.1001251332370.3574@localhost.localdomain> <m3636oh2rt.fsf@fleche.redhat.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 26 Jan 2010, Tom Tromey wrote:
> 
> In non-stop mode (where you can stop one thread but leave the others
> running), gdb wants to have the breakpoints always inserted.  So,
> something must emulate the displaced instruction.

I'm almost totally uninterested in breakpoints that actually re-write 
instructions. It's impossible to do that efficiently and well, especially 
in threaded environments.

So if you do instruction rewriting, I can only say "that's your problem".

But using the hardware breakpoints should automatically DTRT, both wrt 
threads _and_ wrt restarting. Sure, there's onyl a limited number of them, 
so if somebody wants more than that they are kind of screwed, but that's 
just how life is.

		Linus
