Return-Path: <linux-kernel-owner+w=401wt.eu-S1030319AbXDZJyD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030319AbXDZJyD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 05:54:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030323AbXDZJyB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 05:54:01 -0400
Received: from amsfep17-int.chello.nl ([62.179.120.12]:23635 "EHLO
	amsfep17-int.chello.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030319AbXDZJyB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 05:54:01 -0400
Subject: Re: recomended way to check longest period that interupts are
	disabled ?
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Mike Mattie <codermattie@gmail.com>
Cc: lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <20070426021350.29ddfa0a@reforged>
References: <20070426021350.29ddfa0a@reforged>
Content-Type: text/plain
Date: Thu, 26 Apr 2007 11:53:57 +0200
Message-Id: <1177581237.26937.105.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-04-26 at 02:13 -0700, Mike Mattie wrote:
> Hello,
> 
> I am still struggling to track down problems with audio playback. I get intermittent:
> 
> Apr 26 02:01:40 reforged [13230.947879] cannot submit sync urb (err = -45)
> 
> I have tackled the scheduler issues to where I really don't think the
> driver is being starved at all. I am running audacious like so:
> 
> schedtool -R -p 50 -n 1 -e audacious
> 
> At this point the strongest correlation I can get is that starting
> programs seems to trigger the stutter. I have suspected IO for
> some time.
> 
> My system image , / & /usr are on a libata (VIA PATA) driver.
> I have disabled the write-cache , but I also have noatime set
> on mount, for /usr
> 
> My big suspicion is that one of my drivers, likely IO is
> disabling interrupts for too long.
> 
> I have looked but not found a tool for measuring the longest
> period interrupts are disabled and pointing the finger at
> the culprit, could anyone on this list recommend tools that
> might help me pinpoint what is going on ?
> 
> I would also be delighted for any sort of recommended latency
> testing tools.
> 
> pin-pointing this is going to be a "learning experience" but
> every time I think I am about to have a bonding moment with 
> the kernel audio skips; I am highly motivated.

The -rt kernel contains a full latency tracer.

http://people.redhat.com/mingo/realtime-preempt/

Some hardware just isn't up to the job though...

