Return-Path: <linux-kernel-owner+w=401wt.eu-S933397AbXGYQT2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933397AbXGYQT2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 12:19:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758321AbXGYQTV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 12:19:21 -0400
Received: from wr-out-0506.google.com ([64.233.184.224]:39656 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755154AbXGYQTU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 12:19:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=cOonTEHJI8fHLBAsDNVK9DdrCnFsN6xReFiRCgL4O5otH492ewEdCOXVwjoUcOquldFhbwILR0zQMehX0jciQx/LqeLN5NsZWllwdFS4G9Z/QuICNZ5J6KDFS+5cVfT/bf3BOV6vf3F0pN/uavXF9+8Vq1PYvh6FNIyKCT0BTHI=
Message-ID: <2c0942db0707250919j48a65798s816b4cad27171e56@mail.gmail.com>
Date: Wed, 25 Jul 2007 09:19:04 -0700
From: "Ray Lee" <ray-lk@madrabbit.org>
To: "Nick Piggin" <nickpiggin@yahoo.com.au>
Subject: Re: -mm merge plans for 2.6.23
Cc: "Jesper Juhl" <jesper.juhl@gmail.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "ck list" <ck@vds.kolivas.org>, "Ingo Molnar" <mingo@elte.hu>,
       "Paul Jackson" <pj@sgi.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <46A6CC56.6040307@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070710013152.ef2cd200.akpm@linux-foundation.org>
	 <200707102015.44004.kernel@kolivas.org>
	 <9a8748490707231608h453eefffx68b9c391897aba70@mail.gmail.com>
	 <46A57068.3070701@yahoo.com.au>
	 <2c0942db0707232153j3670ef31kae3907dff1a24cb7@mail.gmail.com>
	 <46A58B49.3050508@yahoo.com.au>
	 <2c0942db0707240915h56e007e3l9110e24a065f2e73@mail.gmail.com>
	 <46A6CC56.6040307@yahoo.com.au>
X-Google-Sender-Auth: ff4d5d27bdd2097e
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/24/07, Nick Piggin <nickpiggin@yahoo.com.au> wrote:
> Ray Lee wrote:
> > On 7/23/07, Nick Piggin <nickpiggin@yahoo.com.au> wrote:
> >> If we can first try looking at
> >> some specific problems that are easily identified.
> >
> > Always easier, true. Let's start with "My mouse jerks around under
> > memory load." A Google Summer of Code student working on X.Org claims
> > that mlocking the mouse handling routines gives a smooth cursor under
> > load ([1]). It's surprising that the kernel would swap that out in the
> > first place.
> >
> > [1]
> > http://vignatti.wordpress.com/2007/07/06/xorg-input-thread-summary-or-something/
>
> OK, I'm not sure what the point is though. Under heavy memory load,
> things are going to get swapped out... and swap prefetch isn't going
> to help there (at least, not during the memory load).

Sorry, I headed slightly off-topic. Or perhaps 'up-topic' to the
larger issue, which is that the desktop experience has some suckiness
to it.

My point is that the page replacement algorithm has some choice as to
what to evict. The xorg input handler never should have been evicted.
It was hopefully a hard example of where the current page replacement
policy is falling flat on its face.

All that said, this could really easily be handled by xorg mlocking
the critical realtime stuff.

> There are also other issues like whether the CPU scheduler is at fault,
> etc. Interactive workloads are always the hardest to work out.

This one is not a scheduler issue, as mlock()ing the mouse handling
routines gives a smooth cursor. It's just a pure page replacement
problem, as the kernel should never have swapped that out in the first
place.

<snip things I agreed with>

<snip list of things to watch during updatedb run>

Ray
