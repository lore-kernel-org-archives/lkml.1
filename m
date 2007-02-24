Return-Path: <linux-kernel-owner+w=401wt.eu-S933562AbXBXVKf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933562AbXBXVKf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Feb 2007 16:10:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933563AbXBXVKf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Feb 2007 16:10:35 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:2038 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933562AbXBXVKf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Feb 2007 16:10:35 -0500
X-AuthUser: davidel@xmailserver.org
Date: Sat, 24 Feb 2007 13:10:33 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Ingo Molnar <mingo@elte.hu>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Ulrich Drepper <drepper@redhat.com>, Zach Brown <zach.brown@oracle.com>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       "David S. Miller" <davem@davemloft.net>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 04/13] syslets: core code
In-Reply-To: <20070224070409.GB3357@elte.hu>
Message-ID: <Pine.LNX.4.64.0702241306070.17345@alien.or.mcafeemobile.com>
References: <20070221211516.GD7579@elte.hu> <Pine.LNX.4.64.0702231504370.31281@alien.or.mcafeemobile.com>
 <20070224070409.GB3357@elte.hu>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 24 Feb 2007, Ingo Molnar wrote:

> * Davide Libenzi <davidel@xmailserver.org> wrote:
> 
> > > +asmlinkage long
> > > +sys_threadlet_on(unsigned long restore_stack,
> > > +		 unsigned long restore_eip,
> > > +		 struct async_head_user __user *ahu)
> 
> > > +asmlinkage long sys_threadlet_off(void)
> 
> > If we have a new syscall that does the exec, we can save the two 
> > on/off calls.
> 
> the on/off calls are shaped in a way that makes them ultimately 
> vsyscall-able - the kernel only needs to know about the fact that we are 
> in a threadlet (so that the scheduler can do its special 
> push-head-to-another-context thing) - and this can be signalled via a 
> small user-space-side info structure as well, put into the TLS.

IMO it's not a matter of speed. We'll have those two new syscalls, that I 
don't see other practical use for. IMO the best thing would be to hide all 
inside the sys_threadlet_exec (or whatever name).




> > [...] Also, the complete_thread() thingy can be done automatically 
> > from inside the kernel upon function return, by hence making the 
> > threadlet function look like a normal thread function:
> 
> yeah - and that's how it works in my current codebase already, 
> threadlet_off() takes a 'completion event' pointer as well, and the ahu. 
> I'll release v4 so that you can have a look.

Ok. Will look into it...



- Davide


