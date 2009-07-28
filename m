Return-Path: <linux-kernel-owner+w=401wt.eu-S1752110AbZG1QxW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752110AbZG1QxW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 12:53:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751242AbZG1QxV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 12:53:21 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33032 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750743AbZG1QxV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 12:53:21 -0400
Date: Tue, 28 Jul 2009 09:52:38 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Ray Lee <ray-lk@madrabbit.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] kdesu broken
In-Reply-To: <alpine.LFD.2.01.0907280944150.3186@localhost.localdomain>
Message-ID: <alpine.LFD.2.01.0907280949250.3186@localhost.localdomain>
References: <20090725163251.50e6f546@lxorguk.ukuu.org.uk> <87bpn7mzli.fsf@devron.myhome.or.jp> <20090727115723.1e8de60e@lxorguk.ukuu.org.uk> <873a8iqqgv.fsf@devron.myhome.or.jp> <20090727142303.41096bf5@lxorguk.ukuu.org.uk> <877hxujkuv.fsf@devron.myhome.or.jp>
 <20090727145805.690afe5d@lxorguk.ukuu.org.uk> <87fxci6ub9.fsf@devron.myhome.or.jp> <20090727161424.GA4233@skywalker> <20090727174252.2d987830@lxorguk.ukuu.org.uk> <20090727171213.GB4233@skywalker> <87skgikjr8.fsf@devron.myhome.or.jp>
 <20090727222010.1a5efb7b@lxorguk.ukuu.org.uk> <87r5w19xsb.fsf@devron.myhome.or.jp> <20090728112203.7b70adba@lxorguk.ukuu.org.uk> <alpine.LFD.2.01.0907280848090.3186@localhost.localdomain> <20090728174213.5e927428@lxorguk.ukuu.org.uk>
 <alpine.LFD.2.01.0907280944150.3186@localhost.localdomain>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 28 Jul 2009, Linus Torvalds wrote:
> 
> The correct expectation is that the select() (or read()) should have 
> returned any data that it saw _before_ it returns EINTR.

Put another way: our pty code is simply _buggy_ if it returns EINTR when 
there is actually data pending on a pty.

Yes, it's "buggy" only in a QoI sense - I'm sure that if you read POSIX 
and SuS like a language lawyer, there is absolutely zero that says that it 
can't return EINTR at any random time, or that the SIGCHLD should be 
ordered wrt the other side of the pty having done a write.

But we don't do language-lawyering based on standards that inevitably 
never really delve into all the nitty-gritty details. We are simply better 
than that. Leave the language-lawyering to the people who can't do things 
well, and then whine about their crap being "technically correct".

			Linus
