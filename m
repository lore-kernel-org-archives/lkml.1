Return-Path: <linux-kernel-owner+w=401wt.eu-S1753210AbYJYHwV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753210AbYJYHwV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2008 03:52:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752315AbYJYHwJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Oct 2008 03:52:09 -0400
Received: from mail.gmx.net ([213.165.64.20]:35756 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752299AbYJYHwI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2008 03:52:08 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19vBFgXU8Fv+EVAV/QEYZmly1U3wzYgOasC5pErAi
	z6oj+VtGF1vUqL
Subject: Re: [tbench regression fixes]: digging out smelly deadmen.
From: Mike Galbraith <efault@gmx.de>
To: David Miller <davem@davemloft.net>
Cc: rjw@sisk.pl, mingo@elte.hu, s0mbre@tservice.net.ru, a.p.zijlstra@chello.nl,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
In-Reply-To: <20081025.002420.82739316.davem@davemloft.net>
References: <20081024.221653.23695396.davem@davemloft.net>
	 <1224914333.3822.18.camel@marge.simson.net>
	 <1224917623.4929.15.camel@marge.simson.net>
	 <20081025.002420.82739316.davem@davemloft.net>
Content-Type: text/plain
Date: Sat, 25 Oct 2008 09:52:02 +0200
Message-Id: <1224921122.5373.24.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.54
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-10-25 at 00:24 -0700, David Miller wrote:
> From: Mike Galbraith <efault@gmx.de>
> Date: Sat, 25 Oct 2008 08:53:43 +0200
> 
> > On Sat, 2008-10-25 at 07:58 +0200, Mike Galbraith wrote:
> > 2.6.24.7-up
> > ring-test   - 1.100 us/cycle  = 909 KHz  (gcc-4.1)
> > ring-test   - 1.068 us/cycle  = 936 KHz  (gcc-4.3)
> > netperf     - 122300.66 rr/s  = 244 KHz  sb 280 KHz / 140039.03 rr/s
> > tbench      - 341.523 MB/sec
> > 
> > 2.6.25.17-up
> > ring-test   - 1.163 us/cycle  = 859 KHz  (gcc-4.1)
> > ring-test   - 1.129 us/cycle  = 885 KHz  (gcc-4.3)
> > netperf     - 132102.70 rr/s  = 264 KHz  sb 275 KHz / 137627.30 rr/s
> > tbench      - 361.71 MB/sec
> > 
> > ..in 25, something happened that dropped my max context switch rate from
> > ~930 KHz to ~885 KHz.  Maybe I'll have better luck trying to find that.
> > Added to to-do list.  Benchmark mysteries I'm going to have to leave
> > alone, they've kicked my little butt quite thoroughly ;-)
> 
> But note that tbench performance improved a bit in 2.6.25.

Yeah, netperf too.

> In my tests I noticed a similar effect, but from 2.6.23 to 2.6.24,
> weird.

23->24 I can understand.  In my testing, 23 CFS was not a wonderful
experience for rapid switchers.  24 is cfs-24.1.
 
> Just for the public record here are the numbers I got in my testing.
> Each entry was run purely on the latest 2.6.X-stable tree for each
> release.  First is the tbench score and then there are 40 numbers
> which are sparc64 cpu cycle counts of default_wake_function().

Your numbers seem to ~agree with mine.  And yeah, that hrtick is damned
expensive.  I didn't realize _how_ expensive until I trimmed my config
way way down from distro.  Just having highres timers enabled makes a
very large difference here, even without hrtick enabled, and with the
overhead of a disabled hrtick removed.

	-Mike

