Return-Path: <linux-kernel-owner+w=401wt.eu-S1754680AbYJFRwA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754680AbYJFRwA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 13:52:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753217AbYJFRvw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 13:51:52 -0400
Received: from smtp.outflux.net ([198.145.64.163]:48839 "EHLO
	vinyl.outflux.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753125AbYJFRvt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 13:51:49 -0400
Date: Mon, 6 Oct 2008 10:50:38 -0700
From: Kees Cook <kees.cook@canonical.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org,
       Jakub Jelinek <jakub@redhat.com>, Ulrich Drepper <drepper@redhat.com>,
       libc-alpha@sourceware.org
Subject: Re: [PATCH] ELF: implement AT_RANDOM for future glibc use
Message-ID: <20081006175038.GF10357@outflux.net>
References: <20081001201116.GD12527@outflux.net> <48E3EFD6.2010704@redhat.com> <20081001215657.GH12527@outflux.net> <20081001220948.GC32107@sunsite.ms.mff.cuni.cz> <20081001222706.68E7E1544B4@magilla.localdomain> <20081003001616.GN10632@outflux.net> <87ej2untze.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ej2untze.fsf@basil.nowhere.org>
Organization: Canonical
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 06, 2008 at 08:00:21AM +0200, Andi Kleen wrote:
> Kees Cook <kees.cook@canonical.com> writes:
> 
> > While discussing[1] the need for glibc to have access to random bytes
> > during program load, it seems that an earlier attempt to implement
> > AT_RANDOM got stalled.  This implements a configurable number of random
> > bytes available to every ELF program via a new auxv AT_RANDOM vector.
> 
> While the basic idea is good using get_random_bytes() is not.
> 
> That eats precious cryptography strength entropy from the entropy
> pool, which on many systems is not adequately fed. In those cases you
> really only want to use it for real keys, not for lower grade
> applications. The applications glibc wants to use this for do not
> really require crypto strength entropy, just relatively unpredictable
> randomness.

We're already using get_random* for stack, heap, and brk.  Also,
get_random* uses the nonblocking pool, so this is the same as if userspace
had tried to pull bytes out of /dev/urandom, which (as I understand it)
is the very thing we're trying to duplicate without the VFS overhead.

> What you should instead do is to initialize some other cryptographic RNG
> regularly and use the output of that.

Can you give me some examples of this?  I thought the nonblocking
entropy pool was specifically for this purpose?

-Kees

-- 
Kees Cook
Ubuntu Security Team
