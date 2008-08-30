Return-Path: <linux-kernel-owner+w=401wt.eu-S1755441AbYH3NnT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755441AbYH3NnT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2008 09:43:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751338AbYH3NnJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Aug 2008 09:43:09 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:33458 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750856AbYH3NnI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2008 09:43:08 -0400
Date: Sat, 30 Aug 2008 09:43:04 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: "Frank Ch. Eigler" <fche@redhat.com>, Roland McGrath <roland@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] utrace
Message-ID: <20080830134304.GC17566@infradead.org>
References: <20080826220102.89635154233@magilla.localdomain> <20080826223402.GB27724@x200.localdomain> <y0m7ia3xqev.fsf@ton.toronto.redhat.com> <20080827153422.GA28611@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080827153422.GA28611@x200.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 27, 2008 at 07:34:22PM +0400, Alexey Dobriyan wrote:
> On Tue, Aug 26, 2008 at 08:17:12PM -0400, Frank Ch. Eigler wrote:
> > Alexey Dobriyan <adobriyan@gmail.com> writes:
> > 
> > > [...]  And some internal details still horrible and overdesigned
> > > just like at the very beginning.
> > 
> > Please point out specific areas, and I'm sure there will be a reasonable
> > explanation why they turned out this way.
> > 
> > As for whether "struct utrace" should be a member of vs. pointed-to
> > from task_struct, it may come down to the perceived need to avoid
> > penalizing every thread with a hundred-odd bytes extra, whether or not
> > they are being utrace-controlled.
> 
> Yes, that's your price for avoiding more races, more code, more races,
> more tricky code and ultimately more ways to fsckup.
> 
> God, you're in the very tricky Unix subsystem only a few people know
> intimately, and what we see? utrace code is just as tricky.
> 
> When you're confident that interaction with engines part is fine, all
> stupid bugs were fixed, go change struct utrace to pointer. Now it can
> very well be a lie to say less memory is used because slab allocator
> rounds up sizes to certain degree.

Yes.  And btw, the early utrace patches actually moved the ptrace
state into dynamically allocated per engine state, which would almost
cancel out the additional members required for utrace.  I'm not sure
why this went away in the meantime.

