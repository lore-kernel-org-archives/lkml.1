Return-Path: <linux-kernel-owner+w=401wt.eu-S1755543AbXFYDph@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755543AbXFYDph (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2007 23:45:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752936AbXFYDpb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jun 2007 23:45:31 -0400
Received: from waste.org ([66.93.16.53]:37480 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752899AbXFYDpa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2007 23:45:30 -0400
Date: Sun, 24 Jun 2007 22:45:08 -0500
From: Matt Mackall <mpm@selenic.com>
To: Alexander Gabert <pappy@gentoo.org>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       Arjan van de Ven <arjan@infradead.org>, libc-alpha@sourceware.org,
       hardened@gentoo.org
Subject: Re: [PATCH] get_random_long() and AT_ENTROPY for auxv, kernel 2.6.21.5
Message-ID: <20070625034508.GE11115@waste.org>
References: <4675C678.3080807@gentoo.org> <1182128803.22999.9.camel@laptopd505.fenrus.org> <20070620203022.GO11166@waste.org> <467EADA0.9020101@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <467EADA0.9020101@gentoo.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 24, 2007 at 07:45:04PM +0200, Alexander Gabert wrote:
> Hi Linus,
> hi LKML,
> 
> i would like to thank LKML and especially Eric (thanks for the per_cpu 
> macro tips and design guidelines!) and the other contributors to this idea.
> 
> This time the patch is rather big because it also removes 
> get_random_int() and introduces get_random_long() throughout the kernel.

Stop right there. You still haven't answered my original question.
What is the point of this exercise in the first place, please?

Am I right in thinking you have three unrelated patches here?

- something to do with aux vector headers
- something to do with get_random_int repeating itself
- sweeping change of get_random_int to get_random_long for no obvious reason

These should be three completely separate patches.

> My findings with get_random_int was that when i called it two times very 
> fast after another because of setting up two SSP randomized guard values 
> for the same process, it returned the same, yet randomized, integer number.

Send me a patch that fixes the above and nothing else, please.

Then we can talk about another patch to change things to get_random_long.

> --- linux-2.6.21.5.ORIG/arch/sparc64/kernel/sys_sparc.c	2007-06-11 
> 20:37:06.000000000 +0200
> +++ linux-2.6.21.5/arch/sparc64/kernel/sys_sparc.c	2007-06-24 
> 19:01:44.000000000 +0200
> @@ -362,7 +362,7 @@
> 	unsigned long random_factor = 0UL;
> 
> 	if (current->flags & PF_RANDOMIZE) {
> -		random_factor = get_random_int();
> +		random_factor = get_random_long();

This probably breaks Sparc64.

-- 
Mathematics is the supreme nostalgia of our time.
