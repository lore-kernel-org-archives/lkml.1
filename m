Return-Path: <linux-kernel-owner+w=401wt.eu-S1753252Ab0AYE7Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753252Ab0AYE7Z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jan 2010 23:59:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752273Ab0AYE7U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jan 2010 23:59:20 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:47466 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752031Ab0AYE7T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jan 2010 23:59:19 -0500
Date: Mon, 25 Jan 2010 10:29:08 +0530
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Kyle Moffett <kyle@moffetthome.net>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Peter Zijlstra <peterz@infradead.org>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Oleg Nesterov <oleg@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       "Frank Ch. Eigler" <fche@redhat.com>, linux-next@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>, utrace-devel@redhat.com,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: linux-next: add utrace tree
Message-ID: <20100125045908.GB4895@in.ibm.com>
Reply-To: ananth@in.ibm.com
References: <20100121170541.7425ff10.akpm@linux-foundation.org> <alpine.LFD.2.00.1001211724500.13231@localhost.localdomain> <20100122182827.GA13185@redhat.com> <20100122200129.GG22003@redhat.com> <alpine.LFD.2.00.1001221355250.13231@localhost.localdomain> <20100122221348.GA4263@redhat.com> <alpine.LFD.2.00.1001221604190.13231@localhost.localdomain> <alpine.LFD.2.00.1001221614520.13231@localhost.localdomain> <f73f7ab81001222220jfaf2edfwca3fa4c22b0b4d72@mail.gmail.com> <20100123112333.GA15455@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100123112333.GA15455@elte.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 23, 2010 at 12:23:33PM +0100, Ingo Molnar wrote:
> 
> * Kyle Moffett <kyle@moffetthome.net> wrote:
> 
> > On Fri, Jan 22, 2010 at 19:22, Linus Torvalds
> > <torvalds@linux-foundation.org> wrote:
 
...

> In that sense it might be better to fix/enhance ptrace, if there's interest. 
> I've written a handful of ptrace extensions in the past (none of them went 
> upstream tho), it can be done in a useful manner and the code is pretty 
> hackable. There are basic problems left to be solved: for example why is there 
> still no 'memory block copy' call, why are we _still_ limited to one word per 
> system call PTRACE_PEEK* memory copies? It's ridiculous. SparcLinux has 
> PTRACE_WRITE*/READ* support that implements this, but none of the other 
> architectures have it so it's essentially unused.
> 
> Or another possible direction would be to extend the perf events syscall with 
> interception capabilities. It's far more performant at extracting application 
> state without scheduling than any ptrace method - and interception/injection 
> would be a natural next step - if there's interest.

This certainly is now a chicken and egg problem. Everybody agrees that
Linux needs something better than ptrace; legacy ptrace will continue to
live, so will utilities written to it (strace, etc).

But should that limit what Linux can offer? What's the way out?

- Enhance ptrace: At least one ptrace maintainer (Roland) had publically
  stated he doesn't prefer enhancing legacy ptrace -- that its already a
  beast to maintain, and adding more complexity to it does it no good.

- Extend perf; would perf then use utrace underneath? Or would one have
  to redo some of what utrace already does for thread level control?

- Give utrace a syscall and make it the primary way for users to
  interact with the layer. There are benefits to this if there is
  agreement on the utrace layer itself, maybe with less fexibility than
  what it currently offers? If yes, what should it look like?

Any new debug facility will have to incorporate some or most learnings
from what utrace tried to address. It would be sad to just dump utrace
and redo everything from scratch or band-aid existing interfaces.

Ananth
