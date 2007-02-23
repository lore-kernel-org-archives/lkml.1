Return-Path: <linux-kernel-owner+w=401wt.eu-S1752044AbXBVX2T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752044AbXBVX2T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 18:28:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752038AbXBVX2S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 18:28:18 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:35154 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752044AbXBVX2S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 18:28:18 -0500
Date: Fri, 23 Feb 2007 00:30:18 +0000
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
Message-ID: <20070223003018.0d244576@lxorguk.ukuu.org.uk>
In-Reply-To: <f2b55d220702221324n788506b6oee4f8ed4f168fbf1@mail.gmail.com>
References: <20070221211355.GA7302@elte.hu>
	<f2b55d220702211446l78af6f14hc3e0dd0084016770@mail.gmail.com>
	<20070221233111.GB5895@elte.hu>
	<45DCD9E5.2010106@redhat.com>
	<20070222074044.GA4158@elte.hu>
	<20070222113148.GA3781@2ka.mipt.ru>
	<20070222125931.GB25788@elte.hu>
	<f2b55d220702221324n788506b6oee4f8ed4f168fbf1@mail.gmail.com>
X-Mailer: Claws Mail 2.7.2 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> to do anything but chase pointers through cache.  Done right, it
> hardly even branches (although the branch misprediction penalty is a
> lot less of a worry on current x86_64 than it was in the
> mega-superscalar-out-of-order-speculative-execution days).  It's damn

Actually it costs a lot more on at least one vendors processor because
you stall very long pipelines.

> threadlets promise that they will not touch anything thread-local, and
> that when the FPU is handed to them in a specific, known state, they
> leave it in that same state.  (Some of the flags can be

We don't use the FPU in the kernel except in very weird cases where it
makes an enormous performance difference. The threadlets also have the
same page tables so they have the same %cr3 so its very cheap to switch,
basically a predicted jump and some register loads

> Do me a favor.  Do some floating point math and a memcpy() in between
> syscalls in the threadlet.  Actually fiddle with errno and the FPU

We don't have an errno in the kernel because its a stupid idea. Errno is
a user space hack for compatibility with 1970's bad design. So its not
relevant either.

Alan
