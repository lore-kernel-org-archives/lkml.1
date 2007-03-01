Return-Path: <linux-kernel-owner+w=401wt.eu-S965280AbXCAPcq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965280AbXCAPcq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 10:32:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965285AbXCAPcq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 10:32:46 -0500
Received: from pfx2.jmh.fr ([194.153.89.55]:58118 "EHLO pfx2.jmh.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965280AbXCAPcp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 10:32:45 -0500
From: Eric Dumazet <dada1@cosmosbay.com>
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: Re: [patch 00/13] Syslets, "Threadlets", generic AIO support, v3
Date: Thu, 1 Mar 2007 16:32:37 +0100
User-Agent: KMail/1.9.5
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
References: <Pine.LNX.4.64.0702260938450.12485@woody.linux-foundation.org> <20070301144717.GA24079@elte.hu> <20070301152323.GA8217@2ka.mipt.ru>
In-Reply-To: <20070301152323.GA8217@2ka.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703011632.37756.dada1@cosmosbay.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 01 March 2007 16:23, Evgeniy Polyakov wrote:
> They are there, since ab runs only 50k requests.
> If I change it to something noticebly more than 50/80k, ab crashes:
> # ab -c8000 -t 600 -n800000000 http://192.168.0.48/
> This is ApacheBench, Version 2.0.40-dev <$Revision: 1.146 $> apache-2.0
> Copyright 1996 Adam Twiss, Zeus Technology Ltd, http://www.zeustech.net/
> Copyright 2006 The Apache Software Foundation, http://www.apache.org/
>
> Benchmarking 192.168.0.48 (be patient)
> Segmentation fault
>
> Are there any other tool suitable for such loads?
> I only tested httperf (which is worse, since it uses poll/select) and
> 'ab'.
>
> Btw, host machine runs 100% too, so it is possible that client side is
> broken (too).

I have similar problems here, ab test just doesnt complete...

I am still investigating with strace and tcpdump.

In the meantime you could just rewrite it (based on epoll please :) ), since 
it should be quite easy to do this (reverse of evserver_epoll)

