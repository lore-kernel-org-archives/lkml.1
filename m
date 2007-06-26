Return-Path: <linux-kernel-owner+w=401wt.eu-S1758552AbXFZPnm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758552AbXFZPnm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 11:43:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757489AbXFZPnd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 11:43:33 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56653 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755903AbXFZPnc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 11:43:32 -0400
Date: Tue, 26 Jun 2007 17:43:05 +0200
From: Andrea Arcangeli <andrea@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Roman Zippel <zippel@linux-m68k.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, John Stultz <johnstul@us.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch, v2.6.22-rc6] sys_time() speedup
Message-ID: <20070626154305.GE7059@v2.random>
References: <20070625200601.GA18980@elte.hu> <200706252309.47467.zippel@linux-m68k.org> <20070625151508.86fa3778.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070625151508.86fa3778.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 25, 2007 at 03:15:08PM -0700, Andrew Morton wrote:
> Interesting question.  The patch adds a new test-n-branch to gettimeofday()
> so if gettimeofday() is used much more frequently than time(), we lose.

I think gettimeofday is generally used much more frequently than
time. Real db calls gettimeofday not time, infact some real db related
app even go as far as calling rdtsc directly (on hardware where the
tsc is synchronized). What's the point of calling time so many times
per second when it'll always return the same value anyway?

I think this is a case of the simulator not simulating the real
workload and hence that should be fixed instead of optimizing for the
erratic simulator.

Just place a systemtap for time and gettimeofday, run a real db or a
videogame and then show the number of time vs gettimeofday calls.
