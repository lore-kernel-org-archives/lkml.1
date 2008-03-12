Return-Path: <linux-kernel-owner+w=401wt.eu-S1754046AbYCLPDZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754046AbYCLPDZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 11:03:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751681AbYCLPDS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 11:03:18 -0400
Received: from mta23.gyao.ne.jp ([125.63.38.249]:30946 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751630AbYCLPDR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 11:03:17 -0400
Date: Thu, 13 Mar 2008 00:01:38 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Paul Jackson <pj@sgi.com>
Cc: Paul Menage <menage@google.com>, kosaki.motohiro@jp.fujitsu.com,
       maxk@qualcomm.com, alan@lxorguk.ukuu.org.uk, adilger@sun.com,
       akpm@linux-foundation.org, daniel.spang@gmail.com, mingo@elte.hu,
       jonathan@jonmasters.org, marcelo@kvack.org, pavel@ucw.cz,
       a.p.zijlstra@chello.nl, riel@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: Tiny cpusets -- cpusets for small systems?
Message-ID: <20080312150138.GA24800@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Paul Jackson <pj@sgi.com>, Paul Menage <menage@google.com>,
	kosaki.motohiro@jp.fujitsu.com, maxk@qualcomm.com,
	alan@lxorguk.ukuu.org.uk, adilger@sun.com,
	akpm@linux-foundation.org, daniel.spang@gmail.com, mingo@elte.hu,
	jonathan@jonmasters.org, marcelo@kvack.org, pavel@ucw.cz,
	a.p.zijlstra@chello.nl, riel@redhat.com,
	linux-kernel@vger.kernel.org
References: <20080223060911.e1d13cc1.pj@sgi.com> <6599ad830802230709m5f0cbf8aia2710bd832408ba7@mail.gmail.com> <20080223095752.25c1ba28.pj@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080223095752.25c1ba28.pj@sgi.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 23, 2008 at 09:57:52AM -0600, Paul Jackson wrote:
> Paul M wrote:
> > I'm don't think that either of these would be enough to justify big
> > changes to cpusets or cgroups, although eliminating bloat is always a
> > good thing.
> 
> My "tiny cpuset" idea doesn't so much eliminate bloat, as provide a
> thin alternative, along side of the existing fat alternative.  So
> far as kernel source goes, it would get bigger, not smaller, with now
> two CONFIG choices for cpusets, fat or tiny.
> 
> The odds are, however, given that one of us has just promised not to
> code this, and the other of us doesn't figure it's worth it, this
> idea will not live long.  Someone would have to step up from the
> embedded side with a coded version that saved a nice chunk of memory
> (from their perspective) to get this off the ground, and no telling
> whether even that would meet with a warm reception.
> 
This has actually been on my TODO list for awhile, though not quite in
the way that you outlined in your initial post. A good reason for why
cpusets are fat at the moment is largely because there's no isolation or
configurability of individual features supported and exposed, leaving one
with an all-or-nothing scenario.

Both the SMP and NUMA bits are fairly orthogonal, and I think isolating
those and making each configurable would already help trim things down
quite a bit (ie, nodemask handling, scheduler domains, etc.). The
filesystem bits are not really that heavy comparatively, so rather than
working on a tiny cpuset implementation, simply splitting up the existing
implementation seems like a much saner approach, and one that can be done
incrementally.

While we're on the topic of cpuset reform, co-processors are another
thing that cpusets is in pretty good shape to handle (particularly in
terms of carving up large grid and dataflow processors and things of that
nature, which we do have customer use cases for in embedded space today).

I'll try to follow up to this thread with an initial patch series in the
not-too-distant future.
