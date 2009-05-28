Return-Path: <linux-kernel-owner+w=401wt.eu-S1756799AbZE1HCt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756799AbZE1HCt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 03:02:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750983AbZE1HCl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 03:02:41 -0400
Received: from oblivion.subreption.com ([66.240.236.22]:45819 "EHLO
	mail.subreption.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750964AbZE1HCk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 03:02:40 -0400
Date: Thu, 28 May 2009 00:00:47 -0700
From: "Larry H." <research@subreption.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Ingo Molnar <mingo@elte.hu>, Rik van Riel <riel@redhat.com>,
       linux-kernel@vger.kernel.org, Linus Torvalds <torvalds@osdl.org>,
       linux-mm@kvack.org, Ingo Molnar <mingo@redhat.com>,
       pageexec@freemail.hu
Subject: Re: [patch 0/5] Support for sanitization flag in low-level page
	allocator
Message-ID: <20090528070047.GC29711@oblivion.subreption.com>
References: <20090520183045.GB10547@oblivion.subreption.com> <4A15A8C7.2030505@redhat.com> <20090522073436.GA3612@elte.hu> <20090522113809.GB13971@oblivion.subreption.com> <20090523124944.GA23042@elte.hu> <4A187BDE.5070601@redhat.com> <20090527223421.GA9503@elte.hu> <20090528072702.796622b6@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090528072702.796622b6@lxorguk.ukuu.org.uk>
Organization: Subreption LLC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07:27 Thu 28 May     , Alan Cox wrote:
> > > As for being swapped out - I do not believe that kernel stacks can 
> > > ever be swapped out in Linux.
> > 
> > yes, i referred to that as an undesirable option - because it slows 
> > down pthread_create() quite substantially.
> > 
> > This needs before/after pthread_create() benchmark results.
> 
> kernel stacks can end up places you don't expect on hypervisor based
> systems.
> 
> In most respects the benchmarks are pretty irrelevant - wiping stuff has
> a performance cost, but its the sort of thing you only want to do when
> you have a security requirement that needs it. At that point the
> performance is secondary.
> 
> Alan

Right, besides I believe Ingo is confused about the nature of the patch.
It looks like he believes it's about userland memory sanitization, when
that isn't what is being done here.

If he still believe this has anything to do with it directly, or can
introduce a performance impact on pthread_create() (remember we are
sanitizing on release only...), I'll be pleased to provide benchmark
results that prove it wrong (or right, if it was the case).

Any existent benchmark tests available that I can modify to suit our
needs here, or I'll need to waste some time on writing them from scratch?

	Larry

