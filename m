Return-Path: <linux-kernel-owner+w=401wt.eu-S1759575AbXEYIX0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759575AbXEYIX0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 04:23:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760490AbXEYIXD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 04:23:03 -0400
Received: from one.firstfloor.org ([213.235.205.2]:50745 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760535AbXEYIXA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 04:23:00 -0400
Date: Fri, 25 May 2007 10:22:59 +0200
From: Andi Kleen <andi@firstfloor.org>
To: William Lee Irwin III <wli@holomorphy.com>
Cc: Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
       Satyam Sharma <satyam.sharma@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [patch] i386, numaq: enable TSCs again
Message-ID: <20070525082259.GH8094@one.firstfloor.org>
References: <20070525071005.GA6431@elte.hu> <a781481a0705250022t3dec8f13u7c75d0ade40b0010@mail.gmail.com> <20070525073158.GB8094@one.firstfloor.org> <20070525073957.GA15207@elte.hu> <20070525074316.GA16821@elte.hu> <20070525074915.GA18400@elte.hu> <20070525075446.GA20140@elte.hu> <20070525080827.GA22399@elte.hu> <20070525081944.GZ31925@holomorphy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070525081944.GZ31925@holomorphy.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 25, 2007 at 01:19:44AM -0700, William Lee Irwin III wrote:
> On Fri, May 25, 2007 at 10:08:27AM +0200, Ingo Molnar wrote:
> > Andi, Andrew, do you remember why we disabled TSCs on NUMAQ? It was 
> > slightly async between CPUs, right? In that case we should try the patch 
> > below.
> 
> I remember. It was far beyond "slightly async;" they would drift
> minutes apart during reasonable amounts of uptime, though it would take
> at least several days to drift so far (I don't recall how long it took).

sched_clock should handle that.

> TSC synchronization is uniformly impossible on NUMA-Q. Bootlogs showing
> the results of the attempts are still extant. They shouldn't end up too
> far apart right after booting, but I don't have even ballpark estimates.
> I'd hazard a guess of a few seconds.

You should mark_tsc_instable(), but not tsc disable. In a release or two
hopefully even that will be obsolete.

-Andi
