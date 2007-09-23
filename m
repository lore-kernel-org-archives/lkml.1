Return-Path: <linux-kernel-owner+w=401wt.eu-S1757786AbXIWQqk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757786AbXIWQqk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Sep 2007 12:46:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752717AbXIWQqc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Sep 2007 12:46:32 -0400
Received: from an-out-0708.google.com ([209.85.132.247]:20075 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752680AbXIWQqb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Sep 2007 12:46:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:mail-followup-to:references:mime-version:content-type:content-disposition:in-reply-to:x-url:organization:user-agent:sender;
        b=Qr8KvkOYwrz3+dt87mETtP2GtJEmvSDGQ9CGCABt8wt/a89DB6s84WOizOiWGNtS4COJgsjBELZEOe9b3GXl8qYViF4lVmlPeNV4lAxix75A77IbkjAUZBT0PftCtIRNVPcGkmR2lF32scpsfpMg6YXG6gH3lImsCiD2OcHg2Qc=
Date: Sun, 23 Sep 2007 13:46:22 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: "Robert P. J. Day" <rpjday@mindspring.com>
Cc: Dave Jones <davej@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Cyrill Gorcunov <gorcunov@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: memset as memzero
Message-ID: <20070923164622.GA3766@ghostprotocols.net>
Mail-Followup-To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
	"Robert P. J. Day" <rpjday@mindspring.com>,
	Dave Jones <davej@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Arjan van de Ven <arjan@infradead.org>,
	Cyrill Gorcunov <gorcunov@gmail.com>,
	LKML <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Ingo Molnar <mingo@elte.hu>
References: <20070922083355.GA7226@cvg> <20070922124659.741cca42@laptopd505.fenrus.org> <alpine.LFD.0.999.0709221149480.16478@woody.linux-foundation.org> <20070923153243.GE8127@redhat.com> <Pine.LNX.4.64.0709231226140.14224@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0709231226140.14224@localhost.localdomain>
X-Url: http://oops.ghostprotocols.net:81/blog
Organization: OOPS Labs
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Em Sun, Sep 23, 2007 at 12:33:13PM -0400, Robert P. J. Day escreveu:
> On Sun, 23 Sep 2007, Dave Jones wrote:
> 
> > There is one useful argument for memzero (or bzero to give it its
> > proper name), and that's that it's impossible to screw up. I'm still
> > amazed at how many times I see
> >
> > 	memset (x,size,0);
> >
> > in various code. So much so, that my editor highlights it now to
> > spot it during code review.  As does my mail client.  To be on the
> > safe side, I also have a cron job grepping for it in my
> > ~/Mail/commits for all the projects I'm interested in.
> 
>   taking a step back, regardless of what constitutes a sane versus
> not-sane definition of a useful macro, i think a lot of the content of
> kernel.h could be moved out of there and put in a more appropriate
> header file called, say, macros.h.
> 
>   the first comment in kernel.h claims that
> 
> /*
>  * 'kernel.h' contains some often-used function prototypes etc
>  */
> 
> but there's buckets more stuff in there than just some function
> prototypes.  macros for type limits, alignment, array sizes, rounding,
> and on and on.  and as for those prototypes, is there any reason that
> kernel.h includes them explicitly for the contents of lib/vsprintf.c
> rather than just including, say, a hypothetical vsprintf.h?  just
> curious.
> 
> in any case, it would seem that kernel.h could stand a good cleaning.
> it give the impression of just being an arbitrary dumping ground when
> folks can't figure out where to put something.

In an ideal world kernel.h has no place, I guess. I guess too that
janitors could make the world ideal in that respect. Keep moving things
from there to the right place. Don't do it every other day tho. People
find it annoying.

- Arnaldo
