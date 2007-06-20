Return-Path: <linux-kernel-owner+w=401wt.eu-S1758233AbXFTPy1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758233AbXFTPy1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 11:54:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754317AbXFTPyT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 11:54:19 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:2093 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752155AbXFTPyS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 11:54:18 -0400
X-AuthUser: davidel@xmailserver.org
Date: Wed, 20 Jun 2007 08:54:11 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
cc: Oleg Nesterov <oleg@tv-sign.ru>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Nicholas Miell <nmiell@comcast.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Fix signalfd interaction with thread-private signals
In-Reply-To: <1182311217.22337.17.camel@localhost.localdomain>
Message-ID: <Pine.LNX.4.64.0706200848280.5783@alien.or.mcafeemobile.com>
References: <alpine.LFD.0.98.0706162013420.14121@woody.linux-foundation.org>
  <1182064500.2798.6.camel@entropy>  <Pine.LNX.4.64.0706170951580.20841@alien.or.mcafeemobile.com>
  <1182108399.3794.4.camel@entropy>  <Pine.LNX.4.64.0706171436260.20841@alien.or.mcafeemobile.com>
  <1182125303.3794.8.camel@entropy>  <Pine.LNX.4.64.0706171715320.5316@alien.or.mcafeemobile.com>
  <1182127391.26853.207.camel@localhost.localdomain> 
 <alpine.LFD.0.98.0706181011460.14121@woody.linux-foundation.org> 
 <20070619091452.GA94@tv-sign.ru>  <Pine.LNX.4.64.0706191643400.16740@alien.or.mcafeemobile.com>
  <1182302739.22337.9.camel@localhost.localdomain> 
 <Pine.LNX.4.64.0706191908000.16740@alien.or.mcafeemobile.com>
 <1182311217.22337.17.camel@localhost.localdomain>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Jun 2007, Benjamin Herrenschmidt wrote:

> On Tue, 2007-06-19 at 19:15 -0700, Davide Libenzi wrote:
> 
> > Ok, why instead don't we go for something like the attached patch?
> > We exclude sync signals from signalfd, but we don't limit signalfd to 
> > shared signals. Ie, we should be able to fetch a signal sent with 
> > sys_tkill() to threads different from "current", that otherwise we would 
> > not be able to fetch.
> > Ben, sorry but my memory sucks ... the "notifier" thing was fine in that 
> > case, no?
> 
> I'm generally nervous about the idea of letting signalfd dequeue
> somebody else private signals... even if we filter out SEGV's and
> friends but I'll let Linus decide there.
> 
> Regarding the notifier, it's dodgy in most cases I'd say but I suppose
> it should be allright to only worry about "current" and not the target
> task there.

I believe that once we exclude synchronous signals from being dequeued, we 
should be fine. Limiting all signals sent with sys_tkill() from being 
dequeued with a signalfd is a too restricting behaviour IMO.


- Davide

