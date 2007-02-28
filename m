Return-Path: <linux-kernel-owner+w=401wt.eu-S1751544AbXB1QRJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751544AbXB1QRJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 11:17:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751564AbXB1QRI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 11:17:08 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:4697 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751544AbXB1QRH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 11:17:07 -0500
X-AuthUser: davidel@xmailserver.org
Date: Wed, 28 Feb 2007 08:17:01 -0800 (PST)
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
In-Reply-To: <20070228094522.GA17716@elte.hu>
Message-ID: <Pine.LNX.4.64.0702280740250.5935@alien.or.mcafeemobile.com>
References: <20070221211355.GA7302@elte.hu> <f2b55d220702211446l78af6f14hc3e0dd0084016770@mail.gmail.com>
 <20070221233111.GB5895@elte.hu> <45DCD9E5.2010106@redhat.com>
 <20070222074044.GA4158@elte.hu> <Pine.LNX.4.64.0702221130050.1356@alien.or.mcafeemobile.com>
 <20070228094522.GA17716@elte.hu>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Feb 2007, Ingo Molnar wrote:

> 
> * Davide Libenzi <davidel@xmailserver.org> wrote:
> 
> > Why can't aio_* be implemented with *simple* (or parallel/unrelated) 
> > syscall submit w/out the burden of a complex, limiting and heavy API
> 
> there are so many variants of what people think 'asynchronous IO' should 
> look like - i'd not like to limit them. I agree that once a particular 
> syslet script becomes really popular, it might (and should) in fact be 
> pushed into a separate system call.
> 
> But i also agree that a one-shot-syscall sys_async() syscall could be 
> done too - for those uses where only a single system call is needed and 
> where the fetching of a single uatom would be small but nevertheless 
> unnecessary overhead. A one-shot async syscall needs to get /8/ 
> parameters (the syscall nr is the seventh parameter and the return code 
> of the nested syscall is the eighth). So at least two parameters will 
> have to be passed in indirectly and validated, and 32/64-bit compat 
> conversions added, etc. anyway!

At this point, given how threadlets can be easily/effectively dispatched 
from userspace, I'd argue the presence of either single/parallel or syslet 
submission altogether. Threadlets allows you to code chains *way* more 
naturally than syslets, and since they basically are like functions calls 
in the fast path, they can be used even for single/parallel submissions. 
No compat code required (ok, besides the trivial async_wait).
My point is, the syslet infrastructure is expensive for the kernel in 
terms of compat, and extra code added to handle the cond/jumps/etc. Is 
also non-trivial to use from userspace. Are those big performance 
advantages there to justify its existence? I doubt that the price of a 
sysenter is a lot bigger than a atom decoding, but I'm looking forward in 
being proven wrong by real life performance numbers ;)



- Davide


