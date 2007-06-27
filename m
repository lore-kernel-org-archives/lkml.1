Return-Path: <linux-kernel-owner+w=401wt.eu-S1756379AbXF0AWm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756379AbXF0AWm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 20:22:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753295AbXF0AWf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 20:22:35 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57928 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752571AbXF0AWe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 20:22:34 -0400
Date: Wed, 27 Jun 2007 02:22:08 +0200
From: Andrea Arcangeli <andrea@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       John Stultz <johnstul@us.ibm.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch, v2.6.22-rc6] sys_time() speedup
Message-ID: <20070627002208.GB6670@v2.random>
References: <20070625200601.GA18980@elte.hu> <200706252309.47467.zippel@linux-m68k.org> <20070625151508.86fa3778.akpm@linux-foundation.org> <20070626152629.GA3342@elte.hu> <20070626101440.8f9ab65b.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070626101440.8f9ab65b.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 26, 2007 at 10:14:40AM -0700, Andrew Morton wrote:
> On my machine, time(2) doesn't do any syscall at all - it uses the vsyscall
> page.  I'd be surprised if a database uses sys_time() either.

Large boxes unfortunately can't always use vsyscalls...  that's a real
pity. I also had to disable the vsyscalls64 to generate some number.

I think there shall be a perfectly accurate but not monotone mode for
gettimeofday so we can enable rdtscp (via sysctl or/and prctl). Aware
apps can enable the prctl, aware or brave admins can turn on the
sysctl. Vojtech and others should have proper patches to merge for
this.
