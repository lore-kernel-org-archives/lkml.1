Return-Path: <linux-kernel-owner+w=401wt.eu-S1752063AbXBWLgI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752063AbXBWLgI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 06:36:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752082AbXBWLgH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 06:36:07 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:57729 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752063AbXBWLgG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 06:36:06 -0500
Date: Fri, 23 Feb 2007 12:37:18 +0000
From: Alan <alan@lxorguk.ukuu.org.uk>
To: "Michael K. Edwards" <medwards.linux@gmail.com>
Cc: "Ingo Molnar" <mingo@elte.hu>, "Evgeniy Polyakov" <johnpol@2ka.mipt.ru>,
       "Ulrich Drepper" <drepper@redhat.com>, linux-kernel@vger.kernel.org,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Arjan van de Ven" <arjan@infradead.org>,
       "Christoph Hellwig" <hch@infradead.org>,
       "Andrew Morton" <akpm@zip.com.au>, "Zach Brown" <zach.brown@oracle.com>,
       "David S. Miller" <davem@davemloft.net>,
       "Suparna Bhattacharya" <suparna@in.ibm.com>,
       "Davide Libenzi" <davidel@xmailserver.org>,
       "Jens Axboe" <jens.axboe@oracle.com>,
       "Thomas Gleixner" <tglx@linutronix.de>
Subject: Re: [patch 00/13] Syslets, "Threadlets", generic AIO support, v3
Message-ID: <20070223123718.54c9670e@lxorguk.ukuu.org.uk>
In-Reply-To: <f2b55d220702221847p6b28f6eehed1bb5b1b0edf9f4@mail.gmail.com>
References: <20070221211355.GA7302@elte.hu>
	<f2b55d220702211446l78af6f14hc3e0dd0084016770@mail.gmail.com>
	<20070221233111.GB5895@elte.hu>
	<45DCD9E5.2010106@redhat.com>
	<20070222074044.GA4158@elte.hu>
	<20070222113148.GA3781@2ka.mipt.ru>
	<20070222125931.GB25788@elte.hu>
	<f2b55d220702221324n788506b6oee4f8ed4f168fbf1@mail.gmail.com>
	<20070223003018.0d244576@lxorguk.ukuu.org.uk>
	<f2b55d220702221847p6b28f6eehed1bb5b1b0edf9f4@mail.gmail.com>
X-Mailer: Claws Mail 2.7.2 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Do you not understand that real user code touches FPU state at
> unpredictable (to the kernel) junctures?  Maybe not in a database or a

We don't care. We don't have to care. The kernel threadlets don't execute
in user space and don't do FP. 

> web server, but in the GUIs and web-based monitoring applications that
> are 99% of the potential customers for kernel AIO?  I have no idea
> what a %cr3 is, but if you don't fence off thread-local stuff from the

How about you go read the intel architecture manuals then you might know
more.

> > We don't have an errno in the kernel because its a stupid idea. Errno is
> > a user space hack for compatibility with 1970's bad design. So its not
> > relevant either.
> 
> Dude, it's thread-local, and the glibc wrapper around most synchronous

Last time I checked glibc was in userspace and the interface for kernel
AIO is a matter for the kernel so errno is irrelevant, plus any
threadlets doing system calls will only be living in kernel space anyway.

