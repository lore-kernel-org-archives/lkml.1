Return-Path: <linux-kernel-owner+w=401wt.eu-S1763112AbXKNA2Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763112AbXKNA2Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 19:28:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760075AbXKNA2Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 19:28:16 -0500
Received: from smtp109.mail.mud.yahoo.com ([209.191.85.219]:30702 "HELO
	smtp109.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755374AbXKNA2P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 19:28:15 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=4CcKLJicJP32ydTAbnW5t8tSYBye3vkaiSgsjMtU6BKdXVb7iR+OvZf0vymw0eBod5iupSdQnj61NwvKhpLnFgJJIrTJ/HYvn+z5U6gZ3JhuYsRfX9ci+HpJmtD8QX74o0FfLwfp3FBOv+1i7s8z0km6RN7Z9iEz9dn6XNVT+/o=  ;
X-YMail-OSG: r7uyKK4VM1nu4bDz8twj0TarjgCsFpe7asi8H6MATTGQGLdstpBt.ZqFyriyLdaaBmfhHzApBg--
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: David Brownell <david-b@pacbell.net>
Subject: Re: [patch 2.6.24-rc2 1/3] generic gpio -- gpio_chip support
Date: Tue, 13 Nov 2007 23:25:53 +1100
User-Agent: KMail/1.9.5
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Florian Fainelli <florian.fainelli@telecomint.eu>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>
References: <200711091136.20051.david-b@pacbell.net> <20071113093414.GA5270@elte.hu> <200711131122.45950.david-b@pacbell.net>
In-Reply-To: <200711131122.45950.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711132325.53846.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 14 November 2007 06:22, David Brownell wrote:
> On Tuesday 13 November 2007, Ingo Molnar wrote:
> > * David Brownell <david-b@pacbell.net> wrote:
> > > > > I speculate that either the design has changed (without fanfare),
> > > > > or else that stuff is in RT kernels and has not yet gone upstream.
> > > >
> > > > Well whatever.  We shouldn't have to resort to caller-side party
> > > > tricks like this to get acceptable performance.
> > >
> > > I'd be happy if, as originally presented, it were possible to just
> > > pass a raw_spinlock_t to spin_lock_irqsave() and friends.
> >
> > that's a spinlock type abstraction of PREEMPT_RT, not of mainline.

Even when you're talking about the -rt tree, I suspect you really
shouldn't be using raw spinlocks, right? I mean, if you have a
timing critical operation, then you should ensure you have priorities
set correctly so that you simply don't get preempted.

By using a raw_spinlock_t, you're saying that you're more important
than anyone else (for the period of the critical section) including
processes which the user has explicitly set to a higher priority.

If you get preempted, then you should be happy, because <standard
RTOS nuclear power plant scenario> didn't occur.


> Any reason that stuff shouldn't move into mainline?

This sort of raw_spinlock_t arms race throughout drivers/ would be
a huge reason not to move it into mainline.
