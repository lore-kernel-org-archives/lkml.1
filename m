Return-Path: <linux-kernel-owner+w=401wt.eu-S1422846AbXBAMvg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422846AbXBAMvg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 07:51:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422847AbXBAMvg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 07:51:36 -0500
Received: from mx2.suse.de ([195.135.220.15]:60162 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422846AbXBAMvf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 07:51:35 -0500
Date: Thu, 1 Feb 2007 13:54:42 +0100
From: Andrea Arcangeli <andrea@suse.de>
To: Andi Kleen <ak@suse.de>
Cc: jbohac@suse.cz, linux-kernel@vger.kernel.org,
       Vojtech Pavlik <vojtech@suse.cz>, ssouhlal@freebsd.org,
       arjan@infradead.org, tglx@linutronix.de, johnstul@us.ibm.com,
       zippel@linux-m68k.org
Subject: Re: [patch 0/9] x86_64: reliable TSC-based gettimeofday
Message-ID: <20070201125442.GD13277@opteron.random>
References: <20070201095952.589234000@jet.suse.cz> <200702011220.59484.ak@suse.de> <20070201115336.GC13277@opteron.random> <200702011302.41963.ak@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200702011302.41963.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 01, 2007 at 01:02:41PM +0100, Andi Kleen wrote:
> I don't think so because having per process state in a vsyscall
> is quite costly. You would need to allocate at least one more
> page to each process, which I think would be excessive.

You would need one page per cpu and to check a change in a TIF_
bitflag during switch_to (zero cost) and overwrite the vsyscall bit in
the slow path.

If we had a picotimeofday that would be guaranteed monotone... if he
can measure errors with shared memory in smp, it means the measurement
error (LAPIC and tsc frequency estimation) is longer than the time it
takes to bounce a spinlock and reach a second rdtscp. I hoped this
wouldn't happen. Could you send me the app used to reproduce the
non-monotonicity over shared memory with rdtscp? I finally have a (EE)
stepping F to attempt testing it. thanks!
