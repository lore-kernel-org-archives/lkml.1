Return-Path: <linux-kernel-owner+w=401wt.eu-S1759614AbYB2RiI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759614AbYB2RiI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 12:38:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755655AbYB2Rh4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 12:37:56 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:44327 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753935AbYB2Rhz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 12:37:55 -0500
Date: Fri, 29 Feb 2008 18:37:05 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Roland McGrath <roland@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86_64 ia32 syscall restart fix
Message-ID: <20080229173705.GA19423@elte.hu>
References: <20080229035707.EAE862700FD@magilla.localdomain> <20080229155207.GC27248@elte.hu> <alpine.LFD.1.00.0802290814320.17889@woody.linux-foundation.org> <20080229164510.GA6850@elte.hu> <alpine.LFD.1.00.0802290855230.17889@woody.linux-foundation.org> <20080229171737.GA10604@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080229171737.GA10604@elte.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> and one area where commit messages are totally important IMO is bug 
> forensics. For every regression we find we try to put in the commit ID 
> that broke it. Information like that is vital to have a good (and 
> objective) picture about how bugs get into and get out of the kernel 
> and it also alerts us to change/improve infrastructure if certain 
> categories of bugs happen too often.

another "commit space" feature Thomas and me was thinking about was to 
put in "backport suggestions" for -stable the following way:

   Backport-suggested-by: Ingo Molnar <mingo@elte.hu>

and the -stable tree could then notice it, and once it has been 
backported, they could put in their "done" notifiers via:

   Backported-from: 67ca7bde2e9d3516b5

or:

   Backport-rejected: 67ca7bde2e9d3516b5

This way the act of suggesting backports to the -stable tree (and their 
rejection) could be fully automated, and the answer to the rather 
difficult question:

   "has -stable picked up all backport requests, and if not, why?"

could be scripted up.

A further (small) variation of this scheme: if a fix is noticed to be a 
backport candidate later on, or a user notices that a fix that has gone 
upstream fixes a -stable bug too, this information could be signalled in 
a separate, special, empty commit:

   Backport-suggested-by: 67ca7bde2e9d35, Ingo Molnar <mingo@elte.hu>


this way subsystem maintainers could have a reliable protocol of getting 
fixes integrated into -stable - purely via the commit messages in your 
tree.

... but then we decided that handling x86 architecture maintainance is 
work enough already, without us complicating our own life any further 
;-)

But the idea is solid nevertheless, and if everyone did it the -stable 
guys would have a much easier life as well :-) [ We could start doing it 
in x86.git if there's general agreement and if the -stable guys 
specifically asked for this. ]

	Ingo
