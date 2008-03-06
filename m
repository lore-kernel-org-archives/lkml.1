Return-Path: <linux-kernel-owner+w=401wt.eu-S1757944AbYCFHwh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757944AbYCFHwh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 02:52:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751101AbYCFHw1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 02:52:27 -0500
Received: from mx1.redhat.com ([66.187.233.31]:42938 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750925AbYCFHw0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 02:52:26 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
X-Fcc: ~/Mail/linus
Cc: Jan Beulich <jbeulich@novell.com>, tglx@linutronix.de, hpa@zytor.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: fix typo(?) in step.c
In-Reply-To: Ingo Molnar's message of  Wednesday, 5 March 2008 14:41:50 +0100 <20080305134150.GA16477@elte.hu>
References: <47CE69B0.76E4.0078.0@novell.com>
	<20080305134150.GA16477@elte.hu>
Emacs: Our Lady of Perpetual Garbage Collection
Message-Id: <20080306075223.BA28B2700FD@magilla.localdomain>
Date: Wed,  5 Mar 2008 23:52:23 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Roland - i guess this means block-stepping (a new ptrace feature in .25) 
> is not particularly well-tested. Do you have any standalone testcases 
> that could be run?

I'm pretty sure that noone really uses it yet.  The test I used when I
originally wrote the feature is in the ptrace-tests suite.  (See
http://sourceware.org/systemtap/wiki/utrace/tests about that suite.)
I haven't particularly tested it since then, if it got broken later.

http://sources.redhat.com/cgi-bin/cvsweb.cgi/tests/ptrace-tests/tests/block-step.c?cvsroot=systemtap

Be sure to compile with current kernel-headers, or hand-tweak to define
PTRACE_SINGLEBLOCK.  Use -std=gnu99 -D_GNU_SOURCE.

The bogon came in commit eee3af4a2c83a97fff107ddc445d9df6fded9ce4,
the introduction of the ptrace BTS stuff.  Sorry I did not scour and 
cite every problem in that patch, since I had NAK'd the entire thing
as needing more careful review and incremental introduction after 2.6.25.

As I said then, one of my concerns was with the low-level tweaks not yet
sufficiently baked, independent from my reservations about the ptrace
feature.  Your #if'ing out of the user ABI additions for 2.6.25 does
nothing to remove the unknown new risks from all the tweaks with fingers in
the low-level arch stuff.  This is the sort of thing I was concerned about.
(And this one is easy.)

The block-step test only tested that PTRACE_SINGLEBLOCK worked right.
I just souped it up to also test that PTRACE_SINGLESTEP still works
immediately afterwards.  This still does not show any problem from this
bug.  The case that would be broken by it is rather more arcane.  I
haven't worked out the test case that fails with the bogon.


Thanks,
Roland
