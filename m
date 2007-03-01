Return-Path: <linux-kernel-owner+w=401wt.eu-S933283AbXCANFX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933283AbXCANFX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 08:05:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933286AbXCANFW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 08:05:22 -0500
Received: from relay.2ka.mipt.ru ([194.85.82.65]:54566 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933283AbXCANFV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 08:05:21 -0500
Date: Thu, 1 Mar 2007 16:01:36 +0300
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
Message-ID: <20070301130135.GA20554@2ka.mipt.ru>
References: <20070301092634.GB20171@elf.ucw.cz> <20070301094723.GJ7217@2ka.mipt.ru> <20070301095402.GA14603@elte.hu> <20070301105928.GA15709@2ka.mipt.ru> <20070301110022.GA28260@elte.hu> <20070301111629.GA27381@2ka.mipt.ru> <20070301114137.GB897@elte.hu> <20070301114734.GA3508@elte.hu> <20070301121020.GC20773@2ka.mipt.ru> <20070301124336.GA24464@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <20070301124336.GA24464@elte.hu>
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (2ka.mipt.ru [0.0.0.0]); Thu, 01 Mar 2007 16:02:02 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 01, 2007 at 01:43:36PM +0100, Ingo Molnar (mingo@elte.hu) wrote:
> 
> * Evgeniy Polyakov <johnpol@2ka.mipt.ru> wrote:
> 
> > I separated epoll and kevent servers, since originally kevent server 
> > included additional kevent features, but then new ones were added and 
> > I moved slowly to the similar to epoll case.
> 
> i dont care whether they are separate or not - but you have not replied 
> to the request that there be a handle_web_request() function in /both/ 
> files, which is precisely the same function. I didnt ask you to merge 
> the two files - i only asked for the two web handling functions to be 
> one and the same function.

They are not the same in general - if kevent is ready immediately, there 
will not be its removing from kevent tree, but current kevent server has 
it always not-immediately for lighttpd tests - so functions are the same:
open()
sendfile()
cork_off
close(fd)
close(s)
remove_event_from_the_kernel

with the same parameters.

> 	Ingo

-- 
	Evgeniy Polyakov
