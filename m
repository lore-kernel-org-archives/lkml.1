Return-Path: <linux-kernel-owner+w=401wt.eu-S933780AbZKXSJn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933780AbZKXSJn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 13:09:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933737AbZKXSJm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 13:09:42 -0500
Received: from mail.gmx.net ([213.165.64.20]:53254 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S933735AbZKXSJm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 13:09:42 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19qbhQwsmlqbuPCDnDF/YfoXX4XMRvdNcc4bU2cxp
	/zlBnpqpdfWS7f
Subject: Re: newidle balancing in NUMA domain?
From: Mike Galbraith <efault@gmx.de>
To: Jason Garrett-Glaser <darkshikari@gmail.com>
Cc: Nick Piggin <npiggin@suse.de>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <28f2fcbc0911240924r708202cdx8bc7b465d473f283@mail.gmail.com>
References: <20091123112228.GA2287@wotan.suse.de>
	 <1258976175.4531.299.camel@laptop>  <20091123114550.GB25575@elte.hu>
	 <20091123120100.GC2287@wotan.suse.de>  <20091123120849.GB32009@elte.hu>
	 <20091123122731.GE2287@wotan.suse.de>  <20091123124615.GA27808@elte.hu>
	 <20091124063653.GB20981@wotan.suse.de>
	 <28f2fcbc0911240924r708202cdx8bc7b465d473f283@mail.gmail.com>
Content-Type: text/plain
Date: Tue, 24 Nov 2009 19:09:41 +0100
Message-Id: <1259086181.15249.117.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.61
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-11-24 at 09:24 -0800, Jason Garrett-Glaser wrote:
> > Quite a few being one test case, and on a program with a horrible
> > parallelism design (rapid heavy weight forks to distribute small
> > units of work).
> 
> > If x264 is declared dainbramaged, that's fine with me too.
> 
> We did multiple benchmarks using a thread pool and it did not help.

Yes, I see no way it possibly could make any difference.

Well, there is one thing.  We have this START_DEBIT thing, using a
thread pool avoids that very significant penalty.  WRT idle->busy again
time though, it can't make any difference.

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

I don't consider x264 to be braindamaged btw, I consider it to be a very
nice testcase for the scheduler.  As soon as I saw the problem it
highlighted so well, it became a permanent member of my collection.

	-Mike

