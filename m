Return-Path: <linux-kernel-owner+w=401wt.eu-S1763427AbXK2VeS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763427AbXK2VeS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 16:34:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757832AbXK2VeK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 16:34:10 -0500
Received: from mx1.redhat.com ([66.187.233.31]:46061 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758786AbXK2VeJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 16:34:09 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
X-Fcc: ~/Mail/linus
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH x86/mm 06/11] x86 ptrace arch merge
In-Reply-To: Andrew Morton's message of  Thursday, 29 November 2007 09:28:52 -0800 <20071129092852.3b7a4b2f.akpm@linux-foundation.org>
X-Fcc: ~/Mail/linus
References: <20071129115711.9FC8526F8E7@magilla.localdomain>
	<20071129120014.E34C326F8E7@magilla.localdomain>
	<20071129092852.3b7a4b2f.akpm@linux-foundation.org>
X-Windows: a mistake carried out to perfection.
Message-Id: <20071129213357.00EA226F8E7@magilla.localdomain>
Date: Thu, 29 Nov 2007 13:33:56 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > --- a/arch/x86/kernel/ptrace.c
> > +++ b/arch/x86/kernel/ptrace.c
> > @@ -461,12 +461,13 @@ static int ptrace_set_debugreg(struct task_struct *child,
> >  void ptrace_disable(struct task_struct *child)
> >  {
> >  	user_disable_single_step(child);
> > +#ifdef TIF_SYSCALL_EMU
> >  	clear_tsk_thread_flag(child, TIF_SYSCALL_EMU);
> > +#endif
> 
> Is TIF_SYSCALL_EMU ever undefined here?

Yes, it not defined on CONFIG_X86_64.
(That is something to be addressed later on.)


Thanks,
Roland
