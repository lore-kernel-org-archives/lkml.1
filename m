Return-Path: <linux-kernel-owner+w=401wt.eu-S965050AbXBYRzW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965050AbXBYRzW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Feb 2007 12:55:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965054AbXBYRzV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Feb 2007 12:55:21 -0500
Received: from relay.2ka.mipt.ru ([194.85.82.65]:58028 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965050AbXBYRzU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Feb 2007 12:55:20 -0500
Date: Sun, 25 Feb 2007 20:44:38 +0300
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Ulrich Drepper <drepper@redhat.com>, Zach Brown <zach.brown@oracle.com>,
       "David S. Miller" <davem@davemloft.net>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 00/13] Syslets, "Threadlets", generic AIO support, v3
Message-ID: <20070225174438.GA13647@2ka.mipt.ru>
References: <20070221211355.GA7302@elte.hu> <20070224183421.GA6835@2ka.mipt.ru> <20070225172337.GB4998@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <20070225172337.GB4998@elte.hu>
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (2ka.mipt.ru [0.0.0.0]); Sun, 25 Feb 2007 20:45:18 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 25, 2007 at 06:23:38PM +0100, Ingo Molnar (mingo@elte.hu) wrote:
> 
> * Evgeniy Polyakov <johnpol@2ka.mipt.ru> wrote:
> 
> > On Wed, Feb 21, 2007 at 10:13:55PM +0100, Ingo Molnar (mingo@elte.hu) wrote:
> > > this is the v3 release of the syslet/threadlet subsystem:
> > > 
> > >    http://redhat.com/~mingo/syslet-patches/
> > 
> > There is no %xgs.
> > 
> > --- ./arch/i386/kernel/process.c~	2007-02-24 22:56:14.000000000 +0300
> > +++ ./arch/i386/kernel/process.c	2007-02-24 22:53:19.000000000 +0300
> > @@ -426,7 +426,6 @@
> >  
> >  	regs.xds = __USER_DS;
> >  	regs.xes = __USER_DS;
> > -	regs.xgs = __KERNEL_PDA;
> 
> hm, what tree are you using as a base? The syslet patches are against 
> v2.6.20 at the moment. (the x86 PDA changes will probably interfere with 
> it on v2.6.21-rc1-ish kernels) Note that otherwise the syslet/threadlet 
> patches are for x86 only at the moment (as i mentioned in the 
> announcement), and the generic code itself contains some occasional 
> x86-ishms as well. (None of the concepts are x86-specific though - 
> multi-stack architectures should work just as well as RISC-ish CPUs.)

It is rc1 - and crashes.
I test on i386 via epia (the only machine which runs x86 right now).

If there will not be any new patches, I will create 2.6.20 test tree
tomorrow.

> if you create a threadlet based test-webserver, could you please do a 
> comparable kevents implementation as well? I.e. same HTTP parser (or 
> non-parser, as usually the case is with prototypes ;). Best would be 
> something that one could trigger between threadlet and kevent mode, 
> using the same binary :-)

Ok, I will create such a monster tomorrow :)

I will use the same base for threadlet as for kevent/epoll - there is no
parser, just sendfile() of the static file which contains http header
and actual page.

threadlet1 {
	accept() 
	create threadlet2 {
		send data
	}
}

Is above scheme correct for threadlet scenario?

But note, that on my athlon64 3500 test machine kevent is about 7900
requests per second compared to 4000+ epoll, so expect a challenge.
lighhtpd is about the same 4000 requests per second though, since it can
not be easily optimized for kevents.

> 	Ingo

-- 
	Evgeniy Polyakov
