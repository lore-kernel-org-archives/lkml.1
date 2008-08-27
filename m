Return-Path: <linux-kernel-owner+w=401wt.eu-S1757095AbYH0Pc7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757095AbYH0Pc7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 11:32:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753391AbYH0Pcv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 11:32:51 -0400
Received: from gv-out-0910.google.com ([216.239.58.187]:20548 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753370AbYH0Pcu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 11:32:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=x14hbI5YuJnGHkkcXnzZx0HRiPJmrU73+BsNCbJuOA3V6f1M73MLA8/H7limc3U+Fb
         i4slCogIjq7R/ULk0DIxuQPzRpmunRZcFnic1IE3+UEOUY58Al+goGPG566EyxMnG5kX
         bFVH44l9Si43xWcJMWDYtS7xs2ROA9qDqPG/g=
Date: Wed, 27 Aug 2008 19:34:22 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: "Frank Ch. Eigler" <fche@redhat.com>
Cc: Roland McGrath <roland@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] utrace
Message-ID: <20080827153422.GA28611@x200.localdomain>
References: <20080826220102.89635154233@magilla.localdomain> <20080826223402.GB27724@x200.localdomain> <y0m7ia3xqev.fsf@ton.toronto.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <y0m7ia3xqev.fsf@ton.toronto.redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 26, 2008 at 08:17:12PM -0400, Frank Ch. Eigler wrote:
> Alexey Dobriyan <adobriyan@gmail.com> writes:
> 
> > [...]  And some internal details still horrible and overdesigned
> > just like at the very beginning.
> 
> Please point out specific areas, and I'm sure there will be a reasonable
> explanation why they turned out this way.
> 
> As for whether "struct utrace" should be a member of vs. pointed-to
> from task_struct, it may come down to the perceived need to avoid
> penalizing every thread with a hundred-odd bytes extra, whether or not
> they are being utrace-controlled.

Yes, that's your price for avoiding more races, more code, more races,
more tricky code and ultimately more ways to fsckup.

God, you're in the very tricky Unix subsystem only a few people know
intimately, and what we see? utrace code is just as tricky.

When you're confident that interaction with engines part is fine, all
stupid bugs were fixed, go change struct utrace to pointer. Now it can
very well be a lie to say less memory is used because slab allocator
rounds up sizes to certain degree.

> > [...]  Linked list of attached tracers? I don't know.  One the bad
> > side, where are those nice tracing modules? Where are they?
> 
> Among others, utrace is an enablement layer for systemtap user-space
> probing, through another subsequent part that implements a
> kprobes-like API for user-space tasks.  All this code now exists in at
> least prototype form, so if you need to see the bigger picture, look
> that way.  Other users are anticipated, but first we need to get past
> the chicken-and-egg.

There are no chickens and no eggs.

utrace is in RHEL4, RHEL5, FC6, FC7, FC8, FC9 kernels already.

I can't believe RedHat allowed to totally rewrite ptrace based on some
prototype code.

> > This all similar to systemtap/markers story. Big changes under
> > promises that now, now somebody will use our thing.
> 
> In what way do you think those promises are unfulfilled?  Systemtap
> has interfaced to markers since the beginning,

It just wants entry point, right?

> and there are a bunch of markers in the tree.

Total 3 in scheduler and in spufs (ppc-specific).

Amazing improvement for ugly macros, more self-modified kernel, explicit
reasons stated why they are stupid spelt in review and after entering tree,
and general dislike of some maintainers to add more trace_mark() entries.


So there were promises that markers will be useful, 10 months passed and
they are still useless. How did this happen?

Now utrace is in better position in this respect -- ptrace(2) will use
it from start but this doesn't change "promises" part.

