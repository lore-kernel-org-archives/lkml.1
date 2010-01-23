Return-Path: <linux-kernel-owner+w=401wt.eu-S1752982Ab0AWTtN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752982Ab0AWTtN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jan 2010 14:49:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752636Ab0AWTtK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jan 2010 14:49:10 -0500
Received: from thunk.org ([69.25.196.29]:43851 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751119Ab0AWTtI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jan 2010 14:49:08 -0500
Date: Sat, 23 Jan 2010 14:48:20 -0500
From: tytso@mit.edu
To: "Frank Ch. Eigler" <fche@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Kyle Moffett <kyle@moffetthome.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
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
Message-ID: <20100123194820.GM21263@thunk.org>
Mail-Followup-To: tytso@mit.edu, "Frank Ch. Eigler" <fche@redhat.com>,
	Ingo Molnar <mingo@elte.hu>, Kyle Moffett <kyle@moffetthome.net>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Oleg Nesterov <oleg@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Peter Zijlstra <peterz@infradead.org>,
	Fr??d??ric Weisbecker <fweisbec@gmail.com>,
	LKML <linux-kernel@vger.kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	linux-next@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
	utrace-devel@redhat.com, Thomas Gleixner <tglx@linutronix.de>
References: <alpine.LFD.2.00.1001211724500.13231@localhost.localdomain>
 <20100122182827.GA13185@redhat.com>
 <20100122200129.GG22003@redhat.com>
 <alpine.LFD.2.00.1001221355250.13231@localhost.localdomain>
 <20100122221348.GA4263@redhat.com>
 <alpine.LFD.2.00.1001221604190.13231@localhost.localdomain>
 <alpine.LFD.2.00.1001221614520.13231@localhost.localdomain>
 <f73f7ab81001222220jfaf2edfwca3fa4c22b0b4d72@mail.gmail.com>
 <20100123112333.GA15455@elte.hu>
 <20100123114729.GA7828@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100123114729.GA7828@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 23, 2010 at 06:47:29AM -0500, Frank Ch. Eigler wrote:
> > What utrace does is that it provides an opaque set of APIs for
> > unspecified and out of tree _kernel_ modules (such as systemtap). It
> > doesnt support any 'application' per se. It basically removes the
> > kernel's freedom at shaping its own interaction with debug
> > application.
> 
> This claim is hard to take any more seriously than emoting that the
> blockio layer is "opaque" because device drivers "remove freedom" for
> the kernel to "shape its interaction" with hardware.  If you have any
> *real evidence* about how any present user of utrace misuses that
> capability, or interferes with the "kernel's freedom", show us please.

The fundamental issue which Ingo is trying to say (and which you
apparently don't seem to be understanding) is that utrace doesn't
export a syscall (which is an ABI that we are willing to promise will
be stable), but rather a set of kernel API's (which we never promise
to be stable), and the fact that there will be out-of-tree programs
that are going to be trying to depend on that interface (much like
Systemtap does today when it creates kernel modules) is something that
is considered on par with Nvidia trying to ship proprietary video
drivers.  

(OK, maybe not *quite* as evil as Nvidia because at least SystemTap is
open source, but the bottom line is that enabling out-of-tree modules
isn't considered a good thing, and if we know in advance that there
are out-of-tree modules, there is a strong tendency to want to nip
those in the bud.)

The reason why I avoid Nvidia hardware like the plague is because I
work on bleeding-edge kernels, and even though companies like Nvidia
and Broadcom try very hard to keep up with released upstream kernels,
#1, there is always the concern of what happens if they decide to
change that policy, and #2, invariably something will break during the
-rc1 or -rc2 stage, and then my laptop is useless for running bleeding
edge kernels.  It's one of the reasons why many kernel developers gave
up on SystemTap, because it's not something that can be trusted to be
there, and the fault is not on our changing the API's, it's on
SystemTap depending on API's that were never guaranteed to be stable
in the first place.

If you want to try to slide utrace in, such that we're able to ignore
the fact that there will be this external house that will be built on
quicksand, pointing at how nice the external house will be isn't going
to be helpful.  Nor is pointing at the ability that other people will
be able to build other really nice houses on the aforementioned
quicksand (i.e., out-of-tree kernel modules that depend on kernel
API's).

A simple "code cleanup" argument is not carrying the day (Look!  We
can cleanup the ptree code!).  It's going to have to be a **really**
cool in-tree kernel funtionality that provides a killer feature (in
Linus's words), enough so that people are willing to overlook the fact
that there's this monster external out-of-tree project that wants to
be depend on API's that may not be stable, and which, even if the
developers don't grump at us, users will grump at us when we change
API's that we had never guaranteed will be stable, and then Systemtap
breaks.

This is probably why Ingo invited you to think about ways of doing
some kind of safe in-kernel bytecode approach.  That has the advantage
of doing away with external kernel modules, with all of their many
downsides: its dependency on unstable kernel API's, the fact that many
financial customers have security policies that prohibit C compilers
on production machines, the inherent security risk of allowing
external random kernel modules to be delivered and loaded into a
system, etc.

       	       	     	       	   	  - Ted
