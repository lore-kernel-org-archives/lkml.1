Return-Path: <linux-kernel-owner+w=401wt.eu-S1751613AbYLEDvJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751613AbYLEDvJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 22:51:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752635AbYLEDux
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 22:50:53 -0500
Received: from ivent.com.au ([125.7.48.1]:44855 "EHLO picard.ivent.com.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750805AbYLEDuw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 22:50:52 -0500
Subject: Re: New Security Features, Please Comment
From: Geoffrey McRae <geoff@rabidhost.com>
To: Valdis.Kletnieks@vt.edu
Cc: Peter Teoh <htmldeveloper@gmail.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Nick Andrew <nick@nick-andrew.net>, linux-kernel@vger.kernel.org
In-Reply-To: <95180.1228448127@turing-police.cc.vt.edu>
References: <1228260494.24232.21.camel@compy.ivent.com.au>
	 <20081203005338.6472db7a@lxorguk.ukuu.org.uk>
	 <1228268657.6679.4.camel@lappy.spacevs.com>
	 <20081203124252.GD11807@mail.local.tull.net>
	 <1228344292.6993.27.camel@lappy.spacevs.com>
	 <20081203230820.4473a162@lxorguk.ukuu.org.uk>
	 <804dabb00812031527k3fae11dcnef3b1696c3d136f8@mail.gmail.com>
	 <1228347656.6993.31.camel@lappy.spacevs.com>
	 <80413.1228427770@turing-police.cc.vt.edu>
	 <1228429854.7546.6.camel@lappy.spacevs.com>
	 <95180.1228448127@turing-police.cc.vt.edu>
Content-Type: text/plain
Date: Fri, 05 Dec 2008 14:50:40 +1100
Message-Id: <1228449040.14193.14.camel@lappy.spacevs.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - picard.ivent.com.au
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - rabidhost.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Thus providing me with a way to DoS your webserver by sticking all your
> server processes into a sleep-forever... :)

Yeah, I realise that, its not the problem I am trying to solve though.

> 
> You're also overlooking the fact that the malicious code could do something
> like this:
> 
> 	/* send the parent something that makes it *think* the request finished */
> 	printf("We're all done now\n");
> 	while (getpid()) msleep (1);
> 

Hmm, your right, there has to be a way to overcome all these issues
without having the fork overhead.

I have been toying with an alternate solution of allowing the parent
process to chroot & re-chroot it's children, but even that has the same
problem.

A hack to stop that would be to make getuid... etc, fudge their values
by always returning a constant value to the child, but it is an ugly way
to do this and would involve making stat lie about the ownership of
files too, and anything else that could be used to determine the real
uid or gid.

It seems that solving this issue is alot more complex then I first
envisioned.

Anyone else have any ideas of a fast, efficient and secure way to
accomplish this?

