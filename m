Return-Path: <linux-kernel-owner+w=401wt.eu-S932396AbXBWOTZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932396AbXBWOTZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 09:19:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932398AbXBWOTZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 09:19:25 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:56026 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932396AbXBWOTY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 09:19:24 -0500
Date: Fri, 23 Feb 2007 19:53:01 +0530
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
Message-ID: <20070223142301.GA20292@in.ibm.com>
Reply-To: suparna@in.ibm.com
References: <20070221211355.GA7302@elte.hu> <f2b55d220702211446l78af6f14hc3e0dd0084016770@mail.gmail.com> <20070221233111.GB5895@elte.hu> <45DCD9E5.2010106@redhat.com> <20070222074044.GA4158@elte.hu> <20070222113148.GA3781@2ka.mipt.ru> <20070222125931.GB25788@elte.hu> <20070222141726.GA31874@in.ibm.com> <20070222143657.GB3246@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070222143657.GB3246@elte.hu>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 22, 2007 at 03:36:58PM +0100, Ingo Molnar wrote:
> 
> * Suparna Bhattacharya <suparna@in.ibm.com> wrote:
> 
> > > maybe it will, maybe it wont. Lets try? There is no true difference 
> > > between having a 'request structure' that represents the current 
> > > state of the HTTP connection plus a statemachine that moves that 
> > > request between various queues, and a 'kernel stack' that goes in 
> > > and out of runnable state and carries its processing state in its 
> > > stack - other than the amount of RAM they take. (the kernel stack is 
> > > 4K at a minimum - so with a million outstanding requests they would 
> > > use up 4 GB of RAM. With 20k outstanding requests it's 80 MB of RAM 
> > > - that's acceptable.)
> > 
> > At what point are the cachemiss threads destroyed ? In other words how 
> > well does this adapt to load variations ? For example, would this 80MB 
> > of RAM continue to be locked down even during periods of lighter loads 
> > thereafter ?
> 
> you can destroy them at will from user-space too - just start a slow 
> timer that zaps them if load goes down. I can add a 
> sys_async_thread_exit(nr_threads) API to be able to drive this without 
> knowing the TIDs of those threads, and/or i can add a kernel-internal 
> mechanism to zap inactive threads. It would be rather easy and 
> low-overhead - the v2 code already had a max_nr_threads tunable, i can 
> reintroduce it. So the size of the pool of contexts does not have to be 
> permanent at all.

If you can find a way to do this without additional tunables burden on
the administrator that would certainly help ! IIRC, performance problems
linked to having too many or too few AIO kernel threads has been a commonly
reported issue elsewhere - it would be nice to be able to avoid repeating
the crux of that (mistake) in Linux. To me, any need to manually tune the
number has always seemed to defeat the very benefit of adaptability of varying
loads that AIO intrinsically provides. 

Regards
Suparna

> 
> 	Ingo

-- 
Suparna Bhattacharya (suparna@in.ibm.com)
Linux Technology Center
IBM Software Lab, India

