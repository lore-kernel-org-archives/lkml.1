Return-Path: <linux-kernel-owner+w=401wt.eu-S932536AbXBNUOd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932536AbXBNUOd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 15:14:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932562AbXBNUOd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 15:14:33 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:2624 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932560AbXBNUOc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 15:14:32 -0500
X-AuthUser: davidel@xmailserver.org
Date: Wed, 14 Feb 2007 12:14:29 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Benjamin LaHaise <bcrl@kvack.org>
cc: Russell King <rmk+lkml@arm.linux.org.uk>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Ulrich Drepper <drepper@redhat.com>, Zach Brown <zach.brown@oracle.com>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       "David S. Miller" <davem@davemloft.net>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 06/11] syslets: core, documentation
In-Reply-To: <20070214200347.GK32271@kvack.org>
Message-ID: <Pine.LNX.4.64.0702141206190.7796@alien.or.mcafeemobile.com>
References: <20060529212109.GA2058@elte.hu> <20070213142042.GG638@elte.hu>
 <20070214103655.GB4241@flint.arm.linux.org.uk> <20070214105039.GC6801@elte.hu>
 <20070214110419.GC4241@flint.arm.linux.org.uk>
 <Pine.LNX.4.64.0702140919200.7480@alien.or.mcafeemobile.com>
 <20070214180344.GI32271@kvack.org> <Pine.LNX.4.64.0702141135390.7796@alien.or.mcafeemobile.com>
 <20070214200347.GK32271@kvack.org>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Feb 2007, Benjamin LaHaise wrote:

> On Wed, Feb 14, 2007 at 11:45:23AM -0800, Davide Libenzi wrote:
> > Sort of, except that the whole thing can complete syncronously w/out 
> > context switches. The real point of the whole fibrils/syslets solution is 
> > that kind of optimization. The solution is as good as it is now, for 
> 
> Except that You Can't Do That (tm).  Try to predict beforehand if the code 
> path being followed will touch the FPU or SSE state, and you can't.  There is 
> no way to avoid the context switch overhead, as you have to preserve things 
> so that whatever state is being returned to the user is as it was.  Unless 
> you plan on resetting the state beforehand, but then you have to call into 
> arch specific code that ends up with a comparable overhead to the context 
> switch.

I think you may have mis-interpreted my words. *When* a schedule would 
block a synco execution try, then you do have a context switch. Noone 
argue that, and the code is clear. The sys_async_exec thread will block, 
and a newly woke up thread will re-emerge to sys_async_exec with a NULL 
returned to userspace. But in a "cachehit" case (no schedule happens 
during the syscall/*let execution), there is no context switch at all. 
That is the whole point of the optimization.



- Davide


