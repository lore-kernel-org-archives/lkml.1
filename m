Return-Path: <linux-kernel-owner+w=401wt.eu-S932255AbXB1SpL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932255AbXB1SpL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 13:45:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932264AbXB1SpL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 13:45:11 -0500
Received: from smtp.osdl.org ([65.172.181.24]:38758 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932255AbXB1SpJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 13:45:09 -0500
Date: Wed, 28 Feb 2007 10:42:49 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Davide Libenzi <davidel@xmailserver.org>
cc: Ingo Molnar <mingo@elte.hu>, Ulrich Drepper <drepper@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Zach Brown <zach.brown@oracle.com>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       "David S. Miller" <davem@davemloft.net>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 00/13] Syslets, "Threadlets", generic AIO support, v3
In-Reply-To: <Pine.LNX.4.64.0702281011220.6806@alien.or.mcafeemobile.com>
Message-ID: <Pine.LNX.4.64.0702281040030.12485@woody.linux-foundation.org>
References: <20070221211355.GA7302@elte.hu> <f2b55d220702211446l78af6f14hc3e0dd0084016770@mail.gmail.com>
 <20070221233111.GB5895@elte.hu> <45DCD9E5.2010106@redhat.com>
 <20070222074044.GA4158@elte.hu> <Pine.LNX.4.64.0702221130050.1356@alien.or.mcafeemobile.com>
 <20070228094522.GA17716@elte.hu> <Pine.LNX.4.64.0702280740250.5935@alien.or.mcafeemobile.com>
 <Pine.LNX.4.64.0702280836080.12485@woody.linux-foundation.org>
 <Pine.LNX.4.64.0702281011220.6806@alien.or.mcafeemobile.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 28 Feb 2007, Davide Libenzi wrote:
> 
> Here we very much agree. The way I'd like it:
> 
> struct async_syscall {
> 	unsigned long nr_sysc;
> 	unsigned long params[8];
> 	long result;
> };

No, the "result" needs to go somewhere else. The caller may be totally 
uninterested in keeping the system call number or parameters around until 
the operation completes, but if you put them in the same structure with 
the result, you obviously cannot sanely get rid of them.

I also don't much like read-write interfaces (which the above would be: 
the kernel would read most of the structure, and then write one member of 
the structure). 

It's entirely possible, for example, that the operation we submit is some 
legacy "aio_read()", which has soem other structure layout than the new 
one (but one field will be the result code).

		Linus
