Return-Path: <linux-kernel-owner+w=401wt.eu-S933679AbXBYIFu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933679AbXBYIFu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Feb 2007 03:05:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933680AbXBYIFu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Feb 2007 03:05:50 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:34050 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933679AbXBYIFt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Feb 2007 03:05:49 -0500
Date: Sun, 25 Feb 2007 08:59:46 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Kyle Moffett <mrmacman_g4@mac.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
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
Message-ID: <20070225075946.GA24291@elte.hu>
References: <20070221211516.GD7579@elte.hu> <Pine.LNX.4.64.0702231504370.31281@alien.or.mcafeemobile.com> <20070224070409.GB3357@elte.hu> <Pine.LNX.4.64.0702241306070.17345@alien.or.mcafeemobile.com> <21665A89-1BEE-459D-8ED1-ACCB352CF8A4@mac.com> <Pine.LNX.4.64.0702241422110.17345@alien.or.mcafeemobile.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0702241422110.17345@alien.or.mcafeemobile.com>
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

> > No, it absolutely is a matter of speed.  The reason to have those 
> > two implemented that way is so that they can be implemented as 
> > vsyscalls completely in userspace.  This means that on most modern 
> > platforms you can implement the "make a threadlet when I block" 
> > semantic without even touching kernel-mode.  The way it's set up all 
> > you'd have to do is save some parameters, set up a new callstack, 
> > and poke a "1" into a memory address in the TLS.  To stop, you 
> > effectively just poke a "0" into the spot in the TLS and either 
> > return or terminate the thread.
> 
> Right. I don't why but I got the implression Ingo's threadlet_exec 
> example was just sketch code to be moved in a syscall. That's why I 
> was talking about a sys_threadlet_exec. But yeah, it makes a lot of 
> sense to turn threadlet_exec in a glibc thing, and play everything in 
> userspace at that point.

yeah, not having to do any extra entry into the kernel at all (in the 
cached case), and to make them in essence equivalent to a function call 
is my plan/hope for threadlets :-)

	Ingo
