Return-Path: <linux-kernel-owner+w=401wt.eu-S1758639AbYH2TGs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758639AbYH2TGs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 15:06:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753798AbYH2TGj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 15:06:39 -0400
Received: from mx1.redhat.com ([66.187.233.31]:33380 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750842AbYH2TGi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 15:06:38 -0400
Date: Fri, 29 Aug 2008 15:04:41 -0400
From: "Frank Ch. Eigler" <fche@redhat.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Roland McGrath <roland@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] utrace
Message-ID: <20080829190441.GM2888@redhat.com>
References: <20080826220102.89635154233@magilla.localdomain> <20080826223402.GB27724@x200.localdomain> <y0m7ia3xqev.fsf@ton.toronto.redhat.com> <20080827153422.GA28611@x200.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080827153422.GA28611@x200.localdomain>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi -


> > As for whether "struct utrace" should be a member of vs. pointed-to
> > from task_struct, it may come down to the perceived need to avoid
> > penalizing every thread with a hundred-odd bytes extra, whether or not
> > they are being utrace-controlled.
> 
> Yes, that's your price for avoiding more races, more code, more races,
> more tricky code and ultimately more ways to fsckup. [...]
> When you're confident that interaction with engines part is fine, all
> stupid bugs were fixed, go change struct utrace to pointer.  [...]

That's an idea worth considering, especially given the oopses you
found (thanks!).


> [...]
> > [...] All this code now exists in at
> > least prototype form, so if you need to see the bigger picture, look
> > that way.  Other users are anticipated, but first we need to get past
> > the chicken-and-egg.
> 
> There are no chickens and no eggs.
> 
> utrace is in RHEL4, RHEL5, FC6, FC7, FC8, FC9 kernels already.
> I can't believe RedHat allowed to totally rewrite ptrace based on some
> prototype code.

Well, that was how red hat broke the deadlock, and why RH kernels will
probably get working user-space systemtap probing earliest.


> > > This all similar to systemtap/markers story. Big changes under
> > > promises that now, now somebody will use our thing.
> > 
> > In what way do you think those promises are unfulfilled?  Systemtap
> > has interfaced to markers since the beginning,

> It just wants entry point, right?

(I don't understand what you mean.  If you mean "does systemtap just
want function entry points a la ftrace", then the answer is no, it
needs (& already has) more than that.)


> > and there are a bunch of markers in the tree.
> Total 3 in scheduler and in spufs (ppc-specific).

Some of those hits represent more via macros, but anyway, more on
their way (kmemcheck, lttng).


> Amazing improvement for ugly macros, more self-modified kernel,
> explicit reasons stated why they are stupid spelt in review and
> after entering tree, and general dislike of some maintainers to add
> more trace_mark() entries.

Regardless of the strength of technical objections/responses, there is
an ingrained cultural aspect to this that perhaps we'll break through
at the summit.

> So there were promises that markers will be useful, 10 months passed
> and they are still useless. [...]

They are already useful to their users.


- FChE
