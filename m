Return-Path: <linux-kernel-owner+w=401wt.eu-S1767677AbXCJAcL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767677AbXCJAcL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 19:32:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767685AbXCJAcL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 19:32:11 -0500
Received: from mail20.syd.optusnet.com.au ([211.29.132.201]:34915 "EHLO
	mail20.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1767677AbXCJAcK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 19:32:10 -0500
From: Con Kolivas <kernel@kolivas.org>
To: Matt Mackall <mpm@selenic.com>
Subject: Re: 2.6.21-rc3-mm1 RSDL results
Date: Sat, 10 Mar 2007 11:31:45 +1100
User-Agent: KMail/1.9.5
Cc: linux-kernel <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org
References: <20070309053931.GA10459@waste.org> <200703101002.37920.kernel@kolivas.org> <20070309230612.GL10394@waste.org>
In-Reply-To: <20070309230612.GL10394@waste.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703101131.46148.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 10 March 2007 10:06, Matt Mackall wrote:
> On Sat, Mar 10, 2007 at 10:02:37AM +1100, Con Kolivas wrote:
> > On Saturday 10 March 2007 09:29, Matt Mackall wrote:
> > > On Sat, Mar 10, 2007 at 09:18:05AM +1100, Con Kolivas wrote:
> > > > On Saturday 10 March 2007 08:57, Con Kolivas wrote:
> > > > > On Saturday 10 March 2007 08:39, Matt Mackall wrote:
> > > > > > So what's different between makes in parallel and make -j 5?
> > > > > > Make's job server uses pipe I/O to control how many jobs are
> > > > > > running.
> > > > >
> > > > > Hmm it must be those deep pipes again then. I removed any quirks
> > > > > testing for those from mainline as I suspected it would be ok.
> > > > > Guess I"m wrong.
> > > >
> > > > I shouldn't blame this straight up though if NO_HZ makes it better.
> > > > Something else is going wrong... wtf though?
> > >
> > > Just so we're clear, dynticks has only 'fixed' the single non-parallel
> > > make load so far.
> >
> > Ok, back to the pipe idea. Without needing a kernel recompile, can you
> > try running the make -j5 as a SCHED_BATCH task?
>
> Seems the same.
>
> Oddly, nice make -j 5 is better than batch (but not quite up to stock).

Shouldn't be odd. SCHED_BATCH (as Ingo implemented it which is what I'm trying 
to reproduce for RSDL) is meant to give the same cpu as the same nice level, 
but not give low latency. Nice on the other hand will give much less cpu.

-- 
-ck
