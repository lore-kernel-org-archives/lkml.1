Return-Path: <linux-kernel-owner+w=401wt.eu-S1767720AbXCJBzC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767720AbXCJBzC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 20:55:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767721AbXCJBzB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 20:55:01 -0500
Received: from waste.org ([66.93.16.53]:37570 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767720AbXCJBzA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 20:55:00 -0500
Date: Fri, 9 Mar 2007 19:42:30 -0600
From: Matt Mackall <mpm@selenic.com>
To: Con Kolivas <kernel@kolivas.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org
Subject: Re: 2.6.21-rc3-mm1 RSDL results
Message-ID: <20070310014230.GP10394@waste.org>
References: <20070309053931.GA10459@waste.org> <200703101134.26313.kernel@kolivas.org> <20070310004948.GN10394@waste.org> <200703101228.38923.kernel@kolivas.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200703101228.38923.kernel@kolivas.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 10, 2007 at 12:28:38PM +1100, Con Kolivas wrote:
> On Saturday 10 March 2007 11:49, Matt Mackall wrote:
> > On Sat, Mar 10, 2007 at 11:34:26AM +1100, Con Kolivas wrote:
> > > Ok, so some of the basics then. Can you please give me the output of 'top
> > > -b' running for a few seconds during the whole affair?
> >
> > Here you go:
> >
> > http://selenic.com/baseline
> > http://selenic.com/underload
> >
> > This is with 2.6.20+rsdl+tickfix at HZ=250.
> >
> > Something I haven't mentioned about my setup is that I'm using ccache.
> > And it turns out disabling ccache makes a large difference. Going to
> > switch back to a NO_HZ kernel and see what that looks like.
> 
> Your X is reniced to -10 so.... try again with X nice 0 please.

Doh, can't believe I didn't notice that. That's apparently a default
in Debian/unstable (not sure where to tweak it). Reniced:

             without ccache    with ccache
make -j 5 
 beryl       good              ok
 galeon      ok/good           ok
 mp3         good              good
 terminal    good              ok
 mouse       good              ok

We're still left with a big unexplained ccache differential, and a big
NO_HZ vs HZ=250 differential.

-- 
Mathematics is the supreme nostalgia of our time.
