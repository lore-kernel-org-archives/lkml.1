Return-Path: <linux-kernel-owner+w=401wt.eu-S1755439AbZG1Soc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755439AbZG1Soc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 14:44:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755390AbZG1Sob
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 14:44:31 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45536 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755364AbZG1Sob (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 14:44:31 -0400
Date: Tue, 28 Jul 2009 11:44:00 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Ray Lee <ray-lk@madrabbit.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] kdesu broken
In-Reply-To: <20090728180649.596c5412@lxorguk.ukuu.org.uk>
Message-ID: <alpine.LFD.2.01.0907281141070.3186@localhost.localdomain>
References: <20090725163251.50e6f546@lxorguk.ukuu.org.uk> <87bpn7mzli.fsf@devron.myhome.or.jp> <20090727115723.1e8de60e@lxorguk.ukuu.org.uk> <873a8iqqgv.fsf@devron.myhome.or.jp> <20090727142303.41096bf5@lxorguk.ukuu.org.uk> <877hxujkuv.fsf@devron.myhome.or.jp>
 <20090727145805.690afe5d@lxorguk.ukuu.org.uk> <87fxci6ub9.fsf@devron.myhome.or.jp> <20090727161424.GA4233@skywalker> <20090727174252.2d987830@lxorguk.ukuu.org.uk> <20090727171213.GB4233@skywalker> <87skgikjr8.fsf@devron.myhome.or.jp>
 <20090727222010.1a5efb7b@lxorguk.ukuu.org.uk> <87r5w19xsb.fsf@devron.myhome.or.jp> <20090728112203.7b70adba@lxorguk.ukuu.org.uk> <alpine.LFD.2.01.0907280848090.3186@localhost.localdomain> <20090728174213.5e927428@lxorguk.ukuu.org.uk>
 <alpine.LFD.2.01.0907280944150.3186@localhost.localdomain> <20090728180649.596c5412@lxorguk.ukuu.org.uk>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 28 Jul 2009, Alan Cox wrote:
> 
> If you are asking that question I don't think you understand the bug
> report.

I don't think YOU understand what I'm saying.

> > The correct expectation is that the select() (or read()) should have 
> > returned any data that it saw _before_ it returns EINTR.
> 
> read() handles that correctly, has always done so.
> 
> emacs from the traces does this
> 
> 	set O_NDELAY
> 	wait for SIGCLD
> 	read()
> 		EAGAIN
> 		shit_myself();

Go back and read my email.

Emacs is ENTIRELY PROPER in doing that. If it has gotten the SIGCHLD, then 
it damn well should know that the data is buffered already, since the 
child sure as hell isn't writing any more. So if it gets EAGAIN due to the 
SIGCHLD, it can assume that there isn't going to be any more data.

My point is that a program _should_ be able to depend on simple causality 
when it comes to ordering rules. If the child did a write() before 
exiting, then we should see the data before SIGCHLD.

It's really that simple.

		Linus
