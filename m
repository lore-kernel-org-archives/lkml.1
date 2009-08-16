Return-Path: <linux-kernel-owner+w=401wt.eu-S1753147AbZHPFBR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753147AbZHPFBR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Aug 2009 01:01:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751195AbZHPFBR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Aug 2009 01:01:17 -0400
Received: from cantor.suse.de ([195.135.220.2]:33477 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750915AbZHPFBQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Aug 2009 01:01:16 -0400
Date: Sun, 16 Aug 2009 07:01:17 +0200
From: Nick Piggin <npiggin@suse.de>
To: Manfred Spraul <manfred@colorfullife.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Nadia Derbey <Nadia.Derbey@bull.net>,
       Pierre Peiffer <peifferp@gmail.com>
Subject: Re: [PATCH 0/4] ipc/sem.c: Alternative to Nick's patch
Message-ID: <20090816050117.GB11115@wotan.suse.de>
References: <200908160048.n7G0mtO1023800@mail.q-ag.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200908160048.n7G0mtO1023800@mail.q-ag.de>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 15, 2009 at 11:57:12PM +0200, Manfred Spraul wrote:
> The following series of 4 patches are an alternative to Nick's 4th
> patch. They are intended to be applied after the first 3 patches from
> Nick.
> 
> The advantages are simple:
> - Lower number of new code lines.
> - Lower total code size increase.

Look, I just think these are not a good advantage, because the
complex queue and algorithm is nasty to use for simple ops. I
don't think it is an advantage to make simple op processing
more complex just so it fits in the existing complex op processing.

> - Lower runtime memory consumption.

I'll fix this.

> - 4 simple patches with the individual changes, each one can be
>   reviewed individually.

I don't really get this. Was my patch hard to review?

> - Lower number of seperate codepaths.

As I said, I don't think this is such an advantage. The disadvantage
is that you make the already complex path more complex, wheras I just
add a simpler path. So.

> The disadvantage is also clear:
> My patch doesn't optimize wait-for-zero as good as Nick's patch.
> For example:
> * n wait-for-zero entries and one decrement by 2 to be woken up,
>   semval at 1, an increment by 2 arrives:
>     Nick's patch is O(1) and my patch is O(n).
> 
> Neither of us knows if anyone uses that scenario and there are other
> codepaths that are O(n^2), too. Thus I don't think this is a big issue.
> 
> Below is the test app/benchmark app I used:
> The present kernel breaks down if lots of tasks are sleeping on the same
> semaphore array, with the patch, the breakdown disappears.
> 
> With my test app, the performance of Nick's and my patch are comparable.

This app is pretty similar to mine.

