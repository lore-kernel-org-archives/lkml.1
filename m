Return-Path: <linux-kernel-owner+w=401wt.eu-S933114AbXCAIj4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933114AbXCAIj4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 03:39:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933108AbXCAIjz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 03:39:55 -0500
Received: from relay.2ka.mipt.ru ([194.85.82.65]:42472 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933114AbXCAIjy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 03:39:54 -0500
Date: Thu, 1 Mar 2007 11:38:06 +0300
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Chris Friesen <cfriesen@nortel.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Ulrich Drepper <drepper@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Zach Brown <zach.brown@oracle.com>,
       "David S. Miller" <davem@davemloft.net>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 00/13] Syslets, "Threadlets", generic AIO support, v3
Message-ID: <20070301083806.GF7217@2ka.mipt.ru>
References: <20070222074044.GA4158@elte.hu> <Pine.LNX.4.64.0702221130050.1356@alien.or.mcafeemobile.com> <20070228094522.GA17716@elte.hu> <Pine.LNX.4.64.0702280740250.5935@alien.or.mcafeemobile.com> <Pine.LNX.4.64.0702280836080.12485@woody.linux-foundation.org> <Pine.LNX.4.64.0702281011220.6806@alien.or.mcafeemobile.com> <Pine.LNX.4.64.0702281040030.12485@woody.linux-foundation.org> <Pine.LNX.4.64.0702281047430.6806@alien.or.mcafeemobile.com> <45E5D217.9060101@nortel.com> <Pine.LNX.4.64.0702281134380.6806@alien.or.mcafeemobile.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0702281134380.6806@alien.or.mcafeemobile.com>
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (2ka.mipt.ru [0.0.0.0]); Thu, 01 Mar 2007 11:38:50 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 28, 2007 at 11:42:24AM -0800, Davide Libenzi (davidel@xmailserver.org) wrote:
> On Wed, 28 Feb 2007, Chris Friesen wrote:
> 
> > Davide Libenzi wrote:
> > 
> > > struct async_syscall {
> > > 	unsigned long nr_sysc;
> > > 	unsigned long params[8];
> > > 	long *result;
> > > };
> > > 
> > > And what would async_wait() return bak? Pointers to "struct async_syscall"
> > > or pointers to "result"?
> > 
> > Either one has downsides.  Pointer to struct async_syscall requires that the
> > caller keep the struct around.  Pointer to result requires that the caller
> > always reserve a location for the result.
> > 
> > Does the kernel care about the (possibly rare) case of callers that don't want
> > to pay attention to result?  If so, what about adding some kind of
> > caller-specified handle to struct async_syscall, and having async_wait()
> > return the handle?  In the case where the caller does care about the result,
> > the handle could just be the address of result.
> 
> Something like this (with async_wait() returning asynid's)?
> 
> struct async_syscall {
> 	long *result;
> 	unsigned long asynid;
> 	unsigned long nr_sysc;
> 	unsigned long params[8];
> };

Having result pointer as NULL might imply that result is not interested
in and thus it can be discarded and event async syscall will not be
returned through aync_wait().
More flexible is having request flags field in the structure.
 
> - Davide
> 

-- 
	Evgeniy Polyakov
