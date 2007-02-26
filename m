Return-Path: <linux-kernel-owner+w=401wt.eu-S1030624AbXBZUGS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030624AbXBZUGS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 15:06:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030626AbXBZUGS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 15:06:18 -0500
Received: from smtp.osdl.org ([65.172.181.24]:59972 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030624AbXBZUGR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 15:06:17 -0500
Date: Mon, 26 Feb 2007 12:04:51 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
cc: Ingo Molnar <mingo@elte.hu>, Ulrich Drepper <drepper@redhat.com>,
       linux-kernel@vger.kernel.org, Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Zach Brown <zach.brown@oracle.com>,
       "David S. Miller" <davem@davemloft.net>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 00/13] Syslets, "Threadlets", generic AIO support, v3
In-Reply-To: <20070226193054.GB17892@2ka.mipt.ru>
Message-ID: <Pine.LNX.4.64.0702261159470.12485@woody.linux-foundation.org>
References: <f2b55d220702211446l78af6f14hc3e0dd0084016770@mail.gmail.com>
 <20070221233111.GB5895@elte.hu> <45DCD9E5.2010106@redhat.com>
 <20070222074044.GA4158@elte.hu> <20070222113148.GA3781@2ka.mipt.ru>
 <Pine.LNX.4.64.0702251428490.12485@woody.linux-foundation.org>
 <20070226172812.GC22454@2ka.mipt.ru> <Pine.LNX.4.64.0702260938450.12485@woody.linux-foundation.org>
 <20070226183227.GE22454@2ka.mipt.ru> <Pine.LNX.4.64.0702261112020.12485@woody.linux-foundation.org>
 <20070226193054.GB17892@2ka.mipt.ru>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 26 Feb 2007, Evgeniy Polyakov wrote:
> 
> Will you argue that people do things like
> num = epoll_wait()
> for (i=0; i<num; ++i) {
> 	process(event[i])?
> }

I have several times told you that I argue for a *combination* of 
event-bassed interfaces and thread-like code. And that the choice depends 
on which is more natural. Sometimes you might have just one or the other. 
Sometimes you have both. And sometimes you have neither (although, 
strictly speaking, normal single-threaded code is certainly "thread-like" 
- it's a serial execution, the same way threadlets are serial executions - 
it's just not running in parallel with anything else).

> Will you spawn thread per IO?

Depending on what the IO is, yes. 

Is that _really_ so hard to understand? There is no "yes" or "no". There's 
a "depends on what the problem is, and what the solution looks like".

Sometimes the best way to do parallelism is through explicit threads. 
Sometimes it is through whatever "threadlets" or other that gets out of 
this whole development discussion. Sometimes it's an event loop.

So get over it. The world is not a black and white, either-or kind of 
place. It's full of grayscales, and colors, and mixing things 
appropriately. And the choices are often done on whims and on whatever 
feels most comfortable to the person doing the choice. Not on some strict 
"you must always use things in an event-driven main loop" or "you must 
always use threads for parallelism".

The world is simply _richer_ than that kind of either-or thing.

		Linus
