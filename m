Return-Path: <linux-kernel-owner+w=401wt.eu-S1753509AbYJaX4k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753509AbYJaX4k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 19:56:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752231AbYJaX43
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 19:56:29 -0400
Received: from mail.vyatta.com ([76.74.103.46]:48090 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751410AbYJaX42 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 19:56:28 -0400
Date: Fri, 31 Oct 2008 16:56:20 -0700
From: Stephen Hemminger <shemminger@vyatta.com>
To: David Miller <davem@davemloft.net>
Cc: dada1@cosmosbay.com, zbr@ioremap.net, ilpo.jarvinen@helsinki.fi,
       rjw@sisk.pl, mingo@elte.hu, s0mbre@tservice.net.ru,
       a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, efault@gmx.de, akpm@linux-foundation.org
Subject: Re: [tbench regression fixes]: digging out smelly deadmen.
Message-ID: <20081031165620.7322b0e5@extreme>
In-Reply-To: <20081031.165144.86556444.davem@davemloft.net>
References: <20081031125713.6c6923de@extreme>
	<20081031201016.GA4748@ioremap.net>
	<490B7284.2010003@cosmosbay.com>
	<20081031.165144.86556444.davem@davemloft.net>
Organization: Vyatta
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 31 Oct 2008 16:51:44 -0700 (PDT)
David Miller <davem@davemloft.net> wrote:

> From: Eric Dumazet <dada1@cosmosbay.com>
> Date: Fri, 31 Oct 2008 22:03:00 +0100
> 
> > Evgeniy Polyakov a écrit :
> > > On Fri, Oct 31, 2008 at 12:57:13PM -0700, Stephen Hemminger (shemminger@vyatta.com) wrote:
> > >> Why bother with last_rx at all on loopback.  I have been thinking
> > >> we should figure out a way to get rid of last_rx all together. It only
> > >> seems to be used by bonding, and the bonding driver could do the calculation
> > >> in its receive handling.
> > > Not related to the regression: bug will be just papered out by this
> > > changes. Having bonding on loopback is somewhat strange idea, but still
> > > this kind of changes is an attempt to make a good play in the bad game:
> > > this loopback-only optimization does not fix the problem.
> > 
> > Just to be clear, this change was not meant to be committed.
> > It already was rejected by David some years ago (2005, and 2006)
> > 
> > http://www.mail-archive.com/netdev@vger.kernel.org/msg07382.html
> 
> However, I do like Stephen's suggestion that maybe we can get rid of
> this ->last_rx thing by encapsulating the logic completely in the
> bonding driver.

Since bonding driver doesn't actually see the rx packets, that isn't
really possible.  But it would be possible to change last_rx from a variable
to an function pointer, so that device's could apply other logic to derive
the last value.  One example would be to keep it per cpu and then take the
maximum.
