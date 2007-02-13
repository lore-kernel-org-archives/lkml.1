Return-Path: <linux-kernel-owner+w=401wt.eu-S1751443AbXBMX2H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751443AbXBMX2H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 18:28:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751406AbXBMX2H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 18:28:07 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:4626 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751443AbXBMX2G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 18:28:06 -0500
X-AuthUser: davidel@xmailserver.org
Date: Tue, 13 Feb 2007 15:28:03 -0800 (PST)
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
       Benjamin LaHaise <bcrl@kvack.org>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 00/11] ANNOUNCE: "Syslets", generic asynchronous system
 call support
In-Reply-To: <20070213221052.GE22104@elte.hu>
Message-ID: <Pine.LNX.4.64.0702131526410.32055@alien.or.mcafeemobile.com>
References: <20070213142010.GA638@elte.hu> <Pine.LNX.4.64.0702131219240.32055@alien.or.mcafeemobile.com>
 <Pine.LNX.4.64.0702131320450.32055@alien.or.mcafeemobile.com>
 <20070213221052.GE22104@elte.hu>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Feb 2007, Ingo Molnar wrote:

> * Davide Libenzi <davidel@xmailserver.org> wrote:
> 
> > > If this is going to be a generic AIO subsystem:
> > > 
> > > - Cancellation of peding request
> > 
> > What about the busy_async_threads list becoming a hash/rb_tree indexed 
> > by syslet_atom ptr. A cancel would lookup the thread and send a signal 
> > (of course, signal handling of the async threads should be set 
> > properly)?
> 
> well, each async syslet has a separate TID at the moment, so if we want 
> a submitted syslet to be cancellable then we could return the TID of the 
> syslet handler (instead of the NULL) in sys_async_exec(). Then 
> user-space could send a signal the old-fashioned way, via sys_tkill(), 
> if it so wishes.

That works too. I was thinking about identifying syslets with the 
userspace ptr, but the TID is fine too.



> the TID could also be used in a sys_async_wait_on() API. I.e. it would 
> be a natural, readily accessible 'cookie' for the pending work. TIDs can 
> be looked up lockless via RCU, so it's reasonably fast as well.
> 
> ( Note that there's already a way to 'signal' pending syslets: do_exit() 
>   in the user context will signal all async contexts (which results in 
>   -EINTR of currently executing syscalls, wherever possible) and will 
>   tear them down. But that's too crude for aio_cancel() i guess. )

Yup.



- Davide


