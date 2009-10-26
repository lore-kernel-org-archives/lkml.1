Return-Path: <linux-kernel-owner+w=401wt.eu-S1754752AbZJZFr6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754752AbZJZFr6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 01:47:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754715AbZJZFr5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 01:47:57 -0400
Received: from mail.gmx.net ([213.165.64.20]:43309 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754714AbZJZFr4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 01:47:56 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+SX3xUes6Sz3r5JH38d4FMmxkqPcdS8Yc7NHCAN5
	F+w/VrdD0qsXUX
Subject: Re: [PATCH 3/3] sched: Disable affine wakeups by default
From: Mike Galbraith <efault@gmx.de>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Peter Zijlstra <peterz@infradead.org>, mingo@elte.hu,
       linux-kernel@vger.kernel.org
In-Reply-To: <20091025223657.5ebc2857@infradead.org>
References: <20091024125853.35143117@infradead.org>
	 <20091024130432.0c46ef27@infradead.org>
	 <20091024130728.051c4d7c@infradead.org>
	 <1256453725.12138.40.camel@marge.simson.net>
	 <20091025095109.449bac9e@infradead.org>
	 <1256492289.14241.40.camel@marge.simson.net>
	 <20091025123319.2b76bf69@infradead.org>
	 <1256508287.17306.14.camel@marge.simson.net>
	 <1256522035.7356.19.camel@laptop>
	 <1256531907.7117.31.camel@marge.simson.net>
	 <20091025215225.05ac9ac9@infradead.org>
	 <1256533734.7117.45.camel@marge.simson.net>
	 <20091025223657.5ebc2857@infradead.org>
Content-Type: text/plain
Date: Mon, 26 Oct 2009 06:47:58 +0100
Message-Id: <1256536078.7117.67.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.5600000000000001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-10-25 at 22:36 -0700, Arjan van de Ven wrote:
> On Mon, 26 Oct 2009 06:08:54 +0100
> Mike Galbraith <efault@gmx.de> wrote:

> > > 
> > > or we just use SD_WAKE_AFFINE / SD_BALANCE_WAKE for this...
> > 
> > I don't see how.  Oh, you mean another domain level, top level being
> > cache property, and turn off when degenerating?  That looks like it'd
> > be a problem, but adding SD_CACHE_SIBLING or whatnot should work.
> > Problem is how to gain knowledge of whether multicores share a cache
> > or not.
> 
> Actually I meant setting the SD_BALANCE_WAKE flag for the SMT and MC
> domains (and then making sure that "MC" really means "shares LLC" in
> the arch code), and then using this as indication in the sched code..

I don't think we can do that, because SD_WAKE_BALANCE already has a
different meaning.  SD_WAKE_AFFINE could be used though, affine wakeups
have always been a cache thing, and for trying to keep things affine to
a package or whatnot, we have SD_PREFER_LOCAL.  Sounds clean to me.

> if you're a multicore domain you better have a shared cache.. that's
> what it should mean. If it does not we should fix that.

Sounds reasonable to me.  I'll go make explosions.

	-Mike

