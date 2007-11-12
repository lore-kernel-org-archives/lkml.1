Return-Path: <linux-kernel-owner+w=401wt.eu-S1755516AbXKLSjk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755516AbXKLSjk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 13:39:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751405AbXKLSjc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 13:39:32 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60381 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751246AbXKLSjb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 13:39:31 -0500
Date: Mon, 12 Nov 2007 10:39:15 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Alexey Dobriyan <adobriyan@gmail.com>
cc: mel@csn.ul.ie, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@vger.kernel.org
Subject: Re: Major mke2fs slowdown (reproducable, bisected)
In-Reply-To: <20071112182526.GC11244@martell.zuzino.mipt.ru>
Message-ID: <alpine.LFD.0.9999.0711121034220.30499@woody.linux-foundation.org>
References: <20071112182526.GC11244@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 12 Nov 2007, Alexey Dobriyan wrote:
>
> Cross-compile farm here migrated to .ccache and build dir on separate
> disks and now I have a way to blow up .ccache without waiting half an
> hour for rm(1) to finish. It's called mke2fs(8).
> 
> However, in e.g 2.6.24-rc2 mke2fs is amazingly slow if done right after
> several fat cross-compile builds. Normally it takes ~11 seconds to
> finish. After commit 5adc5be7cd1bcef6bb64f5255d2a33f20a3cf5be aka
> "Bias the placement of kernel pages at lower PFNs" it takes several
> minutes. 2.6.24-rc2 without this patch also gives normal mkfs speeds.
> I'm pretty sure bisection wasn't screwed up.

Can you (just to make sure) do a "git revert" of this commit on top of the 
current tree, and verify that that makes it all work fine again too? If 
so, let's just revert it.

I just want to make sure that there isn't some subtle interaction with 
anything else in there.

		Linus
