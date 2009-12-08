Return-Path: <linux-kernel-owner+w=401wt.eu-S965749AbZLHVen@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965749AbZLHVen (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 16:34:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965711AbZLHVem
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 16:34:42 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42603 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756284AbZLHVel (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 16:34:41 -0500
Date: Tue, 8 Dec 2009 13:34:02 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Ingo Molnar <mingo@elte.hu>
cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] x86/paravirt for v2.6.33
In-Reply-To: <20091203210913.GA24351@elte.hu>
Message-ID: <alpine.LFD.2.00.0912081329460.3560@localhost.localdomain>
References: <20091203210913.GA24351@elte.hu>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 3 Dec 2009, Ingo Molnar wrote:
> 
> Please pull the latest x86-paravirt-for-linus git tree from:
> 
>    git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-paravirt-for-linus

I _really_ don't like this:

> -long sys_iopl(struct pt_regs *regs)
> +asmlinkage long sys_iopl(unsigned int level)
>  {
> -	unsigned int level = regs->bx;
>  	struct thread_struct *t = &current->thread;
> +	struct pt_regs *regs = task_pt_regs(current);

I do _not_ want to add any more task_pt_regs() crap, please.

Why? It's wrong for at least vm86 mode (and from kernel system calls). 
Maybe we can't get into system calls from vm86 mode, and the kernel 
hopefully doesn't do those things anyway, but the point is, you chose the 
wrong way to go.

The old version that actually passed the stack frame was better. Why pick 
the inferior version?

		Linus
