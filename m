Return-Path: <linux-kernel-owner+w=401wt.eu-S1753305AbYKHARz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753305AbYKHARz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 19:17:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752346AbYKHARq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 19:17:46 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:41938 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751490AbYKHARp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 19:17:45 -0500
Date: Sat, 8 Nov 2008 00:15:55 +0000
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: David Howells <dhowells@redhat.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Andrew Morton <akpm@linux-foundation.org>, Nicolas Pitre <nico@cam.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-kernel@vger.kernel.org, Ralf Baechle <ralf@linux-mips.org>,
       benh@kernel.crashing.org, paulus@samba.org,
       David Miller <davem@davemloft.net>, Ingo Molnar <mingo@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>, linux-arch@vger.kernel.org
Subject: Re: [RFC patch 08/18] cnt32_to_63 should use smp_rmb()
Message-ID: <20081108001555.GE18378@flint.arm.linux.org.uk>
Mail-Followup-To: David Howells <dhowells@redhat.com>,
	Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
	Andrew Morton <akpm@linux-foundation.org>,
	Nicolas Pitre <nico@cam.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Ingo Molnar <mingo@elte.hu>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	linux-kernel@vger.kernel.org, Ralf Baechle <ralf@linux-mips.org>,
	benh@kernel.crashing.org, paulus@samba.org,
	David Miller <davem@davemloft.net>, Ingo Molnar <mingo@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Steven Rostedt <rostedt@goodmis.org>, linux-arch@vger.kernel.org
References: <20081107003816.9b0f947a.akpm@linux-foundation.org> <20081107052336.652868737@polymtl.ca> <20081107053349.861709786@polymtl.ca> <20081106220530.5b0e3a96.akpm@linux-foundation.org> <alpine.LFD.2.00.0811070256450.13034@xanadu.home> <25363.1226056819@redhat.com> <20081107164758.GB22134@Krystal> <20081107201118.GB28600@flint.arm.linux.org.uk> <20081107213610.GC2654@Krystal> <9405.1226101315@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9405.1226101315@redhat.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 07, 2008 at 11:41:55PM +0000, David Howells wrote:
> Russell King <rmk+lkml@arm.linux.org.uk> wrote:
> 
> > Well, that's where it was - private to ARM.  Then David Howells came
> > along and unilaterally - and without reference to anyone as far as I
> > can see - moved it to include/linux.
> > 
> > Neither Nicolas, nor me had any idea that it was going to move into
> > include/linux - the first we knew of it was when pulling the change
> > from Linus' tree.
> > 
> > Look, if people in the kernel community can't or won't communicate
> > with others (either through malice, purpose or accident), you can
> > expect this kind of crap to happen.
> 
> Excuse me, Russell, but I sent Nicolas an email prior to doing so asking him
> if he had any objections:
> 
> 	To: Nicolas Pitre <nico@cam.org>
> 	cc: dhowells@redhat.com
> 	Subject: Moving asm-arm/cnt32_to_63.h to include/linux/
> 	Date: Thu, 31 Jul 2008 16:04:04 +0100
> 
> 	Hi Nicolas,
> 
> 	Mind if I move include/asm-arm/cnt32_to_63.h to include/linux/?
> 
> 	I need to use it for MN10300.
> 
> 	David
> 
> He didn't respond.  Not only that, but I copied Nicolas on the patch to make
> the move and the patch to make MN10300 use it when I submitted it to Linus on
> the 24th September, so it's not like he didn't have plenty of time.  He
> certainly saw that because he joined in the discussion of the second patch.
> Furthermore, he could've asked Linus to refuse the patch, or to revert it if
> it had already gone in.
> 
> I suppose I should've cc'd the ARM list too... but why should it adversely
> affect ARM?

I take back the "Neither Nicolas" bit but the rest of my comment stands
and remains valid.

In light of akpm's demands to know how this got into the kernel, I decided
I'd put the story forward, especially as people in this thread are confused
about what it was designed for, and making random unfounded claiming that
its existing ARM uses are buggy when they aren't.

It sounds to me as if the right answer is for it to move back to being an
ARM private thing with a MN10300 private copy, rather than it pretending
to be something everyone can use.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
