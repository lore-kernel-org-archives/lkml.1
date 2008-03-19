Return-Path: <linux-kernel-owner+w=401wt.eu-S1761555AbYCST6f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761555AbYCST6f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 15:58:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756931AbYCSThx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 15:37:53 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43244 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754728AbYCSTht (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 15:37:49 -0400
Date: Tue, 18 Mar 2008 19:43:26 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: john stultz <johnstul@us.ibm.com>
Cc: lkml <linux-kernel@vger.kernel.org>, Roman Zippel <zippel@linux-m68k.org>
Subject: Re: [PATCH 2/2] Introduce CLOCK_MONOTONIC_RAW
Message-Id: <20080318194326.9b20ae7d.akpm@linux-foundation.org>
In-Reply-To: <1205878420.28128.117.camel@localhost>
References: <1205878279.28128.114.camel@localhost>
	<1205878420.28128.117.camel@localhost>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Mar 2008 15:13:40 -0700 john stultz <johnstul@us.ibm.com> wrote:

> Here's my CLOCK_MONOTONIC_RAW, including some suggested changes from
> Roman.
> 
> Andrew, if there are not major objections, could you add it to your
> 2.6.26 pending list?
> 
> thanks
> -john
> 
> 
> In talking with Josip Loncaric, and his work on clock synchronization
> (see btime.sf.net), he mentioned that for really close synchronization,
> it is useful to have access to "hardware time", that is a notion of time
> that is not in any way adjusted by the clock slewing done to keep close
> time sync.
> 
> Part of the issue is if we are using the kernel's ntp adjusted
> representation of time in order to measure how we should correct time,
> we can run into what Paul McKenney aptly described as "Painting a road
> using the lines we're painting as the guide". 
> 
> I had been thinking of a similar problem, and was trying to come up with
> a way to give users access to a purely hardware based time
> representation that avoided users having to know the underlying
> frequency and mask values needed to deal with the wide variety of
> possible underlying hardware counters.
> 
> My solution is to introduce CLOCK_MONOTONIC_RAW. This exposes a
> nanosecond based time value, that increments starting at bootup and has
> no frequency adjustments made to it what so ever.
> 
> The time is accessed from userspace via the posix_clock_gettime()
> syscall, passing CLOCK_MONOTONIC_RAW as the clock_id.
> 
> This patch depends on the mult_orig patch, just sent a moment ago.

alpha:

kernel/built-in.o: In function `posix_get_monotonic_raw':
: undefined reference to `getrawmonotonic'
kernel/built-in.o: In function `posix_get_monotonic_raw':
: undefined reference to `getrawmonotonic'

presumably busted for all CONFIG_GENERIC_TIME=n architectures.

Couldn't see a quick fix so I dropped it.
