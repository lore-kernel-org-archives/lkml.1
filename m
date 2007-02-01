Return-Path: <linux-kernel-owner+w=401wt.eu-S1422808AbXBAMCr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422808AbXBAMCr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 07:02:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422780AbXBAMCr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 07:02:47 -0500
Received: from ns2.suse.de ([195.135.220.15]:58187 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422808AbXBAMCq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 07:02:46 -0500
From: Andi Kleen <ak@suse.de>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [-mm patch] x86_64 GTOD: offer scalable vgettimeofday
Date: Thu, 1 Feb 2007 13:01:51 +0100
User-Agent: KMail/1.9.5
Cc: jbohac@suse.cz, linux-kernel@vger.kernel.org,
       Vojtech Pavlik <vojtech@suse.cz>, arjan@infradead.org,
       tglx@linutronix.de, johnstul@us.ibm.com, Andrew Morton <akpm@osdl.org>
References: <20070201095952.589234000@jet.suse.cz> <20070201114644.GB26453@elte.hu>
In-Reply-To: <20070201114644.GB26453@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702011301.51834.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 01 February 2007 12:46, Ingo Molnar wrote:
> 
> * jbohac@suse.cz <jbohac@suse.cz> wrote:
> 
> > Inter-CPU monotonicity can not, however, be guaranteed in a vsyscall, 
> > so vsyscall is not used by default. [...]
> 
> note that this is not actually the case. My patch below, ontop of -mm, 
> implements a fully monotonic gettimeofday as an optional vsyscall 
> feature.
> 
> The 'price' paid for it is lower resolution - but it's still good for 
> those benchmarking TPC-C runs - and /alot/ simpler. It's also quite a 
> bit faster than any TSC based vgettimeofday, because it doesnt have to 
> do an RDTSC (or RDTSCP) instruction nor any approximation of the time.

I believe that should be also a separate clock_gettime() CLOCK_ 

Global settings for these things are bad. Even if you run TPC-C you don't
want your other programs that rely on monotonic time to break.

-Andi

