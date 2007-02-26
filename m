Return-Path: <linux-kernel-owner+w=401wt.eu-S1030487AbXBZTek@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030487AbXBZTek (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 14:34:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030489AbXBZTek
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 14:34:40 -0500
Received: from relay.2ka.mipt.ru ([194.85.82.65]:40956 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030487AbXBZTej (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 14:34:39 -0500
Date: Mon, 26 Feb 2007 22:30:59 +0300
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Ulrich Drepper <drepper@redhat.com>,
       linux-kernel@vger.kernel.org, Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Zach Brown <zach.brown@oracle.com>,
       "David S. Miller" <davem@davemloft.net>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 00/13] Syslets, "Threadlets", generic AIO support, v3
Message-ID: <20070226193054.GB17892@2ka.mipt.ru>
References: <f2b55d220702211446l78af6f14hc3e0dd0084016770@mail.gmail.com> <20070221233111.GB5895@elte.hu> <45DCD9E5.2010106@redhat.com> <20070222074044.GA4158@elte.hu> <20070222113148.GA3781@2ka.mipt.ru> <Pine.LNX.4.64.0702251428490.12485@woody.linux-foundation.org> <20070226172812.GC22454@2ka.mipt.ru> <Pine.LNX.4.64.0702260938450.12485@woody.linux-foundation.org> <20070226183227.GE22454@2ka.mipt.ru> <Pine.LNX.4.64.0702261112020.12485@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0702261112020.12485@woody.linux-foundation.org>
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (2ka.mipt.ru [0.0.0.0]); Mon, 26 Feb 2007 22:32:15 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 26, 2007 at 11:22:46AM -0800, Linus Torvalds (torvalds@linux-foundation.org) wrote:
> See? Stop blathering about how everything is an event. THAT'S NOT 
> RELEVANT. I've told you a hundred times - they may be "logically 
> equivalent", but that doesn't change ANYTHING. Event-based programming 
> simply isn't suitable for 99% of all stuff, and for the 1% where it *is* 
> suitable, it actually tends to be a very specific subset of the code that 
> you actually use events for (ie accept and read/write on pure streams).

Will you argue that people do things like
num = epoll_wait()
for (i=0; i<num; ++i) {
	process(event[i])?
}

Will you spawn thread per IO?

Stop writing the same again and again - I perfectly understand that not
everything can be easily covered by events, but covering everything with
threads is more stupid idea.

High-performance IO requires as small as possible overhead, dispatching
events from ring buffer or queue from each cpu is the smallest one, but
not spawning a thread per read.

> 		Linus

-- 
	Evgeniy Polyakov
