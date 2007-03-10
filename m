Return-Path: <linux-kernel-owner+w=401wt.eu-S1752777AbXCJCUo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752777AbXCJCUo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 21:20:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752796AbXCJCUo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 21:20:44 -0500
Received: from mail20.syd.optusnet.com.au ([211.29.132.201]:37127 "EHLO
	mail20.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752777AbXCJCUn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 21:20:43 -0500
From: Con Kolivas <kernel@kolivas.org>
To: Matt Mackall <mpm@selenic.com>
Subject: Re: 2.6.21-rc3-mm1 RSDL results
Date: Sat, 10 Mar 2007 13:20:22 +1100
User-Agent: KMail/1.9.5
Cc: linux-kernel <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org
References: <20070309053931.GA10459@waste.org> <200703101228.38923.kernel@kolivas.org> <20070310014230.GP10394@waste.org>
In-Reply-To: <20070310014230.GP10394@waste.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703101320.23125.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 10 March 2007 12:42, Matt Mackall wrote:
> On Sat, Mar 10, 2007 at 12:28:38PM +1100, Con Kolivas wrote:
> > On Saturday 10 March 2007 11:49, Matt Mackall wrote:
> > > On Sat, Mar 10, 2007 at 11:34:26AM +1100, Con Kolivas wrote:
> > > > Ok, so some of the basics then. Can you please give me the output of
> > > > 'top -b' running for a few seconds during the whole affair?
> > >
> > > Here you go:
> > >
> > > http://selenic.com/baseline
> > > http://selenic.com/underload
> > >
> > > This is with 2.6.20+rsdl+tickfix at HZ=250.
> > >
> > > Something I haven't mentioned about my setup is that I'm using ccache.
> > > And it turns out disabling ccache makes a large difference. Going to
> > > switch back to a NO_HZ kernel and see what that looks like.
> >
> > Your X is reniced to -10 so.... try again with X nice 0 please.
>
> Doh, can't believe I didn't notice that. That's apparently a default
> in Debian/unstable (not sure where to tweak it).

See other email from Kyle on how to dpkg reconfigure. I submitted a bug report 
to debian years ago about this and I presume it was fixed but you've probably 
slowly dist upgraded from an older version and it stayed in your config?

> Reniced: 
>
>              without ccache    with ccache
> make -j 5
>  beryl       good              ok
>  galeon      ok/good           ok
>  mp3         good              good
>  terminal    good              ok
>  mouse       good              ok

Progress at last! And without any patches! Well those look very reasonable to 
me. Especially since -j5 is a worst case scenario.

> We're still left with a big unexplained ccache differential,

But would you say it's still _adequate_ with ccache considering you only have 
1/6th cpu left for X? With and without ccache it's quite a different workload 
so they will behave differently.

> and a big 
> NO_HZ vs HZ=250 differential.

That part I don't know about. You've only tested the difference with X running 
nice -10. I need to look further at the mechanism for -nice tasks. It should 
be possible to run smoothly even with a -niced X (although that was never my 
intent) so perhaps that's not working properly. I'll look into that.

Thanks!

-- 
-ck
