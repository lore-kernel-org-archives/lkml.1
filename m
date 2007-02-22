Return-Path: <linux-kernel-owner+w=401wt.eu-S932171AbXBVPFl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932171AbXBVPFl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 10:05:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932167AbXBVPFl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 10:05:41 -0500
Received: from relay.2ka.mipt.ru ([194.85.82.65]:55380 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932171AbXBVPFl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 10:05:41 -0500
Date: Thu, 22 Feb 2007 18:02:41 +0300
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: David Miller <davem@davemloft.net>
Cc: mingo@elte.hu, arjan@infradead.org, drepper@redhat.com,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       hch@infradead.org, akpm@zip.com.au, alan@lxorguk.ukuu.org.uk,
       zach.brown@oracle.com, suparna@in.ibm.com, davidel@xmailserver.org,
       jens.axboe@oracle.com, tglx@linutronix.de
Subject: Re: [patch 00/13] Syslets, "Threadlets", generic AIO support, v3
Message-ID: <20070222150239.GA21945@2ka.mipt.ru>
References: <20070222123929.GA5208@2ka.mipt.ru> <20070222.054127.104035694.davem@davemloft.net> <20070222143145.GA3246@elte.hu> <20070222.064704.71093028.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <20070222.064704.71093028.davem@davemloft.net>
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (2ka.mipt.ru [0.0.0.0]); Thu, 22 Feb 2007 18:03:39 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 22, 2007 at 06:47:04AM -0800, David Miller (davem@davemloft.net) wrote:
> As a side note although Evgeniy likes M:N threading model ideas, they
> are a mine field wrt. signal semantics.  Solaris guys took several
> years to get it right, just grep through the Solaris kernel patch
> readme files over the years to get an idea of how bad it can be.  I
> would therefore never advocate such an approach.

I have fully synchronous kevent signal delivery for that purpose :)
Having all events synchronous allows trivial handling of them -
including signals.

> The more I think about it, a reasonable solution might actually be to
> use threadlets for disk I/O and pure event based processing for
> networking.  It is two different handling paths and non-unified,
> but that might be the price for good performance :-)

Hmm, yes, for such scenario we need some kind of event delivery
mechanism, which would allow to wait on different kinds of events.

In the above sentence I see known to pain letters - 
letter k
letter e
letter v
letter e
letter n
letter t

Or more modern trend - async_wait(epoll).

-- 
	Evgeniy Polyakov
