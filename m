Return-Path: <linux-kernel-owner+w=401wt.eu-S933235AbXBXAGj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933235AbXBXAGj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 19:06:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933238AbXBXAGi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 19:06:38 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:43216 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S933235AbXBXAGh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 19:06:37 -0500
Date: Sat, 24 Feb 2007 01:08:24 +0000
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
Message-ID: <20070224010824.5cf6c0ac@lxorguk.ukuu.org.uk>
In-Reply-To: <f2b55d220702231549g47a648e3xd4c9d4a730f0c4ea@mail.gmail.com>
References: <20070221211355.GA7302@elte.hu>
	<20070221233111.GB5895@elte.hu>
	<45DCD9E5.2010106@redhat.com>
	<20070222074044.GA4158@elte.hu>
	<20070222113148.GA3781@2ka.mipt.ru>
	<20070222125931.GB25788@elte.hu>
	<f2b55d220702221324n788506b6oee4f8ed4f168fbf1@mail.gmail.com>
	<20070223003018.0d244576@lxorguk.ukuu.org.uk>
	<f2b55d220702221847p6b28f6eehed1bb5b1b0edf9f4@mail.gmail.com>
	<20070223123718.54c9670e@lxorguk.ukuu.org.uk>
	<f2b55d220702231549g47a648e3xd4c9d4a730f0c4ea@mail.gmail.com>
X-Mailer: Claws Mail 2.7.2 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> long my_threadlet_fn(void *data)
> {
>        char *name = data;
>        int fd;
> 
>        fd = open(name, O_RDONLY);
>        if (fd < 0)
>                goto out;
> 
>        fstat(fd, &stat);
>        read(fd, buf, count)
>        ...
> 
> out:
>        return threadlet_complete();
> }
> 
> You're telling me that runs entirely in kernel space when open()
> blocks, and doesn't touch errno if fstat() fails?  Now who hasn't read
> the code?

That example touches back into user space, but doesnt involve MMU changes
or cache flushes, or tlb flushes, or floating point.

errno is thread specific if you use it but errno is as I said before
entirely a C library detail that you don't have to suffer if you don't
want to. Avoiding that saves a segment register load - which isn't too
costly but isn't free.

Alan
