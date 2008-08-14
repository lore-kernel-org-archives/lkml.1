Return-Path: <linux-kernel-owner+w=401wt.eu-S1754841AbYHNEp1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754841AbYHNEp1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 00:45:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751088AbYHNEpS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 00:45:18 -0400
Received: from smtp101.mail.mud.yahoo.com ([209.191.85.211]:41061 "HELO
	smtp101.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751228AbYHNEpR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 00:45:17 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=jtjvZw4pQyPNZ44GhufTAJJndpBYEdqPDSfSolK/JgF1MoGioBRWhWsfJzIFHqESmjfcf4nnth0oOnUgst22wMsdrUXlbxPNfNNqWyd488FQNNZuefuPAEybKKjdvlmTsiHETWHs6EJmUUdeeu5D4OsfBm4DwpkXCmdD6H7ttMw=  ;
X-YMail-OSG: yrOXNXsVM1kbdbDyQYq5s6lEo0bLGPUPwqNurA_863MTcVAWKgK8U1IMBj6Zvfnjamd0VjSkpFBd9sGkNh8B6Wo8omnmUNQwu6VpqyDAl1sxo9vf_6fghIFI44mhfd.WLNY-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [git pull] core fixes
Date: Thu, 14 Aug 2008 14:45:03 +1000
User-Agent: KMail/1.9.5
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "David S. Miller" <davem@davemloft.net>
References: <20080811222026.GA20579@elte.hu> <200808121613.24846.nickpiggin@yahoo.com.au> <200808121805.14009.nickpiggin@yahoo.com.au>
In-Reply-To: <200808121805.14009.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808141445.03936.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 12 August 2008 18:05, Nick Piggin wrote:
> On Tuesday 12 August 2008 16:13, Nick Piggin wrote:
> > On Tuesday 12 August 2008 08:20, Ingo Molnar wrote:
> > > Nick Piggin (1):
> > >       generic-ipi: fix stack and rcu interaction bug in
> > > smp_call_function_mask()
> >
> > I'm still not 100% sure that I have this patch right... I might have seen
> > a lockup trace implicating the smp call function path... which may have
> > been due to some other problem or a different bug in the new call
> > function code, but if some more people can take a look at it before
> > merging?
>
> OK indeed it did have a couple of bugs. Firstly, I wasn't freeing the
> data properly in the alloc && wait case. Secondly, I wasn't resetting
> CSD_FLAG_WAIT in the for each cpu loop (so only the first CPU would
> wait).
>
> After those fixes, the patch boots and runs with the kmalloc commented
> out (so it always executes the slowpath).

Hmm, thanks for merging this Ingo, but it didn't get upstream very
nicely (first was merged the one totally broken patch I didn't even
really test let alone propose for inclusion!). Then some window of
other patches, then the incremental patch to fix it.

I know it probably is easiest for your "vacuum the mailing list" mode
of workflow. And it's not that I don't appreciate it, but what I care
about most is the end result and that is suboptimal in this case.

The argument that we lose the "thought process" of coming up with a
correct patch I don't really buy into either. We want to document
the thought process of well thought out, well reviewed and tested
patches -- if they get merged and subsequently found to be broken, it
is really nice to be able to look back at how and why they went
wrong[*].

But merging bits and pieces of such raw patches IMO just adds too much
noise to the tree, and breaks bisection too easily. In the case of
my patch, the kernel will still build and mostly run, but that is
actually even a worse way to break the biesection if you are hunting
for some obscure and hard to reproduce bug.

[*] BTW. it would be nice to have some formal regression: and/or link:
tags in git patches which I think would help that kind of analysis and
also help distros to pick up fixes...

Do you agree? Or if not, can you explain your views?

Thanks,
Nick
