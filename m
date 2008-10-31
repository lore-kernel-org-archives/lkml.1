Return-Path: <linux-kernel-owner+w=401wt.eu-S1753419AbYJaXwX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753419AbYJaXwX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 19:52:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751410AbYJaXwL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 19:52:11 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:52779
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750965AbYJaXwK convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 19:52:10 -0400
Date: Fri, 31 Oct 2008 16:51:44 -0700 (PDT)
Message-Id: <20081031.165144.86556444.davem@davemloft.net>
To: dada1@cosmosbay.com
Cc: zbr@ioremap.net, shemminger@vyatta.com, ilpo.jarvinen@helsinki.fi,
       rjw@sisk.pl, mingo@elte.hu, s0mbre@tservice.net.ru,
       a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, efault@gmx.de, akpm@linux-foundation.org
Subject: Re: [tbench regression fixes]: digging out smelly deadmen.
From: David Miller <davem@davemloft.net>
In-Reply-To: <490B7284.2010003@cosmosbay.com>
References: <20081031125713.6c6923de@extreme>
	<20081031201016.GA4748@ioremap.net>
	<490B7284.2010003@cosmosbay.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <dada1@cosmosbay.com>
Date: Fri, 31 Oct 2008 22:03:00 +0100

> Evgeniy Polyakov a écrit :
> > On Fri, Oct 31, 2008 at 12:57:13PM -0700, Stephen Hemminger (shemminger@vyatta.com) wrote:
> >> Why bother with last_rx at all on loopback.  I have been thinking
> >> we should figure out a way to get rid of last_rx all together. It only
> >> seems to be used by bonding, and the bonding driver could do the calculation
> >> in its receive handling.
> > Not related to the regression: bug will be just papered out by this
> > changes. Having bonding on loopback is somewhat strange idea, but still
> > this kind of changes is an attempt to make a good play in the bad game:
> > this loopback-only optimization does not fix the problem.
> 
> Just to be clear, this change was not meant to be committed.
> It already was rejected by David some years ago (2005, and 2006)
> 
> http://www.mail-archive.com/netdev@vger.kernel.org/msg07382.html

However, I do like Stephen's suggestion that maybe we can get rid of
this ->last_rx thing by encapsulating the logic completely in the
bonding driver.

> If you read my mail, I was *only* saying that tbench results can be sensible to
> cache line ping pongs. tbench is a crazy benchmark, and only is a crazy benchmark.
> 
> Optimizing linux for tbench sake would be .... crazy ?

Unlike dbench I think tbench is worth cranking up as much as possible.

It doesn't have a huge memory working set, it just writes mostly small
messages over a TCP socket back and forth, and does a lot of blocking

And I think we'd like all of those operating to run as fast as possible.

When Tridge first wrote tbench I would see the expected things at the
top of the profiles.  Things like tcp_ack(), copy to/from user, and
perhaps SLAB.

Things have changed considerably.

