Return-Path: <linux-kernel-owner+w=401wt.eu-S1754453AbZGJJOd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754453AbZGJJOd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 05:14:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751045AbZGJJO0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 05:14:26 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:53863 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750765AbZGJJOZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 05:14:25 -0400
Subject: Re: [RFC][PATCH] Check write to slab memory which freed already
 using mudflap
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Nick Piggin <npiggin@suse.de>
Cc: Ingo Molnar <mingo@elte.hu>, Janboe Ye <yuan-bo.ye@motorola.com>,
       linux-kernel@vger.kernel.org, vegard.nossum@gmail.com,
       graydon@redhat.com, fche@redhat.com, cl@linux-foundation.org
In-Reply-To: <20090710090351.GD14666@wotan.suse.de>
References: <1247156020.27671.40.camel@debian-nb>
	 <84144f020907090944u51f60cbsc0a4ec2c2cbdcc8c@mail.gmail.com>
	 <20090710084745.GA26752@elte.hu> <1247215920.32044.3.camel@penberg-laptop>
	 <20090710090351.GD14666@wotan.suse.de>
Date: Fri, 10 Jul 2009 12:14:23 +0300
Message-Id: <1247217263.771.8.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nick,

On Fri, 2009-07-10 at 11:03 +0200, Nick Piggin wrote:
> > And whether SQLB will replace SLUB remains to be seen.
> > We're still fixing minor issues here and there in SLUB so I have no
> > reason to expect SLQB stabilization to happen overnight which means
> > we're going to have SLUB in the tree for a while anyway.
> 
> I think it's pretty good now. It was the right thing not to merge
> it in this window (seeing as I'd forgotten to make it the default
> in -next). And that flushed out a bug or two. The core logic I
> think is pretty solid now though.

The long-standing PowerPC issue is still open, isnt't it? But anyway, my
main point is that we've already seen from the SLAB to SLUB transition
that while most of the bugs are fixed early on, there's a "fat tail" of
problems ranging from performance regressions to slab corruption which
take a long time to be discovered and fixed up.

And I'm not trying to spread FUD on SLQB here, I'm simply stating the
facts from the previous "slab rewrite" and I have no reason to expect
this one to go any smoother. OTOH, SLQB has already had exposure in
linux-next which hopefully makes merging to mainline less painful
because 95% of the problems are ironed out. But I don't think there's
much we can do about the remaining 5% that only trigger on weird
architectures, workloads, or hardware configurations.

But I think we've been in agreement on this with Nick in the past. So I
guess my rant is directed towards Ingo who seems to be bit too eager to
merge SLQB and rm mm/sl{a,u}b.c :-).

			Pekka

