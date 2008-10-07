Return-Path: <linux-kernel-owner+w=401wt.eu-S1754555AbYJGAcf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754555AbYJGAcf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 20:32:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752487AbYJGAc1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 20:32:27 -0400
Received: from smtp.outflux.net ([198.145.64.163]:56032 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752389AbYJGAc0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 20:32:26 -0400
Date: Mon, 6 Oct 2008 17:31:19 -0700
From: Kees Cook <kees.cook@canonical.com>
To: Roland McGrath <roland@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       Jakub Jelinek <jakub@redhat.com>, Ulrich Drepper <drepper@redhat.com>,
       libc-alpha@sourceware.org
Subject: Re: [PATCH] ELF: implement AT_RANDOM for future glibc use
Message-ID: <20081007003119.GS10357@outflux.net>
References: <48E3EFD6.2010704@redhat.com> <20081001215657.GH12527@outflux.net> <20081001220948.GC32107@sunsite.ms.mff.cuni.cz> <20081001222706.68E7E1544B4@magilla.localdomain> <20081003001616.GN10632@outflux.net> <87ej2untze.fsf@basil.nowhere.org> <20081006175038.GF10357@outflux.net> <20081006192641.GI3180@one.firstfloor.org> <20081006220759.GM10357@outflux.net> <20081006235827.59306154271@magilla.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081006235827.59306154271@magilla.localdomain>
Organization: Canonical
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 06, 2008 at 04:58:27PM -0700, Roland McGrath wrote:
> What mmap randomization and stack randomization actually use is
> get_random_int(), not get_random_bytes().  This is one of those weaker
> flavors seeded occasionally from the real entropy pool.  (As is, it's not a
> good choice for getting 16 bytes of random at once, since it usually
> returns the same 4 bytes each time when called 4 times in quick succession.)
> 
> What glibc wants is some bits with a strength of randomness chosen by the
> kernel, and not to worry about the details.  I think the strength applied
> to mmap and stack randomization is good enough for AT_RANDOM.

Is this email a vote for or against doing:

+       k_rand_bytes[0] = get_random_int();
+       k_rand_bytes[1] = get_random_int();
+       k_rand_bytes[2] = get_random_int();
+       k_rand_bytes[3] = get_random_int();

It sounds like it's not very safe, but on the other hand, glibc doesn't
really care?

-- 
Kees Cook
Ubuntu Security Team
