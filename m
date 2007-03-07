Return-Path: <linux-kernel-owner+w=401wt.eu-S2992635AbXCGWKv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992635AbXCGWKv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 17:10:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992478AbXCGWKu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 17:10:50 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:42767 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992476AbXCGWKt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 17:10:49 -0500
X-AuthUser: davidel@xmailserver.org
Date: Wed, 7 Mar 2007 14:10:47 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Ulrich Drepper <drepper@gmail.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 1/4] signalfd v1 - signalfd core ...
In-Reply-To: <a36005b50703071401m2b166832rb06f4cf73224f45e@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0703071406100.12756@alien.or.mcafeemobile.com>
References: <Pine.LNX.4.64.0703061639370.3661@alien.or.mcafeemobile.com> 
 <Pine.LNX.4.64.0703062301590.10398@alien.or.mcafeemobile.com> 
 <20070307233833.f1482f86.sfr@canb.auug.org.au> 
 <Pine.LNX.4.64.0703070854280.5963@woody.linux-foundation.org> 
 <Pine.LNX.4.64.0703070943180.12283@alien.or.mcafeemobile.com> 
 <45EF20F7.1050307@goop.org>  <Pine.LNX.4.64.0703071241590.12756@alien.or.mcafeemobile.com>
  <45EF2DFF.4060209@goop.org>  <Pine.LNX.4.64.0703071329080.12756@alien.or.mcafeemobile.com>
  <Pine.LNX.4.64.0703071347380.5963@woody.linux-foundation.org>
 <a36005b50703071401m2b166832rb06f4cf73224f45e@mail.gmail.com>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Mar 2007, Ulrich Drepper wrote:

> On 3/7/07, Linus Torvalds <torvalds@linux-foundation.org> wrote:
> > > 1) You want standard delivery only:
> > >
> > >    - Just dont use signalfd
> > >
> > > 2) you want signalfd only:
> > >
> > >    - Do a sigprocmask(SIG_BLOCK) of the same mask you pass to signalfd
> > >
> > > If you want both, you can have it. Race free.
> > 
> > .. but maybe with more code and lots of confusion. I'm still unclear on
> > any upsides here.
> > 
> > Choice is good, but only if it's *useful* choice.
> 
> Not only that.  If you don't force that the signal is blocked when
> using signalfd() you are bound to run into problems.  For the same
> reason is it required to have signals blocked when you use sigwait()
> etc.  Don't try to innovate here, I guarantee you it's going to break
> something somewhere.

Let's do this. How about you throw this way one of the case that would 
possibly break, and I test it?
Queues are separeted, so if you have a signal hitting you while in 
signalfd_dequeue, either the signal is not for your set (and you'd get an 
EINTR ATM), or it is for your set too, and signalfd_dequeue will return 
with it.
But again, I'd love to have some insides about possible breakages so that 
I can make test cases for them.



- Davide


