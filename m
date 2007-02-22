Return-Path: <linux-kernel-owner+w=401wt.eu-S1945976AbXBVLhF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945976AbXBVLhF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 06:37:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945975AbXBVLhF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 06:37:05 -0500
Received: from relay.2ka.mipt.ru ([194.85.82.65]:33729 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1945976AbXBVLhD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 06:37:03 -0500
Date: Thu, 22 Feb 2007 14:31:50 +0300
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: Ingo Molnar <mingo@elte.hu>
Cc: Ulrich Drepper <drepper@redhat.com>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Zach Brown <zach.brown@oracle.com>,
       "David S. Miller" <davem@davemloft.net>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 00/13] Syslets, "Threadlets", generic AIO support, v3
Message-ID: <20070222113148.GA3781@2ka.mipt.ru>
References: <20070221211355.GA7302@elte.hu> <f2b55d220702211446l78af6f14hc3e0dd0084016770@mail.gmail.com> <20070221233111.GB5895@elte.hu> <45DCD9E5.2010106@redhat.com> <20070222074044.GA4158@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <20070222074044.GA4158@elte.hu>
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (2ka.mipt.ru [0.0.0.0]); Thu, 22 Feb 2007 14:33:11 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo, developers.

On Thu, Feb 22, 2007 at 08:40:44AM +0100, Ingo Molnar (mingo@elte.hu) wrote:
> Syslets/threadlets on the other hand, once the core is implemented, have 
> near zero ongoing maintainance cost (compared to KAIO pushed into every 
> IO subsystem) and cover all IO disciplines and API variants immediately, 
> and they are as perfectly asynchronous as it gets.
> 
> So all in one, i used to think that AIO state-machines have a long-term 
> place within the kernel, but with syslets i think i've proven myself 
> embarrasingly wrong =B-)

Hmm...
Try to have a network web server with huge load made on top of
syslets/threadlets.

It is not a TUX anymore - you had 1024 threads, and all of them will be
consumed by tcp_sendmsg() for slow clients - rescheduling will kill a
machine.

My tests show that with 4k connections per second (8k concurrency) more
than 20k connections of 80k total block in tcp_sendmsg() over gigabit
lan between quite fast machines.

Or threadlet/syslet AIO should not be used with networking too?

> 	Ingo

-- 
	Evgeniy Polyakov
