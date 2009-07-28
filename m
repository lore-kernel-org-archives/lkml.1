Return-Path: <linux-kernel-owner+w=401wt.eu-S1755553AbZG1S4r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755553AbZG1S4r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 14:56:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755501AbZG1S4r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 14:56:47 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:55028 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753307AbZG1S4q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 14:56:46 -0400
Date: Tue, 28 Jul 2009 19:56:51 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Ray Lee <ray-lk@madrabbit.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] kdesu broken
Message-ID: <20090728195651.3a402a31@lxorguk.ukuu.org.uk>
In-Reply-To: <alpine.LFD.2.01.0907281141070.3186@localhost.localdomain>
References: <20090725163251.50e6f546@lxorguk.ukuu.org.uk>
	<87bpn7mzli.fsf@devron.myhome.or.jp>
	<20090727115723.1e8de60e@lxorguk.ukuu.org.uk>
	<873a8iqqgv.fsf@devron.myhome.or.jp>
	<20090727142303.41096bf5@lxorguk.ukuu.org.uk>
	<877hxujkuv.fsf@devron.myhome.or.jp>
	<20090727145805.690afe5d@lxorguk.ukuu.org.uk>
	<87fxci6ub9.fsf@devron.myhome.or.jp>
	<20090727161424.GA4233@skywalker>
	<20090727174252.2d987830@lxorguk.ukuu.org.uk>
	<20090727171213.GB4233@skywalker>
	<87skgikjr8.fsf@devron.myhome.or.jp>
	<20090727222010.1a5efb7b@lxorguk.ukuu.org.uk>
	<87r5w19xsb.fsf@devron.myhome.or.jp>
	<20090728112203.7b70adba@lxorguk.ukuu.org.uk>
	<alpine.LFD.2.01.0907280848090.3186@localhost.localdomain>
	<20090728174213.5e927428@lxorguk.ukuu.org.uk>
	<alpine.LFD.2.01.0907280944150.3186@localhost.localdomain>
	<20090728180649.596c5412@lxorguk.ukuu.org.uk>
	<alpine.LFD.2.01.0907281141070.3186@localhost.localdomain>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> My point is that a program _should_ be able to depend on simple causality 
> when it comes to ordering rules. If the child did a write() before 
> exiting, then we should see the data before SIGCHLD.
> 
> It's really that simple.

In which case you need the write to be synchronous to the ldisc
processing. Which is what tty->low_latency = 1 did. That provides your
required causality.

So what exactly is the problem. Setting ->low_latency has a small
performance impact which was why I was trying the other stuff, but that
is all.

As I said tty->low_latency = 1 gives you the previous semantics.

Alan
