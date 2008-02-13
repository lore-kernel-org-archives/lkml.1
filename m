Return-Path: <linux-kernel-owner+w=401wt.eu-S1754895AbYBMFov@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754895AbYBMFov (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 00:44:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751789AbYBMFok
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 00:44:40 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50560 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751683AbYBMFoe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 00:44:34 -0500
Date: Tue, 12 Feb 2008 21:43:10 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "J. Bruce Fields" <bfields@fieldses.org>
cc: David Miller <davem@davemloft.net>, jeff@garzik.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       linville@tuxdriver.com
Subject: Re: Announce: Linux-next (Or Andrew's dream :-))
In-Reply-To: <20080213042512.GB9766@fieldses.org>
Message-ID: <alpine.LFD.1.00.0802122127110.2920@woody.linux-foundation.org>
References: <47B1C9F4.30402@garzik.org> <20080212193754.GC18625@fieldses.org> <alpine.LFD.1.00.0802121156400.2920@woody.linux-foundation.org> <20080212.165014.01238510.davem@davemloft.net> <alpine.LFD.1.00.0802121710510.2920@woody.linux-foundation.org>
 <20080213042512.GB9766@fieldses.org>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 12 Feb 2008, J. Bruce Fields wrote:

> > So as a result, some *random* commit that was actually fine on its own has 
> > now become a bug, just because it was re-written. 
> 
> If there was a "fundamental thing that didn't cause a conflict", then
> the two trees in question probably didn't touch the same code, so would
> probably merge cleanly, for the same reason that one rebased onto the
> other cleanly.  But depending on what the "fundamental thing" was, the
> merge might still introduce the same bug, right?

Absolutely. But if you do a true merge, the bug is clearly in the merge 
(automatedly clean or not), and the blame is there too. IOW, you can blame 
me for screwing up. Now, I will say "oh, me bad, I didn't realize how 
subtle the interaction was", so it's not like I'll be all that contrite, 
but at least it's obvious where the blame lies.

In contrast, when you rebase, the same problem happens, but now a totally 
innocent commit is blamed just because it happened to no longer work in 
the location it was not tested in. The person who wrote that commit, the 
people who tested it and said it works, all that work is now basically 
worthless: the testing was done with another version, the original patch 
is bad, and the history and _reason_ for it being bad has been lost.

And there's literally nothing left to indicate the fact that the patch and 
the testing _used_ to be perfectly valid.

That may not sound like such a big deal, but what does that make of code 
review and tested-by, and the like? It just makes a mockery of trying to 
do a good job testing any sub-trees, when you know that eventually it will 
all quite possibly be pointless, and the fact that maybe the networking 
tree was tested exhaustively is all totally moot, because in the end the 
stuff that hit the main tree is something else altogether?

I don't know about you, but I'd personally be really disappointed if it 
happened to me, and I felt that I did a really good job as a 
submaintainer. I'd also feel that the source control management sucked.

Contrast that to the case where somebody simply does a merge error. The 
original work doesn't lose it's validity - so the original maintainer 
hasn't lost anything. And quite frankly, even the person who "screwed up" 
with the merge hasn't really done anything bad: these things _do_ happen. 

So bugs happen; not big deal. But the fact that the bugs are correctly 
attributed - or rather, not mis-attributed to somebody blameless - that 
_is_ a big deal.

It's not like I will guarantee that all my manual merges are always 100% 
correct, much less try to guarantee that no subtle merge issue can make 
things not work even if it all merged totally cleanly. That isn't my 
point. And others will make merge mistakes too. But the people they merged 
from will not be blamed.

So just the fact that the right commit gets blamed when somebody does a 
"git bisect" is I think a big issue. It's just fundamentally more fair to 
everybody. And it means that the people who push their work to me can 
really choose to stand behind it, knowing that whatever happens, their 
work won't get diluted by bad luck or others' incompetence.

And no, maybe most people don't feel things like that matters. But I do 
think it's important.

			Linus
