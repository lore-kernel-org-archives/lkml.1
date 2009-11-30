Return-Path: <linux-kernel-owner+w=401wt.eu-S1753478AbZK3ITQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753478AbZK3ITQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 03:19:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753294AbZK3ITP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 03:19:15 -0500
Received: from cantor.suse.de ([195.135.220.2]:33484 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752397AbZK3ITO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 03:19:14 -0500
Date: Mon, 30 Nov 2009 09:19:18 +0100
From: Nick Piggin <npiggin@suse.de>
To: Jason Garrett-Glaser <darkshikari@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: newidle balancing in NUMA domain?
Message-ID: <20091130081918.GM17484@wotan.suse.de>
References: <20091123112228.GA2287@wotan.suse.de> <1258976175.4531.299.camel@laptop> <20091123114550.GB25575@elte.hu> <20091123120100.GC2287@wotan.suse.de> <20091123120849.GB32009@elte.hu> <20091123122731.GE2287@wotan.suse.de> <20091123124615.GA27808@elte.hu> <20091124063653.GB20981@wotan.suse.de> <28f2fcbc0911240924r708202cdx8bc7b465d473f283@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <28f2fcbc0911240924r708202cdx8bc7b465d473f283@mail.gmail.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 24, 2009 at 09:24:26AM -0800, Jason Garrett-Glaser wrote:
> > Quite a few being one test case, and on a program with a horrible
> > parallelism design (rapid heavy weight forks to distribute small
> > units of work).
> 
> > If x264 is declared dainbramaged, that's fine with me too.
> 
> We did multiple benchmarks using a thread pool and it did not help.
> If you want to declare our app "braindamaged", feel free, but pooling
> threads to avoid re-creation gave no benefit whatsoever.  If you think
> the parallelism methodology is wrong as a whole, you're basically
> saying that Linux shouldn't be used for video compression, because
> this is the exact same threading model used by almost every single
> video encoder ever made.  There are actually a few that use
> slice-based threading, but those are actually even worse from your
> perspective, because slice-based threading spawns mulitple threads PER
> FRAME instead of one per frame.
> 
> Because of the inter-frame dependencies in video coding it is
> impossible to efficiently get a granularity of more than one thread
> per frame.  Pooling threads doesn't change the fact that you are
> conceptually creating a thread for each frame--it just eliminates the
> pthread_create call.  In theory you could do one thread per group of
> frames, but that is completely unrealistic for real-time encoding
> (e.g. streaming), requires a catastrophically large amount of memory,
> makes it impossible to track the bit buffer, and all other sorts of
> bad stuff.

If you can scale to N threads by having 1 frame per thread, then
you can scale to N/2 threads and have 2 frames per thread. Can't
you?

Is your problem in scaling to a large N?

