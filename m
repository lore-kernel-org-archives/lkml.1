Return-Path: <linux-kernel-owner+w=401wt.eu-S932117AbXBVONJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932117AbXBVONJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 09:13:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932081AbXBVONJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 09:13:09 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:57882 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933079AbXBVONH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 09:13:07 -0500
Date: Thu, 22 Feb 2007 19:47:26 +0530
From: Suparna Bhattacharya <suparna@in.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       Ulrich Drepper <drepper@redhat.com>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Zach Brown <zach.brown@oracle.com>,
       "David S. Miller" <davem@davemloft.net>,
       Davide Libenzi <davidel@xmailserver.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 00/13] Syslets, "Threadlets", generic AIO support, v3
Message-ID: <20070222141726.GA31874@in.ibm.com>
Reply-To: suparna@in.ibm.com
References: <20070221211355.GA7302@elte.hu> <f2b55d220702211446l78af6f14hc3e0dd0084016770@mail.gmail.com> <20070221233111.GB5895@elte.hu> <45DCD9E5.2010106@redhat.com> <20070222074044.GA4158@elte.hu> <20070222113148.GA3781@2ka.mipt.ru> <20070222125931.GB25788@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070222125931.GB25788@elte.hu>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 22, 2007 at 01:59:31PM +0100, Ingo Molnar wrote:
> 
> * Evgeniy Polyakov <johnpol@2ka.mipt.ru> wrote:
> 
> > It is not a TUX anymore - you had 1024 threads, and all of them will 
> > be consumed by tcp_sendmsg() for slow clients - rescheduling will kill 
> > a machine.
> 
> maybe it will, maybe it wont. Lets try? There is no true difference 
> between having a 'request structure' that represents the current state 
> of the HTTP connection plus a statemachine that moves that request 
> between various queues, and a 'kernel stack' that goes in and out of 
> runnable state and carries its processing state in its stack - other 
> than the amount of RAM they take. (the kernel stack is 4K at a minimum - 
> so with a million outstanding requests they would use up 4 GB of RAM. 
> With 20k outstanding requests it's 80 MB of RAM - that's acceptable.)

At what point are the cachemiss threads destroyed ? In other words how well
does this adapt to load variations ? For example, would this 80MB of RAM 
continue to be locked down even during periods of lighter loads thereafter ?

Regards
Suparna

> 
> > My tests show that with 4k connections per second (8k concurrency) 
> > more than 20k connections of 80k total block in tcp_sendmsg() over 
> > gigabit lan between quite fast machines.
> 
> yeah. Note that you can have a million sleeping threads if you want, the 
> scheduler wont care. What matters more is the amount of true concurrency 
> that is present at any given time. But yes, i agree that overscheduling 
> can be a problem.
> 
> btw., what is the measurement utility you are using with kevents ('ab' 
> perhaps, with a high -c concurrency count?), and which webserver are you 
> using? (light-httpd?)
> 
> 	Ingo

-- 
Suparna Bhattacharya (suparna@in.ibm.com)
Linux Technology Center
IBM Software Lab, India

