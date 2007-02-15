Return-Path: <linux-kernel-owner+w=401wt.eu-S1750716AbXBOFwo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750716AbXBOFwo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 00:52:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751380AbXBOFwo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 00:52:44 -0500
Received: from smtp.osdl.org ([65.172.181.24]:35778 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750716AbXBOFwn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 00:52:43 -0500
Date: Wed, 14 Feb 2007 21:51:23 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Blaisorblade <blaisorblade@yahoo.it>
Cc: user-mode-linux-devel@lists.sourceforge.net, Jeff Dike <jdike@addtoit.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Andi Kleen <ak@suse.de>, stable@kernel.org
Subject: Re: [uml-devel] x86_64: fix 2.6.18 regression -
 PTRACE_OLDSETOPTIONS should be accepted
Message-Id: <20070214215123.57ef2d4a.akpm@linux-foundation.org>
In-Reply-To: <200702150443.42287.blaisorblade@yahoo.it>
References: <11715068631914-git-send-email-blaisorblade@yahoo.it>
	<20070215025423.GA9300@ccure.user-mode-linux.org>
	<200702150443.42287.blaisorblade@yahoo.it>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Feb 2007 04:43:41 +0100 Blaisorblade <blaisorblade@yahoo.it> wrote:

> > I sent an equivalent patch in earlier today:
> Doh! Interesting this timing...
> 
> > Index: linux-2.6/arch/x86_64/ia32/ptrace32.c
> > ===================================================================
> > --- linux-2.6.orig/arch/x86_64/ia32/ptrace32.c
> > +++ linux-2.6/arch/x86_64/ia32/ptrace32.c
> > @@ -239,6 +239,8 @@ asmlinkage long sys32_ptrace(long reques
> >  	__u32 val;
> >
> >  	switch (request) {
> > +	case PTRACE_OLDSETOPTIONS:
> > +		request = PTRACE_SETOPTIONS;
> >  	case PTRACE_TRACEME:
> >  	case PTRACE_ATTACH:
> >  	case PTRACE_KILL:
> >
> > I change the request so that PTRACE_OLDSETOPTIONS doesn't need to
> > propogate any further.  However, it is present in include/asm-x86_64,
> > so I guess that counts as being part of the x86_64 ABI.  That being
> > the case, I guess my patch can be dropped in favor of this one.
> 
> It is handled in ptrace_request, unless there are include problems. I'm going 
> to reboot and test mine for any remaining problem.

Whatever happens, please ensure that the final fix makes it into -stable
as well.  Jeff's version of this patch wasn't cc'ed to stable@kernel.org.
