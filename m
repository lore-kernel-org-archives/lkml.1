Return-Path: <linux-kernel-owner+w=401wt.eu-S1754605AbYGGMDQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754605AbYGGMDQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 08:03:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753237AbYGGMDD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 08:03:03 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:56527 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753189AbYGGMDC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 08:03:02 -0400
Date: Mon, 7 Jul 2008 13:02:18 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: Nick Piggin <nickpiggin@yahoo.com.au>
cc: Martin Schwidefsky <schwidefsky@googlemail.com>, benh@kernel.crashing.org,
       cotte@de.ibm.com, Zan Lynx <zlynx@acm.org>,
       Ryan Hope <rmh3093@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Lockless/Get_User_Pages_Fast causes Xorg 1.4.99.* to lock
In-Reply-To: <200807072139.48462.nickpiggin@yahoo.com.au>
Message-ID: <Pine.LNX.4.64.0807071245220.28196@blonde.site>
References: <48f7fe350807032326l1d68c94l531e44c09693b989@mail.gmail.com>
 <200807071806.11630.nickpiggin@yahoo.com.au> <Pine.LNX.4.64.0807071134090.21480@blonde.site>
 <200807072139.48462.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 Jul 2008, Nick Piggin wrote:
> On Monday 07 July 2008 20:39, Hugh Dickins wrote:
> > On Mon, 7 Jul 2008, Nick Piggin wrote:
> > > I think we need a similar fix for s390 too. If so, then it really should
> > > get into 2.6.26, but this late in the release, I hope an s390 maintainer
> > > might be able to test and verify the fix?
> >
> > Wow, yes, I hadn't realized s390 is ahead of the game there: glad you're
> > back to spot that.  But yes, we'd prefer maintainer to confirm and push.
> >
> >
> > [PATCH]] s390: protect _PAGE_SPECIAL bit against mprotect
> >
> > Stop mprotect's pte_modify from wiping out the s390 pte_special bit, which
> > caused oops thereafter when vm_normal_page thought X's abnormal was normal.
> >
> > Signed-off-by: Nick Piggin <npiggin@suse.de>
> > Acked-by: Hugh Dickins <hugh@veritas.com>
> 
> Thanks, I feel silly to take the authorship of this before your x86
> version gets in (and will likely not be credited if it is folded
> before merging)
> 
> Martin, could you please credit Hugh for the debugging? :)

Oh, I'm more anxious for your fix to get to Linus than for credit
to be fairly apportioned - we don't need an Oscar ceremony here!

But if Martin does choose to add credits, then it's Ryan's and
Zan's x86 reports that should be credited - they did the hard work.
I didn't mention them in the x86 patch because at that stage I was
just making a wild guess that this might be the cause of their problems.

Hugh
