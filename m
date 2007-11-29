Return-Path: <linux-kernel-owner+w=401wt.eu-S1762111AbXK2MYS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762111AbXK2MYS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 07:24:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756686AbXK2MYE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 07:24:04 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:54391 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757010AbXK2MYD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 07:24:03 -0500
Date: Thu, 29 Nov 2007 13:23:24 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Roland McGrath <roland@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH x86/mm 01/11] x86-32 thread_struct.debugreg
Message-ID: <20071129122324.GA11414@elte.hu>
References: <20071129115711.9FC8526F8E7@magilla.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071129115711.9FC8526F8E7@magilla.localdomain>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


thanks, i've merged your 11 patches - they passed a basic build and boot 
test as well.

Roland, you've done a lot of gdb / strace / glibc development, what 
would you suggest for us to use as a ptrace regression checker? The 
problem is that ptrace is not normally used on a default bootup of a 
distro, and some of the ptrace features are really arcane. UML is an 
extensive ptrace user, so running it might be a good start, but do you 
know of any, more directed testsuite that is expected to hit all (or at 
least a substantial percentage of) the various ptrace features that we 
are affecting with these ptrace patches?

btw., your cleanup patches are having a nice effect on code quality as 
well:

                               errors   lines of code   errors/KLOC
   [before]    arch/x86/         5231          116998          44.7
   [after]     arch/x86/         5132          116656          43.9

(the 'errors' column is the sum of all .c files as per the error count 
of scripts/checkpatch.pl --file output)

it's refreshing to see life being brought back into the ptrace code 
again :-)

	Ingo
