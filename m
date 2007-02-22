Return-Path: <linux-kernel-owner+w=401wt.eu-S1751792AbXBVTiK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751792AbXBVTiK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 14:38:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751793AbXBVTiJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 14:38:09 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:4721 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751792AbXBVTiI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 14:38:08 -0500
X-AuthUser: davidel@xmailserver.org
Date: Thu, 22 Feb 2007 11:38:03 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Ingo Molnar <mingo@elte.hu>
cc: Ulrich Drepper <drepper@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Zach Brown <zach.brown@oracle.com>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       "David S. Miller" <davem@davemloft.net>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 00/13] Syslets, "Threadlets", generic AIO support, v3
In-Reply-To: <20070222074044.GA4158@elte.hu>
Message-ID: <Pine.LNX.4.64.0702221130050.1356@alien.or.mcafeemobile.com>
References: <20070221211355.GA7302@elte.hu> <f2b55d220702211446l78af6f14hc3e0dd0084016770@mail.gmail.com>
 <20070221233111.GB5895@elte.hu> <45DCD9E5.2010106@redhat.com>
 <20070222074044.GA4158@elte.hu>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Feb 2007, Ingo Molnar wrote:

> 
> * Ulrich Drepper <drepper@redhat.com> wrote:
> 
> > Ingo Molnar wrote:
> > > in terms of AIO, the best queueing model is i think what the kernel uses 
> > > internally: freely ordered, with barrier support.
> > 
> > Speaking of AIO, how do you imagine lio_listio is implemented?  If 
> > there is no asynchronous syscall it would mean creating a threadlet 
> > for each request but this means either waiting or creating 
> > several/many threads.
> 
> my current thinking is that special-purpose (non-programmable, static) 
> APIs like aio_*() and lio_*(), where every last cycle of performance 
> matters, should be implemented using syslets - even if it is quite 
> tricky to write syslets (which they no doubt are - just compare the size 
> of syslet-test.c to threadlet-test.c). So i'd move syslets into the same 
> category as raw syscalls: pieces of the raw infrastructure between the 
> kernel and glibc, not an exposed API to apps. [and even if we keep them 
> in that category they still need quite a bit of API work, to clean up 
> the 32/64-bit issues, etc.]

Now that chains of syscalls can be way more easily handled with clets^wthreadlets,
why would we need the whole syslets crud inside?
Why can't aio_* be implemented with *simple* (or parallel/unrelated) 
syscall submit w/out the burden of a complex, limiting and heavy API (I 
won't list all the points against syslets, because I already did it 
enough times)? The compat layer only is so bad to not be even funny.
Look at the code. Only removing the syslets crud would prolly cut 40% of 
it. And we did not even touch the compat code yet.



- Davide

