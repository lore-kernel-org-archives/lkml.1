Return-Path: <linux-kernel-owner+w=401wt.eu-S1752572AbZL3RbN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752572AbZL3RbN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 12:31:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752472AbZL3RbM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 12:31:12 -0500
Received: from mail1.radix.net ([207.192.128.31]:47159 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752394AbZL3RbL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 12:31:11 -0500
Subject: Re: [PATCH] [0/6] kfifo fixes/improvements
From: Andy Walls <awalls@radix.net>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Vikram Dhillon <dhillonv10@gmail.com>,
       Stefani Seibold <stefani@seibold.net>, Andi Kleen <andi@firstfloor.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "akpm@osdl.org" <akpm@osdl.org>
In-Reply-To: <20091230020830.GA7049@core.coreip.homeip.net>
References: <20091227233816.GC2399@basil.fritz.box>
	 <1261986136.808.2.camel@wall-e> <20091228145749.GD4994@basil.fritz.box>
	 <1262016510.12656.25.camel@wall-e> <20091228172651.GE4994@basil.fritz.box>
	 <1262030653.15368.37.camel@wall-e> <20091228204003.GH4994@basil.fritz.box>
	 <1262076056.23095.21.camel@wall-e>
	 <64D5262E-28CF-41E8-9425-F8C5DD0A2265@gmail.com>
	 <ea6602020912291718n103694aft78ef15b65081a996@mail.gmail.com>
	 <20091230020830.GA7049@core.coreip.homeip.net>
Content-Type: text/plain
Date: Wed, 30 Dec 2009 12:29:12 -0500
Message-Id: <1262194152.5645.10.camel@palomino.walls.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-12-29 at 18:08 -0800, Dmitry Torokhov wrote:
> A: http://en.wikipedia.org/wiki/Top_post
> Q: Were do I find info about this thing called top-posting?
> A: Because it messes up the order in which people normally read text.
> Q: Why is top-posting such a bad thing?
> 
> On Tue, Dec 29, 2009 at 08:18:50PM -0500, Vikram Dhillon wrote:
> > IMHO you can process elements rather than bytes, which is a good
> > improvement, but then again its my opinion, if others don't like it
> > then we can always change it :D
> 
> Right, I was not arguing against having a record-oriented interface, I
> was questioning the utility of processing several records at a time.
> Kfifo users that I have seen so far were working in a record-at-a-time
> mode.

I have a use case in linux/drivers/media/video/cx23885/cx23888-ir.c
right now.

I have a hardware fifo that can hold up to 8 values, 17 bits each - and
the high bit of the value is a flag indicating if more data is in the
hardware fifo.

The hardware fifo watermark for generating an interrupt is 4 or more
values in the hardware fifo.

I use a kfifo that needs to be protected with a spinlock.

It in much better in the IRQ context to drain the hardware fifo and then
put records in the kfifo all at once (or at least in groups of 8 or less
but usually greater than 1).

Regards,
Andy

> Thanks.


