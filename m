Return-Path: <linux-kernel-owner+w=401wt.eu-S1764076AbXK2Vvx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764076AbXK2Vvx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 16:51:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764020AbXK2Vvj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 16:51:39 -0500
Received: from mx1.redhat.com ([66.187.233.31]:59096 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763725AbXK2Vvi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 16:51:38 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: jan.kratochvil@redhat.com
Subject: Re: [PATCH x86/mm 01/11] x86-32 thread_struct.debugreg
In-Reply-To: Ingo Molnar's message of  Thursday, 29 November 2007 13:23:24 +0100 <20071129122324.GA11414@elte.hu>
References: <20071129115711.9FC8526F8E7@magilla.localdomain>
	<20071129122324.GA11414@elte.hu>
Emacs: no job too big... no job.
Message-Id: <20071129215055.3A79D26F8E7@magilla.localdomain>
Date: Thu, 29 Nov 2007 13:50:55 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> thanks, i've merged your 11 patches - they passed a basic build and boot 
> test as well.

Thanks!

> Roland, you've done a lot of gdb / strace / glibc development, what 
> would you suggest for us to use as a ptrace regression checker? The 
> problem is that ptrace is not normally used on a default bootup of a 
> distro, and some of the ptrace features are really arcane. UML is an 
> extensive ptrace user, so running it might be a good start, but do you 
> know of any, more directed testsuite that is expected to hit all (or at 
> least a substantial percentage of) the various ptrace features that we 
> are affecting with these ptrace patches?

Jan Kratochvil has helped me a great deal with ptrace testing lately.
We have started to collect a small regression test suite, see
http://sourceware.org/systemtap/wiki/utrace/tests for pointers.  That
has tests for individual problems that have come up, and not anything
exhaustive for testing all ptrace functionality.  The gdb test suite
is moderately torturous and more or less the standard big smoke test.
UML is also a good test, though I have never been set up to verify
anything beyond "UML seems to boot far enough to complain I don't
have a userland filesystem for it".  

Most of the changes I've submitted lately are just moving code around
and not changing its logic substantially.  So for most iterations
I've been reaosnably confident after just a few quick smoke tests
with simple manual uses of strace and gdb.


Thanks,
Roland
