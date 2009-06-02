Return-Path: <linux-kernel-owner+w=401wt.eu-S1752898AbZFBPKZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752898AbZFBPKZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 11:10:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752747AbZFBPKL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 11:10:11 -0400
Received: from acsinet12.oracle.com ([141.146.126.234]:39637 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754093AbZFBPKJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 11:10:09 -0400
Date: Tue, 2 Jun 2009 11:03:39 -0400
From: Chris Mason <chris.mason@oracle.com>
To: Ulrich Drepper <drepper@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Nick Piggin <npiggin@suse.de>,
       Jeremy Fitzhardinge <jeremy@goop.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Avi Kivity <avi@redhat.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [benchmark] 1% performance overhead of paravirt_ops on native
	kernels
Message-ID: <20090602150339.GF3914@think>
Mail-Followup-To: Chris Mason <chris.mason@oracle.com>,
	Ulrich Drepper <drepper@gmail.com>, Ingo Molnar <mingo@elte.hu>,
	Nick Piggin <npiggin@suse.de>,
	Jeremy Fitzhardinge <jeremy@goop.org>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Avi Kivity <avi@redhat.com>, Arjan van de Ven <arjan@infradead.org>
References: <4A0B62F7.5030802@goop.org> <20090525091527.GA7535@elte.hu> <4A1C3805.7060404@goop.org> <20090528061702.GB6920@wotan.suse.de> <20090530102330.GC16913@elte.hu> <20090602141802.GC3914@think> <a36005b50906020749p22b89693k5c4ae171d18966a7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a36005b50906020749p22b89693k5c4ae171d18966a7@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Source-IP: abhmt003.oracle.com [141.146.116.12]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010201.4A253F4F.0022:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 02, 2009 at 07:49:32AM -0700, Ulrich Drepper wrote:
> On Tue, Jun 2, 2009 at 7:18 AM, Chris Mason <chris.mason@oracle.com> wrote:
> > I'm not suggesting we should take broken code, or that we should lower
> > standards just for xen.  But, expecting the xen developers to fix the 1%
> > hit on a very specific micro-benchmark is not a way to promote new
> > projects for the kernel, and it isn't a good way to convince people to
> > do continued development in mainline instead of in private trees.
> 
> It's not a new project which needs to be treated with kid's gloves.

Sure, I'm not suggesting we send them flowers on mothers day or
anything, and I'm not suggesting they skip out on important cleanups.
But, I strongly object to a 1% hit on a random micro benchmark as a
reason to keep the code out.

> And one be sure that once the code is in the tree those interested
> parties will not be as strongly motivated to fix any problem like
> this.

The idea that people shipping xen aren't interested in performance
regressions is really strange to me.

> Ingo pointed to a way which doesn't negatively impact the
> performance of the Xen kernel and reduces the overhead (dynamic
> patching).  Just get started on this (and general cleanup) and this
> whole argument will go away.

Dynamic patching is a big wad of duct tape over the problem.

> 
> I find it ridiculous to use the "but it's used" argument to try to
> force the code into the kernel.  By this argument you can say the same
> about crap like ndiswrapper and similarly harmful code.

I'm not saying to take harmful code, I'm saying to take code with a
small performance regression under a specific CONFIG_.  Slub regresses
more than 1% on database loads, CONFIG_SCHED_GROUPS, the list goes on
and on.

The idea that we should take code that is heavily used is important.
The best place to fix xen is in the kernel.  It always has been, and
keeping it out is just making it harder on everyone involved.

-chris
