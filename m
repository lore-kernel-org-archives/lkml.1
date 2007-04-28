Return-Path: <linux-kernel-owner+w=401wt.eu-S1031916AbXD1R6M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031916AbXD1R6M (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 13:58:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031932AbXD1R5n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 13:57:43 -0400
Received: from waste.org ([66.93.16.53]:41174 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163307AbXD1R5c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 13:57:32 -0400
Date: Sat, 28 Apr 2007 12:44:39 -0500
From: Matt Mackall <mpm@selenic.com>
To: Matt Ranon <mranon@javadevices.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linux maillist <linux-kernel@vger.kernel.org>
Subject: Re: [ANNOUNCE][PATCH] Kcli - Kernel command line interface.
Message-ID: <20070428174439.GM11166@waste.org>
References: <617125.34935.qm@web88104.mail.re2.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <617125.34935.qm@web88104.mail.re2.yahoo.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 23, 2007 at 06:12:19PM -0700, Matt Ranon wrote:
> However, our reasons for Kcli are:
> 1) Our devices ship with no user space, and we want the development
> environment to be as close as possible to the final product.

I hope that means your devices have full source code available under
the GPL. Even if they do, kcli will probably encourage other folks to
abuse the kernel license.

> 2) Getting debug information with user space calls require context 
> switches and data copies, which changes the real time profile and can mask
> bugs.

Probably no worse than whatever I/O interface you're likely to use
with this. Reminds me of a particular "world-famous filesystem
developer" who eventually figured out that his serial console was the
cause of most of the filesystem latency glitches he was hitting.

> 3) To use user space, we would need cross compiled libc's, special
> builds of gcc, root file systems, flash storage to store it all, and all 
> sorts of things which make life a lot more complicated than it needs 
> to be for us. We are quite capable of producing all these things, but,
> we just don't see the point in it. Our way, we just have a gcc capable 
> of cross compiling the kernel and it is so simple.

Please familiarize yourself with initramfs and klibc. You can attach
an arbitrary minimal filesystem to the kernel image. You don't need a
special compiler, flash, etc., and the kernel build system will build
the filesystem image (a cpio archive) for you.

> 4) For us, it is the opposite argument. We would need to be convinced
> that having user space is worth all the overhead. Not just CPU
> overhead, but all the overheads.

Moving stuff to userspace usually has negative overhead because it's
pageable, easier to maintain, and easier to debug.

> 5) We like it in the kernel, we find it to be warm and fuzzy. Whereas,
> user space is a cold, dark, and rainy place, and we just don't want to
> go there. :)

I once spent a few weeks getting OpenSSH serving multiple clients on
vxWorks and I'm happy I'll never have to touch a kernel without
userspace again.

I think there probably is a place for some basic debugging and
introspection, including dumping address ranges, looking up symbols
and the like, but a debugger is different than a command interpreter.

-- 
Mathematics is the supreme nostalgia of our time.
