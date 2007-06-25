Return-Path: <linux-kernel-owner+w=401wt.eu-S1755468AbXFYWUo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755468AbXFYWUo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 18:20:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754571AbXFYWU3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 18:20:29 -0400
Received: from nz-out-0506.google.com ([64.233.162.229]:5923 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754301AbXFYWU2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 18:20:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=mdLPZlfAZj+ZsV6j1VQhuGTibSCpZcIZDshtZtEUYiDp9M+lXYLhC9smyXTwJVeRpri389+aTkGG7LIAKRbFVEOeUd9Uhp1NHIDVeLH0WK06dyLa2DqSBZd3XPxzxQjG7qPzobNCNN85ydh3QiLqoVud6MavG5dcT4/WGL8ER+Y=
Message-ID: <9a8748490706251520g24ff7a9dk716d73e7dbfd9ec3@mail.gmail.com>
Date: Tue, 26 Jun 2007 00:20:27 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "Roman Zippel" <zippel@linux-m68k.org>
Subject: Re: [patch, v2.6.22-rc6] sys_time() speedup
Cc: "Ingo Molnar" <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "John Stultz" <johnstul@us.ibm.com>,
       "Thomas Gleixner" <tglx@linutronix.de>
In-Reply-To: <Pine.LNX.4.64.0706252356400.1817@scrub.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070625200601.GA18980@elte.hu>
	 <200706252309.47467.zippel@linux-m68k.org>
	 <9a8748490706251417v10b3f24bwdf7ebd44093eaddf@mail.gmail.com>
	 <Pine.LNX.4.64.0706252356400.1817@scrub.home>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 26/06/07, Roman Zippel <zippel@linux-m68k.org> wrote:
> Hi,
>
> On Mon, 25 Jun 2007, Jesper Juhl wrote:
>
> > > On Monday 25 June 2007, Ingo Molnar wrote:
> > >
> > > > the patch improves the sysbench OLTP macrobenchmark significantly:
> > >
> > > Has that any real practical relevance?
> > >
> > It seems to me that Ingo's patch offers slightly improved performance
> > for any program using the time() system call, with no real drawbacks,
> > so why wouldn't we want to use it?
>
> How do you come to the conclusion it has no real drawbacks?

His change to do_gettimeofday() will of course slow that path down a
tiny bit since he's adding an extra 'if', but since it's wrapped in
unlikely() and should hit at most one time pr second I would guess the
performance impact of that to be negligible.
The change to sys_time() does away with some local variables and
replaces the call to do_gettimeofday() with a memory barrier and a
simple read of xtime.tv_se. I find it hard to believe (although I have
not tested it) that that wouldn't be faster than the original.

So that's how I came to that conclusion; just reading the patch, going
over what it does in my head and thinking about it a bit.  Not the
most scientific of things I admit.

Even if it is not faster, what would make it slower?  Have you spotted
something I have not?

> Ingo provided no information about his test setup and his patch was a
> little strange, so I can't say that yet.
>
What did you find strange about it? I'm currious.
Sure it needs testing and of course it would be nice with some more
details on Ingo's test setup.


-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
