Return-Path: <linux-kernel-owner+w=401wt.eu-S1946007AbXBVMl5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946007AbXBVMl5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 07:41:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946010AbXBVMl5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 07:41:57 -0500
Received: from relay.2ka.mipt.ru ([194.85.82.65]:55848 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946007AbXBVMl4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 07:41:56 -0500
Date: Thu, 22 Feb 2007 15:39:30 +0300
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Ulrich Drepper <drepper@redhat.com>,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Zach Brown <zach.brown@oracle.com>,
       "David S. Miller" <davem@davemloft.net>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 00/13] Syslets, "Threadlets", generic AIO support, v3
Message-ID: <20070222123929.GA5208@2ka.mipt.ru>
References: <20070221211355.GA7302@elte.hu> <f2b55d220702211446l78af6f14hc3e0dd0084016770@mail.gmail.com> <20070221233111.GB5895@elte.hu> <45DCD9E5.2010106@redhat.com> <20070222074044.GA4158@elte.hu> <20070222113148.GA3781@2ka.mipt.ru> <1172145159.3531.253.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <1172145159.3531.253.camel@laptopd505.fenrus.org>
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (2ka.mipt.ru [0.0.0.0]); Thu, 22 Feb 2007 15:41:06 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 22, 2007 at 12:52:39PM +0100, Arjan van de Ven (arjan@infradead.org) wrote:
> 
> > It is not a TUX anymore - you had 1024 threads, and all of them will be
> > consumed by tcp_sendmsg() for slow clients - rescheduling will kill a
> > machine.
> 
> I think it's time to make a split in what "context switch" or
> "reschedule" means...
> 
> there are two types of context switch:
> 
> 1) To a different process. This means teardown of the TLB, going to a
> new MMU state, saving FPU state etc etc etc. This is obviously quite
> expensive
> 
> 2) To a thread of the same process. No TLB flush no new MMU state,
> effectively all it does is getting a new task struct on the kernel side,
> and a new ESP/EIP pair on the userspace side. If there is FPU code
> involved that gets saved as well.
> 
> Number 1 is very expensive and that is what is really worrying normally;
> number 2 is a LOT lighter weight, and while Linux is a bit heavy there,
> it can be made lighter... there's no fundamental reason for it to be
> really expensive.

It does not matter - even with threads cost of having thousands of
threads is _too_ expensive. So, IMO, it is wrong to have to create 
20k threads for the simple web server which only sends one index page to
80k connections with 4k connections per seconds rate.

Just have that example in mind - more than 20k blocks in 80k connections 
over gigabit lan, and it is likely optimistic result, when designing new 
type of AIO.

> -- 
> if you want to mail me at work (you don't), use arjan (at) linux.intel.com
> Test the interaction between Linux and your BIOS via http://www.linuxfirmwarekit.org

-- 
	Evgeniy Polyakov
