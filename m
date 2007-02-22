Return-Path: <linux-kernel-owner+w=401wt.eu-S1751795AbXBVTqu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751795AbXBVTqu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 14:46:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751801AbXBVTqu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 14:46:50 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:4733 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751795AbXBVTqu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 14:46:50 -0500
X-AuthUser: davidel@xmailserver.org
Date: Thu, 22 Feb 2007 11:46:48 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
cc: Ingo Molnar <mingo@elte.hu>, Ulrich Drepper <drepper@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Zach Brown <zach.brown@oracle.com>,
       "David S. Miller" <davem@davemloft.net>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 00/13] Syslets, "Threadlets", generic AIO support, v3
In-Reply-To: <20070222133201.GB5208@2ka.mipt.ru>
Message-ID: <Pine.LNX.4.64.0702221139320.1356@alien.or.mcafeemobile.com>
References: <20070221211355.GA7302@elte.hu> <f2b55d220702211446l78af6f14hc3e0dd0084016770@mail.gmail.com>
 <20070221233111.GB5895@elte.hu> <45DCD9E5.2010106@redhat.com>
 <20070222074044.GA4158@elte.hu> <20070222113148.GA3781@2ka.mipt.ru>
 <20070222125931.GB25788@elte.hu> <20070222133201.GB5208@2ka.mipt.ru>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Feb 2007, Evgeniy Polyakov wrote:

> > maybe it will, maybe it wont. Lets try? There is no true difference 
> > between having a 'request structure' that represents the current state 
> > of the HTTP connection plus a statemachine that moves that request 
> > between various queues, and a 'kernel stack' that goes in and out of 
> > runnable state and carries its processing state in its stack - other 
> > than the amount of RAM they take. (the kernel stack is 4K at a minimum - 
> > so with a million outstanding requests they would use up 4 GB of RAM. 
> > With 20k outstanding requests it's 80 MB of RAM - that's acceptable.)
> 
> I tried already :) - I just made a allocations atomic in tcp_sendmsg() and
> ended up with 1/4 of the sends blocking (I counted both allocation
> failure and socket queue overflow). Those 20k blocked requests were
> created in about 20 seconds, so roughly saying we have 1k of thread
> creation/freeing per second - do we want this?

A dynamic pool will smooth thread creation/freeing up by a lot.
And, in my box a *pthread* create/free takes ~10us, at 1000/s is 10ms, 1%. 
Bad, but not so aweful ;)
Look, I'm *definitely* not trying to advocate the use of async syscalls for 
network here, just pointing out that when we're talking about threads, 
Linux does a pretty good job.




- Davide


