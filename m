Return-Path: <linux-kernel-owner+w=401wt.eu-S933338AbXCBLJu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933338AbXCBLJu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 06:09:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933339AbXCBLJu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 06:09:50 -0500
Received: from relay.2ka.mipt.ru ([194.85.82.65]:37280 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423027AbXCBLJs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 06:09:48 -0500
Date: Fri, 2 Mar 2007 14:08:21 +0300
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: Ingo Molnar <mingo@elte.hu>
Cc: Pavel Machek <pavel@ucw.cz>, Theodore Tso <tytso@mit.edu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ulrich Drepper <drepper@redhat.com>, linux-kernel@vger.kernel.org,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Zach Brown <zach.brown@oracle.com>,
       "David S. Miller" <davem@davemloft.net>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 00/13] Syslets, "Threadlets", generic AIO support, v3
Message-ID: <20070302110820.GA25908@2ka.mipt.ru>
References: <20070227121116.GA31597@2ka.mipt.ru> <20070228161413.GA4319@ucw.cz> <20070301081808.GD7217@2ka.mipt.ru> <20070301092634.GB20171@elf.ucw.cz> <20070301094723.GJ7217@2ka.mipt.ru> <20070301101102.GE20171@elf.ucw.cz> <20070301111815.GB15709@2ka.mipt.ru> <20070302102714.GB27687@elf.ucw.cz> <20070302103713.GB28444@2ka.mipt.ru> <20070302105618.GA18377@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <20070302105618.GA18377@elte.hu>
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (2ka.mipt.ru [0.0.0.0]); Fri, 02 Mar 2007 14:08:55 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 02, 2007 at 11:56:18AM +0100, Ingo Molnar (mingo@elte.hu) wrote:
> 
> * Evgeniy Polyakov <johnpol@2ka.mipt.ru> wrote:
> 
> > Even if kevent has the same speed, it still allows to handle _any_ 
> > kind of events without any major surgery - a very tiny structure of 
> > lock and list head and you can process your own kernel event in 
> > userspace with timers, signals, io events, private userspace events 
> > and others without races and invention of differnet hacks for 
> > different types - _this_ is main point.
> 
> did it ever occur to you to ... extend epoll? To speed it up? To add a 
> new wait syscall to it? Instead of introducing a whole new parallel 
> framework?

Yes, I thought about its extension more than a year ago before started 
kevent, but epoll() is absolutely based on file structure and its 
file_operations with poll methodt, so it is quite impossible to work 
with sockets to implement network AIO. Eventually it had gathered a lot 
of other systems - do we really want to have per process signalfs, timerfs 
and so on - each simple structure must be bound to a file, which becomes 
too cost.

> 	Ingo

-- 
	Evgeniy Polyakov
