Return-Path: <linux-kernel-owner+w=401wt.eu-S1751874AbXB0RKW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751874AbXB0RKW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 12:10:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751692AbXB0RKW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 12:10:22 -0500
Received: from relay.2ka.mipt.ru ([194.85.82.65]:41504 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751874AbXB0RKV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 12:10:21 -0500
Date: Tue, 27 Feb 2007 20:06:10 +0300
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: Eric Dumazet <dada1@cosmosbay.com>
Cc: Davide Libenzi <davidel@xmailserver.org>, Ingo Molnar <mingo@elte.hu>,
       Ulrich Drepper <drepper@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Zach Brown <zach.brown@oracle.com>,
       "David S. Miller" <davem@davemloft.net>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 00/13] Syslets, "Threadlets", generic AIO support, v3
Message-ID: <20070227170609.GA509@2ka.mipt.ru>
References: <20070225180910.GA29821@2ka.mipt.ru> <Pine.LNX.4.64.0702270751120.5315@alien.or.mcafeemobile.com> <20070227162109.GA22844@2ka.mipt.ru> <200702271758.15004.dada1@cosmosbay.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <200702271758.15004.dada1@cosmosbay.com>
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (2ka.mipt.ru [0.0.0.0]); Tue, 27 Feb 2007 20:07:15 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 27, 2007 at 05:58:14PM +0100, Eric Dumazet (dada1@cosmosbay.com) wrote:
> I believe one advantage of epoll is it uses standard mechanism (mandated for 
> poll()/select() ), while kevent adds some glue and kevent_storage in some 
> structures (struct inode, struct file, ...), thus adding some extra code and 
> extra storage in hot paths. Yes there might be a gain IF most users of these 
> path want kevent. But other users pay the price (larger kernel code and 
> data), that you cannot easily bench.
> 
> Using or not epoll has nearly zero cost over standard kernel (only struct file 
> has some extra storage)

Well, that's a price - any event which wants to be supported needs to
store for events - kevent_storage is a list_head plus spinlock and
pointer to itself (with all current users that pointer can be removed and
access transferred to container_of()) - it is exactly as in epoll storage - 
both were created with the smallest possible overhead in mind.

-- 
	Evgeniy Polyakov
