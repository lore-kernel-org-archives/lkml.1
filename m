Return-Path: <linux-kernel-owner+w=401wt.eu-S1757177AbXKLVex@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757177AbXKLVex (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 16:34:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753152AbXKLVep
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 16:34:45 -0500
Received: from nf-out-0910.google.com ([64.233.182.184]:62766 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752072AbXKLVep (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 16:34:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:from;
        b=dsyKxiIcJOxt3TC8a9ZGwvgGa0O6QuVlhfkftxBCU8yRQkvf4ne0MHxnvC5zXmgUufJzF2DyqMKFXi3amkzEH6VP1vK4vLvQzSc4U0T9Y1st8CffRcPidknmWe9/vmRySsnTfxSwuCVCWbddrZDNYwcAwlFOCEj1kJZPuM5XSsM=
Date: Tue, 13 Nov 2007 00:34:31 +0300
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: mel@csn.ul.ie, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@vger.kernel.org
Subject: Re: Major mke2fs slowdown (reproducable, bisected)
Message-ID: <20071112213431.GE11244@martell.zuzino.mipt.ru>
References: <20071112182526.GC11244@martell.zuzino.mipt.ru> <alpine.LFD.0.9999.0711121034220.30499@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.9999.0711121034220.30499@woody.linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Alexey Dobriyan <adobriyan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 12, 2007 at 10:39:15AM -0800, Linus Torvalds wrote:
> On Mon, 12 Nov 2007, Alexey Dobriyan wrote:
> >
> > Cross-compile farm here migrated to .ccache and build dir on separate
> > disks and now I have a way to blow up .ccache without waiting half an
> > hour for rm(1) to finish. It's called mke2fs(8).
> > 
> > However, in e.g 2.6.24-rc2 mke2fs is amazingly slow if done right after
> > several fat cross-compile builds. Normally it takes ~11 seconds to
> > finish. After commit 5adc5be7cd1bcef6bb64f5255d2a33f20a3cf5be aka
> > "Bias the placement of kernel pages at lower PFNs" it takes several
> > minutes. 2.6.24-rc2 without this patch also gives normal mkfs speeds.
> > I'm pretty sure bisection wasn't screwed up.
> 
> Can you (just to make sure) do a "git revert" of this commit on top of the 
> current tree, and verify that that makes it all work fine again too? If 
> so, let's just revert it.
> 
> I just want to make sure that there isn't some subtle interaction with 
> anything else in there.

OK, with 2.6.24-rc2-6e800af233e0bdf108efb7bd23c11ea6fa34cdeb
mkfs took 4m6.915s seconds. With just "lower PFNs" patch reverted it's
back to 10 seconds.
