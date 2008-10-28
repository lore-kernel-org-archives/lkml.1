Return-Path: <linux-kernel-owner+w=401wt.eu-S1752751AbYJ1EyI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752751AbYJ1EyI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 00:54:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751554AbYJ1Exz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 00:53:55 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49140 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751509AbYJ1Exy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 00:53:54 -0400
Date: Mon, 27 Oct 2008 21:52:49 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ulrich Drepper <drepper@redhat.com>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       linux-api@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: [PATCH] reintroduce accept4
Message-Id: <20081027215249.dca00b6b.akpm@linux-foundation.org>
In-Reply-To: <490693A3.9070805@redhat.com>
References: <200810261641.m9QGfotr024285@hs20-bc2-1.build.redhat.com>
	<20081027204135.a139704e.akpm@linux-foundation.org>
	<490693A3.9070805@redhat.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(really does cc linux-arch this time)

On Mon, 27 Oct 2008 21:22:59 -0700 Ulrich Drepper <drepper@redhat.com> wrote:

> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> Andrew Morton wrote:
> > I'll confess to not having a clue what's going on here.
> 
> It has been discussed at length.

That's of little use to people trying to understand the git commit.

And it's of little use to people who write the documentation. 
Hopefully Michael has been following this closely enough to get by with
what we have here (ie: nothing).

And it's of little use to people who are trying to review this patch
and who haven't followed this alleged lengthy discussion. (ie: me)

And it's of little use to people who write for sites such as lwn.net,
http://kernelnewbies.org/LinuxChanges etc.

This is not some personal weekend hack project.  It is the Linux
kernel, used by millions around the world.

>  accept created file descriptors and we
> need flags for tis.
> 
> >> #elif __i386__
> >> #define SYS_ACCEPT4     18
> >> #define USE_SOCKETCALL 1
> >> #define SOCK_CLOEXEC O_CLOEXEC
> >> #else
> > 
> > Well.  This doesn't actually agree with the kernel patch.
> 
> What doesn't agree?
> 
> 
> > I'd suggest that i386 is sufficiently common to warrant its inclusion
> > in the initial patch.
> 
> The x86 code is included.  x86 uses socketcall instead of a syscall.

<wonders why arch/x86/include/asm/unistd_64.h defines
__ARCH_WANT_SYS_SOCKETCALL but doesn't wire up sys_socketcall()>

> I changed all paccept occurrences in the tree, not just x86-64.

OK, that covered a lot of architectures.
