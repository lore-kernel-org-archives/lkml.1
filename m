Return-Path: <linux-kernel-owner+w=401wt.eu-S1422831AbXBAMCq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422831AbXBAMCq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 07:02:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422830AbXBAMCq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 07:02:46 -0500
Received: from ns1.suse.de ([195.135.220.2]:33535 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422780AbXBAMCp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 07:02:45 -0500
From: Andi Kleen <ak@suse.de>
To: Andrea Arcangeli <andrea@suse.de>
Subject: Re: [patch 0/9] x86_64: reliable TSC-based gettimeofday
Date: Thu, 1 Feb 2007 13:02:41 +0100
User-Agent: KMail/1.9.5
Cc: jbohac@suse.cz, linux-kernel@vger.kernel.org,
       Vojtech Pavlik <vojtech@suse.cz>, ssouhlal@freebsd.org,
       arjan@infradead.org, tglx@linutronix.de, johnstul@us.ibm.com,
       zippel@linux-m68k.org
References: <20070201095952.589234000@jet.suse.cz> <200702011220.59484.ak@suse.de> <20070201115336.GC13277@opteron.random>
In-Reply-To: <20070201115336.GC13277@opteron.random>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702011302.41963.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 01 February 2007 12:53, Andrea Arcangeli wrote:
> On Thu, Feb 01, 2007 at 12:20:59PM +0100, Andi Kleen wrote:
> > I think a better way to do this would be to define a new CLOCK_THREAD_MONOTONOUS
> > (or better name) timer for clock_gettime(). 
> > 
> > [and my currently stalled vdso patches that implement clock_gettime
> > as a vsyscall]
> > 
> > Then also an application could easily use it with LD_PRELOAD
> 
> I think a prctl to enable the non monothone mode is better than any
> LD_PRELOAD trick.

I don't think so because having per process state in a vsyscall
is quite costly. You would need to allocate at least one more
page to each process, which I think would be excessive.

-Andi
