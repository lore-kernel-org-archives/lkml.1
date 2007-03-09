Return-Path: <linux-kernel-owner+w=401wt.eu-S933404AbXCIVwi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933404AbXCIVwi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 16:52:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993149AbXCIVwi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 16:52:38 -0500
Received: from waste.org ([66.93.16.53]:39017 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933408AbXCIVwh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 16:52:37 -0500
Date: Fri, 9 Mar 2007 15:39:59 -0600
From: Matt Mackall <mpm@selenic.com>
To: Con Kolivas <kernel@kolivas.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org
Subject: Re: 2.6.21-rc3-mm1 RSDL results
Message-ID: <20070309213959.GI10394@waste.org>
References: <20070309053931.GA10459@waste.org> <20070309204623.GE10394@waste.org> <200703100807.43582.kernel@kolivas.org> <200703100819.18354.kernel@kolivas.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200703100819.18354.kernel@kolivas.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 10, 2007 at 08:19:18AM +1100, Con Kolivas wrote:
> On Saturday 10 March 2007 08:07, Con Kolivas wrote:
> > On Saturday 10 March 2007 07:46, Matt Mackall wrote:
> > > My suspicion is the problem lies in giving too much quanta to
> > > newly-started processes.
> >
> > Ah that's some nice detective work there. Mainline does some rather complex
> > accounting on sched_fork including (possibly) a whole timer tick which rsdl
> > does not do. make forks off continuously so what you say may well be
> > correct. I'll see if I can try to revert to the mainline behaviour in
> > sched_fork (which was obviously there for a reason).
> 
> Wow! Thanks Matt. You've found a real bug too. This seems to fix the qemu
>  misbehaviour and bitmap errors so far too! Now can you please try this to see
>  if it fixes your problem?

Sorry, it's about the same. I now suspect an accounting glitch involving
pipe wake-ups.

5x memload: good
5x execload: good
5x forkload: good
5 parallel makes: mostly good
make -j 5: bad

So what's different between makes in parallel and make -j 5? Make's
job server uses pipe I/O to control how many jobs are running.

-- 
Mathematics is the supreme nostalgia of our time.
