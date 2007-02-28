Return-Path: <linux-kernel-owner+w=401wt.eu-S1751734AbXB1P3I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751734AbXB1P3I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 10:29:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751738AbXB1P3H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 10:29:07 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:4677 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751729AbXB1P3G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 10:29:06 -0500
X-AuthUser: davidel@xmailserver.org
Date: Wed, 28 Feb 2007 07:29:03 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Eric Dumazet <dada1@cosmosbay.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch] epoll reduced (to 1) number of passes over the ready
 set ...
In-Reply-To: <200702281213.59695.dada1@cosmosbay.com>
Message-ID: <Pine.LNX.4.64.0702280727590.5935@alien.or.mcafeemobile.com>
References: <Pine.LNX.4.64.0702261819250.4949@alien.or.mcafeemobile.com>
 <200702271015.33123.dada1@cosmosbay.com> <Pine.LNX.4.64.0702270802140.5315@alien.or.mcafeemobile.com>
 <200702281213.59695.dada1@cosmosbay.com>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Feb 2007, Eric Dumazet wrote:

> On Tuesday 27 February 2007 17:03, Davide Libenzi wrote:
> > On Tue, 27 Feb 2007, Eric Dumazet wrote:
> > > On Tuesday 27 February 2007 03:32, Davide Libenzi wrote:
> > > > Epoll is doing multiple passes over the ready set at the moment,
> > > > because of the constraints over the f_op->poll() call. Looking at the
> > > > code again, I noticed that we already hold the epoll semaphore in read,
> > > > and this (together with other locking conditions that hold while doing
> > > > an epoll_wait()) can lead to a smarter way to "ship" events to
> > > > userspace (in a single pass). I added more (even) more comments to the
> > > > code to explain the conditions why certain operations are safe.
> > > > This is a stress application that can be used to test the new code. It
> > > > spwans multiple thread and call epoll_wait() and epoll_ctl() from many
> > > > threads. Stress tested on my dual Opteron 254 w/out any problems.
> > >
> > > Davide,
> > >
> > > This is really cool, because the size of epitem would fit now in 128
> > > bytes instead of 192 (on x86_64 platforms). So we also reduce memory
> > > usage.
> >
> > Yeah, I forgot to mention that I removed the txlink member.
> 
> I am pretty sure you can also remove revents member from epitem.
> 
> It would greatly benefit to 32bits platforms, because resulting size would be 
> 64 bytes instead of 68 (so a 50 % reduction because of 64 bytes alignment)

Yes indee. That does not need to exist anymore, once the de-coupled loop 
is gone. Thx, I'll make a new patch later today.


- Davide


