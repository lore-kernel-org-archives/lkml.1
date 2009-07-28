Return-Path: <linux-kernel-owner+w=401wt.eu-S1755483AbZG1SqN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755483AbZG1SqN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 14:46:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755402AbZG1SqM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 14:46:12 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48711 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755395AbZG1SqM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 14:46:12 -0400
Date: Tue, 28 Jul 2009 11:45:42 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Ray Lee <ray-lk@madrabbit.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] kdesu broken
In-Reply-To: <20090728180900.54b2f0b7@lxorguk.ukuu.org.uk>
Message-ID: <alpine.LFD.2.01.0907281144170.3186@localhost.localdomain>
References: <20090725163251.50e6f546@lxorguk.ukuu.org.uk> <87bpn7mzli.fsf@devron.myhome.or.jp> <20090727115723.1e8de60e@lxorguk.ukuu.org.uk> <873a8iqqgv.fsf@devron.myhome.or.jp> <20090727142303.41096bf5@lxorguk.ukuu.org.uk> <877hxujkuv.fsf@devron.myhome.or.jp>
 <20090727145805.690afe5d@lxorguk.ukuu.org.uk> <87fxci6ub9.fsf@devron.myhome.or.jp> <20090727161424.GA4233@skywalker> <20090727174252.2d987830@lxorguk.ukuu.org.uk> <20090727171213.GB4233@skywalker> <87skgikjr8.fsf@devron.myhome.or.jp>
 <20090727222010.1a5efb7b@lxorguk.ukuu.org.uk> <87r5w19xsb.fsf@devron.myhome.or.jp> <20090728112203.7b70adba@lxorguk.ukuu.org.uk> <alpine.LFD.2.01.0907280848090.3186@localhost.localdomain> <20090728174213.5e927428@lxorguk.ukuu.org.uk>
 <alpine.LFD.2.01.0907280944150.3186@localhost.localdomain> <alpine.LFD.2.01.0907280949250.3186@localhost.localdomain> <20090728180900.54b2f0b7@lxorguk.ukuu.org.uk>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 28 Jul 2009, Alan Cox wrote:

> > Put another way: our pty code is simply _buggy_ if it returns EINTR when 
> > there is actually data pending on a pty.
> 
> Good job it doesn't do that then - although be careful what "data
> pending" means. If the buffer contains "wombat" and you are in ICANON
> mode then there is no data pending, and poll() likewise will say there is
> no data pending. Only when newline is hit do you have data pending (which
> is why test t3 is buggy)

Alan, that's a total red herring. We're not talking t3. We're talking 
emacs, and the newline is there.

You claim that emacs sh*ts itself when it gets EAGAIN, and you think 
that's an emacs bug. And I think you're full of crap. We should NEVER EVER 
get EAGAIN (due to the SIGCHLD, at least) if the app on the other side 
wrote data that could be read.

			Linus
