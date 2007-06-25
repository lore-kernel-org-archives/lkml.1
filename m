Return-Path: <linux-kernel-owner+w=401wt.eu-S1756688AbXFYFMj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756688AbXFYFMj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 01:12:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751136AbXFYFMc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 01:12:32 -0400
Received: from waste.org ([66.93.16.53]:33477 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752953AbXFYFMb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 01:12:31 -0400
Date: Mon, 25 Jun 2007 00:12:10 -0500
From: Matt Mackall <mpm@selenic.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Alexander Gabert <pappy@gentoo.org>, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, libc-alpha@sourceware.org,
       hardened@gentoo.org
Subject: Re: [PATCH] get_random_long() and AT_ENTROPY for auxv, kernel 2.6.21.5
Message-ID: <20070625051210.GF11115@waste.org>
References: <4675C678.3080807@gentoo.org> <1182128803.22999.9.camel@laptopd505.fenrus.org> <20070620203022.GO11166@waste.org> <467EADA0.9020101@gentoo.org> <20070625034508.GE11115@waste.org> <1182746583.26621.5.camel@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1182746583.26621.5.camel@laptopd505.fenrus.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 24, 2007 at 09:43:03PM -0700, Arjan van de Ven wrote:
> On Sun, 2007-06-24 at 22:45 -0500, Matt Mackall wrote:
> > On Sun, Jun 24, 2007 at 07:45:04PM +0200, Alexander Gabert wrote:
> > > Hi Linus,
> > > hi LKML,
> > > 
> > > i would like to thank LKML and especially Eric (thanks for the per_cpu 
> > > macro tips and design guidelines!) and the other contributors to this idea.
> > > 
> > > This time the patch is rather big because it also removes 
> > > get_random_int() and introduces get_random_long() throughout the kernel.
> > 
> > Stop right there. You still haven't answered my original question.
> > What is the point of this exercise in the first place, please?
> > 
> > Am I right in thinking you have three unrelated patches here?
> > 
> > - something to do with aux vector headers
> 
> the primary goal is to pass a random value to userspace at process
> start; this to save glibc from having to open /dev/urandom on ever
> program start (which it does now for all apps compiled with
> -fstack-protector, which in various distros is "everything").

Interesting.

What are our requirements here? Defending against local attackers who
can build exploits on the fly probably means something stronger than get_random_int.
 
> > - sweeping change of get_random_int to get_random_long for no obvious reason
> 
> and this is because Alexander wants 2 and not 1 random int to be passed
> for his own glibc proposed change (combined with get_random_int() being
> designed for only 4 bytes per process ;-)

Sure. Still, separate patches.

-- 
Mathematics is the supreme nostalgia of our time.
