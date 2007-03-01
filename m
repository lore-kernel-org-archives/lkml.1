Return-Path: <linux-kernel-owner+w=401wt.eu-S965301AbXCAPtS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965301AbXCAPtS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 10:49:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965303AbXCAPtS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 10:49:18 -0500
Received: from relay.2ka.mipt.ru ([194.85.82.65]:59732 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965301AbXCAPtQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 10:49:16 -0500
Date: Thu, 1 Mar 2007 18:47:08 +0300
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: Eric Dumazet <dada1@cosmosbay.com>
Cc: Ingo Molnar <mingo@elte.hu>, Pavel Machek <pavel@ucw.cz>,
       Theodore Tso <tytso@mit.edu>,
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
Message-ID: <20070301154707.GC8217@2ka.mipt.ru>
References: <Pine.LNX.4.64.0702260938450.12485@woody.linux-foundation.org> <20070301144717.GA24079@elte.hu> <20070301152323.GA8217@2ka.mipt.ru> <200703011632.37756.dada1@cosmosbay.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <200703011632.37756.dada1@cosmosbay.com>
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (2ka.mipt.ru [0.0.0.0]); Thu, 01 Mar 2007 18:47:32 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 01, 2007 at 04:32:37PM +0100, Eric Dumazet (dada1@cosmosbay.com) wrote:
> On Thursday 01 March 2007 16:23, Evgeniy Polyakov wrote:
> > They are there, since ab runs only 50k requests.
> > If I change it to something noticebly more than 50/80k, ab crashes:
> > # ab -c8000 -t 600 -n800000000 http://192.168.0.48/
> > This is ApacheBench, Version 2.0.40-dev <$Revision: 1.146 $> apache-2.0
> > Copyright 1996 Adam Twiss, Zeus Technology Ltd, http://www.zeustech.net/
> > Copyright 2006 The Apache Software Foundation, http://www.apache.org/
> >
> > Benchmarking 192.168.0.48 (be patient)
> > Segmentation fault
> >
> > Are there any other tool suitable for such loads?
> > I only tested httperf (which is worse, since it uses poll/select) and
> > 'ab'.
> >
> > Btw, host machine runs 100% too, so it is possible that client side is
> > broken (too).
> 
> I have similar problems here, ab test just doesnt complete...
> 
> I am still investigating with strace and tcpdump.
> 
> In the meantime you could just rewrite it (based on epoll please :) ), since 
> it should be quite easy to do this (reverse of evserver_epoll)

Rewriting 'ab' with pure epoll instead of APR lib is like
dandruff treatment on a guillotine.

I will try to cook up something own - simple client (based on epoll)
tomorrow/weekend, now I need to work for money :)

-- 
	Evgeniy Polyakov
