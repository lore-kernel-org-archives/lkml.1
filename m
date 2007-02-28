Return-Path: <linux-kernel-owner+w=401wt.eu-S1751669AbXB1Tm2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751669AbXB1Tm2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 14:42:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751709AbXB1Tm2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 14:42:28 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:4841 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751669AbXB1Tm1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 14:42:27 -0500
X-AuthUser: davidel@xmailserver.org
Date: Wed, 28 Feb 2007 11:42:24 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Chris Friesen <cfriesen@nortel.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Ulrich Drepper <drepper@redhat.com>,
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
In-Reply-To: <45E5D217.9060101@nortel.com>
Message-ID: <Pine.LNX.4.64.0702281134380.6806@alien.or.mcafeemobile.com>
References: <20070221211355.GA7302@elte.hu> <f2b55d220702211446l78af6f14hc3e0dd0084016770@mail.gmail.com>
 <20070221233111.GB5895@elte.hu> <45DCD9E5.2010106@redhat.com>
 <20070222074044.GA4158@elte.hu> <Pine.LNX.4.64.0702221130050.1356@alien.or.mcafeemobile.com>
 <20070228094522.GA17716@elte.hu> <Pine.LNX.4.64.0702280740250.5935@alien.or.mcafeemobile.com>
 <Pine.LNX.4.64.0702280836080.12485@woody.linux-foundation.org>
 <Pine.LNX.4.64.0702281011220.6806@alien.or.mcafeemobile.com>
 <Pine.LNX.4.64.0702281040030.12485@woody.linux-foundation.org>
 <Pine.LNX.4.64.0702281047430.6806@alien.or.mcafeemobile.com>
 <45E5D217.9060101@nortel.com>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Feb 2007, Chris Friesen wrote:

> Davide Libenzi wrote:
> 
> > struct async_syscall {
> > 	unsigned long nr_sysc;
> > 	unsigned long params[8];
> > 	long *result;
> > };
> > 
> > And what would async_wait() return bak? Pointers to "struct async_syscall"
> > or pointers to "result"?
> 
> Either one has downsides.  Pointer to struct async_syscall requires that the
> caller keep the struct around.  Pointer to result requires that the caller
> always reserve a location for the result.
> 
> Does the kernel care about the (possibly rare) case of callers that don't want
> to pay attention to result?  If so, what about adding some kind of
> caller-specified handle to struct async_syscall, and having async_wait()
> return the handle?  In the case where the caller does care about the result,
> the handle could just be the address of result.

Something like this (with async_wait() returning asynid's)?

struct async_syscall {
	long *result;
	unsigned long asynid;
	unsigned long nr_sysc;
	unsigned long params[8];
};



- Davide


