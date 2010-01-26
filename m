Return-Path: <linux-kernel-owner+w=401wt.eu-S1754238Ab0AZOWl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754238Ab0AZOWl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 09:22:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754029Ab0AZOWh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 09:22:37 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:59539 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754027Ab0AZOWf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 09:22:35 -0500
Date: Tue, 26 Jan 2010 19:51:54 +0530
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Tom Tromey <tromey@redhat.com>, Stephen Rothwell <sfr@canb.auug.org.au>,
       Kyle Moffett <kyle@moffetthome.net>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Peter Zijlstra <peterz@infradead.org>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Oleg Nesterov <oleg@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       "Frank Ch. Eigler" <fche@redhat.com>, linux-next@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>, utrace-devel@redhat.com,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: linux-next: add utrace tree
Message-ID: <20100126142154.GA30571@in.ibm.com>
Reply-To: ananth@in.ibm.com
References: <20100122182827.GA13185@redhat.com> <20100122200129.GG22003@redhat.com> <alpine.LFD.2.00.1001221355250.13231@localhost.localdomain> <20100122221348.GA4263@redhat.com> <alpine.LFD.2.00.1001221604190.13231@localhost.localdomain> <alpine.LFD.2.00.1001221614520.13231@localhost.localdomain> <f73f7ab81001222220jfaf2edfwca3fa4c22b0b4d72@mail.gmail.com> <alpine.LFD.2.00.1001232051510.3574@localhost.localdomain> <m33a1tnbd9.fsf@fleche.redhat.com> <alpine.LFD.2.00.1001251332370.3574@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1001251332370.3574@localhost.localdomain>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 25, 2010 at 01:41:57PM -0800, Linus Torvalds wrote:
> 
> 
> On Mon, 25 Jan 2010, Tom Tromey wrote:

...

> > * Support "displaced stepping" in the kernel; I think this would improve
> >   performance when debugging in non-stop mode.
> 
> Don't we already do that at least on x86? Just doing a single-step should 
> work on an instruction even if it has a breakpoint on it, because we set 
> the TF bit.
> 
> Or maybe I'm not understanding what displaced stepping means to you.

If Tom is referring to supporting single-stepping out of line, ie., not
putting back the original instruction at the bp location, yes, we
already support it on various architectures for kernel breakpoints,
through the kprobes infrastructure.

For userspace, there are more complications to take care of. We are
reworking a prototype based on community comments (see the long UBP/XOL
thread on lkml from a few days ago). Hopefully the userspace breakpoint
assistance layer will be generic enough for gdb to also take advantage
of, though the interface details need to be hashed out.

Ananth
