Return-Path: <linux-kernel-owner+w=401wt.eu-S1753290AbZAFCCW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753290AbZAFCCW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 21:02:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751544AbZAFCCM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 21:02:12 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:43341 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751496AbZAFCCM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 21:02:12 -0500
Date: Mon, 5 Jan 2009 21:02:07 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Rusty Russell <rusty@rustcorp.com.au>
cc: Sam Ravnborg <sam@ravnborg.org>, LKML <linux-kernel@vger.kernel.org>,
       Steven Rostedt <srostedt@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       "David S. Miller" <davem@davemloft.net>,
       sparclinux <sparclinux@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] module: clean up initialization of variable
In-Reply-To: <200901061152.51782.rusty@rustcorp.com.au>
Message-ID: <alpine.DEB.1.10.0901052059390.16409@gandalf.stny.rr.com>
References: <20090105181922.GA25622@uranus.ravnborg.org> <20090105195415.GA6204@uranus.ravnborg.org> <alpine.DEB.1.10.0901051523370.25066@gandalf.stny.rr.com> <200901061152.51782.rusty@rustcorp.com.au>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 6 Jan 2009, Rusty Russell wrote:

> On Tuesday 06 January 2009 07:00:25 Steven Rostedt wrote:
> > This is sloppy initialization because it initializes, not only in an
> > if condition, but also as the second part of a complex conditional.
> > 
> > This patch makes the code a bit easier to read.
> ...
> >  	/* Suck in entire file: we'll want most of it. */
> >  	/* vmalloc barfs on "unusual" numbers.  Check here */
> > -	if (len > 64 * 1024 * 1024 || (hdr = vmalloc(len)) == NULL)
> > +	if (len > 64 * 1024 * 1024)
> > +		return ERR_PTR(-ENOMEM);
> > +	hdr = vmalloc(len);
> > +	if (hdr == NULL)
> >  		return ERR_PTR(-ENOMEM);
> >  	if (copy_from_user(hdr, umod, len) != 0) {
> >  		err = -EFAULT;
> 
> This line is not accidental nor casually written: the two statements 
> are deliberately entwined.  It is a succint complaint against the 
> vagaries of vmalloc.
> 
> So this patch is a messup, not a cleanup.

It is not that much of a messup. I did not realize that the code was
a political protest against the horrors of vmalloc ;-)

> 
> But it's really upset me because it is lazy and timid: and too much 
> kernel code is becoming mired in such scars.  Instead of "how do I kill 
> this warning and get it in the merge window" you should be thinking "how 
> do I make the kernel better", and "I wonder if vmalloc still has this 
> problem"...
> 
> And I so look forward to the warm fuzzies I get when applying a real 
> cleanup patch.

Well, I'm not about to go solve the vmalloc issues (not today anyway). But 
I'll go and see if I can get the branch tracer macro to work on all 
versions of gcc.

Thanks,

-- Steve

