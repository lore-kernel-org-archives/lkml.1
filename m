Return-Path: <linux-kernel-owner+w=401wt.eu-S1755349AbXIDPZq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755349AbXIDPZq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2007 11:25:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754568AbXIDPZi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Sep 2007 11:25:38 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:4358 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754456AbXIDPZh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2007 11:25:37 -0400
X-AuthUser: davidel@xmailserver.org
Date: Tue, 4 Sep 2007 08:25:34 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Michael Kerrisk <mtk-manpages@gmx.net>, rdunlap@xenotime.net,
       tglx@linutronix.de,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ulrich Drepper <drepper@redhat.com>, stable@kernel.org, hch@lst.de,
       jengelh@computergmbh.de, corbet@lwn.net
Subject: Re: [PATCH] Revised timerfd() interface
In-Reply-To: <20070904011800.762523a4.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0709040805490.6887@alien.or.mcafeemobile.com>
References: <20070825064114.107820@gmx.net> <Pine.LNX.4.64.0708300458120.7717@alien.or.mcafeemobile.com>
 <46DD116C.4040301@gmx.net> <20070904011800.762523a4.akpm@linux-foundation.org>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Sep 2007, Andrew Morton wrote:

> > On Tue, 04 Sep 2007 10:03:56 +0200 Michael Kerrisk <mtk-manpages@gmx.net> wrote:
> > Davide,
> > 
> > >> Davide -- ping!  Can you please offer your comments about this change, and
> > >> also thoughts on Jon's and my comments about a more radical API change
> > >> later  in this thread.
> > > 
> > > IMO the complexity of the resulting API (and resulting patch), and the ABI 
> > > change, is not justified by the added value.
> > 
> > Neither of the proposed APIs (either my multiplexed version of timerfd()
> > or Jon's/my idea of using three system calls (like POSIX timers), or
> > the notion of timerfd() integrated with POSIX timers) is more
> > complicated than the existing POSIX timers API.
> > 
> > The ABI change doesn't really matter, since timerfd() was broken in 2.6.22
> > anyway.
> > 
> > Both previous APIs provided the features I have described provide:
> > 
> > * the ability to fetch the old timer value when applying
> >   a new setting
> > 
> > * the ability to non-destructively fetch the amount of time remaining
> >   on a timer.
> > 
> > This is clearly useful for timers -- but you have not explained why
> > you think this is not necessary for timerfd timers.
> 
> <wakes up>
> 
> I'd have thought that the existing stuff would be near-useless without the
> capabilities which you describe?

Useless like it'd be a motorcycle w/out a cup-holder :)
Seriously, the ability to get the previous values from "something" could 
have a meaning if this something is a shared global resource (like signals 
for example). In the timerfd case this makes little sense, since you can 
create as many timerfd as you like and you do not need to share a single 
one by changing/restoring the original context.
On top of that, the cup-holder addition would cost in terms of API clarity 
(or in terms of two additional system calls in the other case), and in 
terms of kernel code footprint. Costs that IMO are not balanced by the 
added values.



- Davide


