Return-Path: <linux-kernel-owner+w=401wt.eu-S933403AbXBXHKp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933403AbXBXHKp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Feb 2007 02:10:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933406AbXBXHKp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Feb 2007 02:10:45 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:45638 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933403AbXBXHKo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Feb 2007 02:10:44 -0500
Date: Sat, 24 Feb 2007 08:04:09 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
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
Message-ID: <20070224070409.GB3357@elte.hu>
References: <20070221211516.GD7579@elte.hu> <Pine.LNX.4.64.0702231504370.31281@alien.or.mcafeemobile.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0702231504370.31281@alien.or.mcafeemobile.com>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Davide Libenzi <davidel@xmailserver.org> wrote:

> > +asmlinkage long
> > +sys_threadlet_on(unsigned long restore_stack,
> > +		 unsigned long restore_eip,
> > +		 struct async_head_user __user *ahu)

> > +asmlinkage long sys_threadlet_off(void)

> If we have a new syscall that does the exec, we can save the two 
> on/off calls.

the on/off calls are shaped in a way that makes them ultimately 
vsyscall-able - the kernel only needs to know about the fact that we are 
in a threadlet (so that the scheduler can do its special 
push-head-to-another-context thing) - and this can be signalled via a 
small user-space-side info structure as well, put into the TLS.

> [...] Also, the complete_thread() thingy can be done automatically 
> from inside the kernel upon function return, by hence making the 
> threadlet function look like a normal thread function:

yeah - and that's how it works in my current codebase already, 
threadlet_off() takes a 'completion event' pointer as well, and the ahu. 
I'll release v4 so that you can have a look.

	Ingo
