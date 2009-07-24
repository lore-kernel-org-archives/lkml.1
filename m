Return-Path: <linux-kernel-owner+w=401wt.eu-S1753024AbZGXQfZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753024AbZGXQfZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 12:35:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752469AbZGXQfZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 12:35:25 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44826 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751852AbZGXQfY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 12:35:24 -0400
Date: Fri, 24 Jul 2009 09:34:35 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Ray Lee <ray-lk@madrabbit.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Regression] kdesu broken
In-Reply-To: <20090724164058.21a054e6@lxorguk.ukuu.org.uk>
Message-ID: <alpine.LFD.2.01.0907240930120.3960@localhost.localdomain>
References: <200907240145.31935.rjw@sisk.pl> <2c0942db0907231721q124dc8f9mdbe64ed33c69ffbf@mail.gmail.com> <200907241721.45943.rjw@sisk.pl> <20090724164058.21a054e6@lxorguk.ukuu.org.uk>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 24 Jul 2009, Alan Cox wrote:

> On Fri, 24 Jul 2009 17:21:45 +0200
> "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> 
> > On Friday 24 July 2009, Ray Lee wrote:
> > > On Thu, Jul 23, 2009 at 4:45 PM, Rafael J. Wysocki<rjw@sisk.pl> wrote:
> > > > A recent kernel change broke kdesu (from KDE 4.2) on my test boxes.  ISTR a
> > > > discussion about that, but I can't find it right now.  Any clues?
> > > 
> > > See the thread starting here: ("possible regression with pty.c commit")
> > >    http://lkml.org/lkml/2009/7/11/125
> > 
> > Thanks for the pointer.
> > 
> > Well, I thought we were expected to avoid breaking existing user space, even
> > if that were buggy etc.
> 
> I don't know where you got that idea from. Avoiding breaking user space
> unneccessarily is good but if its buggy you often can't do anything about
> it.

Alan, he got that idea from me.

We don't do regressions. If user space depended on old behavior, we don't 
change behavior.

And regardless of that, I do not think EIO is the right thing to return at 
all. If the other side of a pty went away, return 0 and possibly send a 
HUP, or whatever. What did we do before?

			Linus
