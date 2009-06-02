Return-Path: <linux-kernel-owner+w=401wt.eu-S1752573AbZFBSd4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752573AbZFBSd4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 14:33:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750958AbZFBSds
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 14:33:48 -0400
Received: from acsinet12.oracle.com ([141.146.126.234]:44873 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751225AbZFBSds (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 14:33:48 -0400
Date: Tue, 2 Jun 2009 14:27:42 -0400
From: Chris Mason <chris.mason@oracle.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Ulrich Drepper <drepper@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Nick Piggin <npiggin@suse.de>, Jeremy Fitzhardinge <jeremy@goop.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Avi Kivity <avi@redhat.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [benchmark] 1% performance overhead of paravirt_ops on native
	kernels
Message-ID: <20090602182742.GJ3914@think>
Mail-Followup-To: Chris Mason <chris.mason@oracle.com>,
	Pekka Enberg <penberg@cs.helsinki.fi>,
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
References: <4A0B62F7.5030802@goop.org> <20090525091527.GA7535@elte.hu> <4A1C3805.7060404@goop.org> <20090528061702.GB6920@wotan.suse.de> <20090530102330.GC16913@elte.hu> <20090602141802.GC3914@think> <a36005b50906020749p22b89693k5c4ae171d18966a7@mail.gmail.com> <20090602150339.GF3914@think> <84144f020906021106l7927e005o6bcd555b8f51b03b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <84144f020906021106l7927e005o6bcd555b8f51b03b@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Source-IP: abhmt006.oracle.com [141.146.116.15]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010202.4A256F22.01F7:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 02, 2009 at 09:06:41PM +0300, Pekka Enberg wrote:
> Hi Chris,
> 
> On Tue, Jun 2, 2009 at 6:03 PM, Chris Mason <chris.mason@oracle.com> wrote:
> >> I find it ridiculous to use the "but it's used" argument to try to
> >> force the code into the kernel.  By this argument you can say the same
> >> about crap like ndiswrapper and similarly harmful code.
> >
> > I'm not saying to take harmful code, I'm saying to take code with a
> > small performance regression under a specific CONFIG_.  Slub regresses
> > more than 1% on database loads, CONFIG_SCHED_GROUPS, the list goes on
> > and on.
> 
> Maybe it's just me but you make it sound like the SLUB regression is
> okay. It's not.

Well, it is and it isn't.  SLUB was implemented with specific workloads
in mind.  I'd prefer that regressions not get in at all, but sometimes
it takes the broad exposure you get from being in mainline to
finish things.  Sometimes we finish things with rm, but without slub I
don't think the issues it was trying to solve would have been discussed
at all.

> 
> Unfortunately we're now in a position where we can't just remove SLUB
> (it's an improvement over SLAB for NUMA) so we're stuck with two
> allocators with third one on its way to the kernel. So yes, it makes a
> lot of sense to me to fix CONFIG_PARAVIRT regression before merging
> more of the xen stuff in the kernel. It's always easier to fix these
> things before they hit the kernel and people start to depend on them.

The problem is that people already depend on them ;)  If people want to
nack xen based on code structure, that's more than fair,  I just hope we
can keep the discussion around something the xen developers can work
toward.

Micro benchmarks come and go, we tune as best we can based on the
tradeoffs at hand.

-chris
