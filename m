Return-Path: <linux-kernel-owner+w=401wt.eu-S933908AbYB2VEg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933908AbYB2VEg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 16:04:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760977AbYB2VEZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 16:04:25 -0500
Received: from smtp1.linux-foundation.org ([207.189.120.13]:44036 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751685AbYB2VEY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 16:04:24 -0500
Date: Fri, 29 Feb 2008 13:02:37 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: torvalds@linux-foundation.org, roland@redhat.com, tglx@linutronix.de,
       linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [PATCH] x86_64 ia32 syscall restart fix
Message-Id: <20080229130237.da291a1e.akpm@linux-foundation.org>
In-Reply-To: <20080229173705.GA19423@elte.hu>
References: <20080229035707.EAE862700FD@magilla.localdomain>
	<20080229155207.GC27248@elte.hu>
	<alpine.LFD.1.00.0802290814320.17889@woody.linux-foundation.org>
	<20080229164510.GA6850@elte.hu>
	<alpine.LFD.1.00.0802290855230.17889@woody.linux-foundation.org>
	<20080229171737.GA10604@elte.hu>
	<20080229173705.GA19423@elte.hu>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 Feb 2008 18:37:05 +0100
Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
> > and one area where commit messages are totally important IMO is bug 
> > forensics. For every regression we find we try to put in the commit ID 
> > that broke it. Information like that is vital to have a good (and 
> > objective) picture about how bugs get into and get out of the kernel 
> > and it also alerts us to change/improve infrastructure if certain 
> > categories of bugs happen too often.
> 
> another "commit space" feature Thomas and me was thinking about was to 
> put in "backport suggestions" for -stable the following way:
> 
>    Backport-suggested-by: Ingo Molnar <mingo@elte.hu>
> 
> and the -stable tree could then notice it, and once it has been 
> backported, they could put in their "done" notifiers via:
> 
>    Backported-from: 67ca7bde2e9d3516b5
> 
> or:
> 
>    Backport-rejected: 67ca7bde2e9d3516b5
> 
> This way the act of suggesting backports to the -stable tree (and their 
> rejection) could be fully automated, and the answer to the rather 
> difficult question:
> 
>    "has -stable picked up all backport requests, and if not, why?"
> 
> could be scripted up.
> 
> A further (small) variation of this scheme: if a fix is noticed to be a 
> backport candidate later on, or a user notices that a fix that has gone 
> upstream fixes a -stable bug too, this information could be signalled in 
> a separate, special, empty commit:
> 
>    Backport-suggested-by: 67ca7bde2e9d35, Ingo Molnar <mingo@elte.hu>
> 
> 
> this way subsystem maintainers could have a reliable protocol of getting 
> fixes integrated into -stable - purely via the commit messages in your 
> tree.
> 
> ... but then we decided that handling x86 architecture maintainance is 
> work enough already, without us complicating our own life any further 
> ;-)
> 
> But the idea is solid nevertheless, and if everyone did it the -stable 
> guys would have a much easier life as well :-) [ We could start doing it 
> in x86.git if there's general agreement and if the -stable guys 
> specifically asked for this. ]
> 

I believe the -stable guys have a bot which trolls the mainline commits
mailing list for "cc:.*stable@kernel.org".  So anybody anywhere in the
patch delivery chain can append "Cc: <stable@kernel.org>" and things
should get appropriate consideration.

The place where I suspect there is a lot of lossage is people simply not
thinking about whether a fix should be backported.  I'm forever fussing
about that for the patches I handle (and I still miss some) but I have a
suspicion that not all tree-owners do this fully.

