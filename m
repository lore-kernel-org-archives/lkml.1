Return-Path: <linux-kernel-owner+w=401wt.eu-S1758907AbYJFXck@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758907AbYJFXck (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 19:32:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757184AbYJFXah
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 19:30:37 -0400
Received: from smtp.outflux.net ([198.145.64.163]:42647 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758559AbYJFXag (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 19:30:36 -0400
Date: Mon, 6 Oct 2008 16:29:36 -0700
From: Kees Cook <kees.cook@canonical.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org,
       Jakub Jelinek <jakub@redhat.com>, Ulrich Drepper <drepper@redhat.com>,
       libc-alpha@sourceware.org
Subject: Re: [PATCH] ELF: implement AT_RANDOM for future glibc use
Message-ID: <20081006232936.GR10357@outflux.net>
References: <48E3EFD6.2010704@redhat.com> <20081001215657.GH12527@outflux.net> <20081001220948.GC32107@sunsite.ms.mff.cuni.cz> <20081001222706.68E7E1544B4@magilla.localdomain> <20081003001616.GN10632@outflux.net> <87ej2untze.fsf@basil.nowhere.org> <20081006175038.GF10357@outflux.net> <20081006192641.GI3180@one.firstfloor.org> <20081006220101.GK10357@outflux.net> <20081006231942.GO3180@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081006231942.GO3180@one.firstfloor.org>
Organization: Canonical
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 07, 2008 at 01:19:42AM +0200, Andi Kleen wrote:
> And you won't deny that session keys are more important than mmap
> placement, will you?

Right, I would tend to agree that session key strength is more important
than ASLR strength.

> > I'd really love to see this solved.  My goal is to get a mainline glibc
> > patch for a low-cost randomized stack guard value.
> 
> Your current implementation is high cost.
>...
> random32() is not a cryptographically strong RNG. I suspect it would
> be pretty easy to reverse engineer its seed given some state. It hasn't
> been designed to be protected against that.

It's being used for randomness in the networking code, so it's at least
mildly random "enough".

> IMHO it needs a new class of random numbers in the kernel that use
> some cryptographically strong RNG (there are a couple of candidates
> like yarrow) which is very rarely seeded
> from the entropy pool[1] and use that for these applications.
> A couple of other users in the kernel would benefit that too,
> most users of get_random_bytes() probably should be reviewed
> for their true requirements.

Sure, but this is a larger (and pre-existing) problem.

> Ideally expose it to userland too so that dumb users like
> tmpfile can use it too. 

Would you propose that it get hooked to /dev/urandom?

-Kees

-- 
Kees Cook
Ubuntu Security Team
