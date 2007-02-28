Return-Path: <linux-kernel-owner+w=401wt.eu-S1752138AbXB1LOK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752138AbXB1LOK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 06:14:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752143AbXB1LOK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 06:14:10 -0500
Received: from pfx2.jmh.fr ([194.153.89.55]:40118 "EHLO pfx2.jmh.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752138AbXB1LOJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 06:14:09 -0500
From: Eric Dumazet <dada1@cosmosbay.com>
To: Davide Libenzi <davidel@xmailserver.org>
Subject: Re: [patch] epoll reduced (to 1) number of passes over the ready set ...
Date: Wed, 28 Feb 2007 12:13:59 +0100
User-Agent: KMail/1.9.5
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
References: <Pine.LNX.4.64.0702261819250.4949@alien.or.mcafeemobile.com> <200702271015.33123.dada1@cosmosbay.com> <Pine.LNX.4.64.0702270802140.5315@alien.or.mcafeemobile.com>
In-Reply-To: <Pine.LNX.4.64.0702270802140.5315@alien.or.mcafeemobile.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702281213.59695.dada1@cosmosbay.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 27 February 2007 17:03, Davide Libenzi wrote:
> On Tue, 27 Feb 2007, Eric Dumazet wrote:
> > On Tuesday 27 February 2007 03:32, Davide Libenzi wrote:
> > > Epoll is doing multiple passes over the ready set at the moment,
> > > because of the constraints over the f_op->poll() call. Looking at the
> > > code again, I noticed that we already hold the epoll semaphore in read,
> > > and this (together with other locking conditions that hold while doing
> > > an epoll_wait()) can lead to a smarter way to "ship" events to
> > > userspace (in a single pass). I added more (even) more comments to the
> > > code to explain the conditions why certain operations are safe.
> > > This is a stress application that can be used to test the new code. It
> > > spwans multiple thread and call epoll_wait() and epoll_ctl() from many
> > > threads. Stress tested on my dual Opteron 254 w/out any problems.
> >
> > Davide,
> >
> > This is really cool, because the size of epitem would fit now in 128
> > bytes instead of 192 (on x86_64 platforms). So we also reduce memory
> > usage.
>
> Yeah, I forgot to mention that I removed the txlink member.

I am pretty sure you can also remove revents member from epitem.

It would greatly benefit to 32bits platforms, because resulting size would be 
64 bytes instead of 68 (so a 50 % reduction because of 64 bytes alignment)

Eric
